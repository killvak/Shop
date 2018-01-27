//
//  detailedProductImageTableViewCell.swift
//  Benefactor
//
//  Created by MacBook Pro on 2/15/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit

class detailedProductImageTableViewCell: UITableViewCell,UIScrollViewDelegate {
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var viewCountLabel: UILabel!
    @IBOutlet weak var viewLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var mileLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var aspectLayout: NSLayoutConstraint!
    weak var ownerVC:DetailedProductViewController?
    var scrollTimer:Timer?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        viewCountLabel.customizeFont()
        viewLabel.customizeFont()
        distanceLabel.customizeFont()
        mileLabel.customizeFont()
        likeCountLabel.customizeFont()
        likeLabel.customizeFont()
        //
        mileLabel.text = DistanceHandler.sharedManager.unit
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        imageScrollView.subviews.forEach({ $0.removeFromSuperview() })
    }
    func loadProduct(_ product:DTOProduct)
    {
        likeCountLabel.text = String(product.product_likesCount)
        distanceLabel.text = product.product_distance 
        // views
        if product.product_viewsCount > 1000 {
            let countFloat = Float(product.product_viewsCount) / 1000
            let countInt = Int(round(countFloat))
            viewCountLabel.text = String(countInt) + "K"
        }else
        {
            viewCountLabel.text = String(product.product_viewsCount)
        }
        //images
        loadImages(product: product)
    }
    private func loadImages(product:DTOProduct)
    {
        var subviews = [UIView]()
        let itemWidth = SCREEN_WIDTH
        let itemHeight = SCREEN_WIDTH / aspectLayout.multiplier
        var xCounter : CGFloat = 0
        if let arr = product.product_images
        {
            for link in arr
            {
                let innerImgView = UIImageView(frame: CGRect(x: xCounter, y: 0, width: itemWidth, height: itemHeight))
                xCounter = xCounter + itemWidth
                innerImgView.contentMode = .scaleAspectFill
                innerImgView.imageRegular(fromString: link.image_urlString)
                subviews.append(innerImgView)
            }
        }else
        {
            let innerImgView = UIImageView(frame: CGRect(x: xCounter, y: 0, width: itemWidth, height: itemHeight))
            xCounter = xCounter + itemWidth
            innerImgView.contentMode = .scaleAspectFill
            innerImgView.image = UIImage(named:"defaultImage")
            subviews.append(innerImgView)
        }
        if subviews.count > 1
        {
            pageControl.numberOfPages = subviews.count
            autoScroll()

        }else
        {
            pageControl.isHidden = true
        }
        for vv in subviews
        {
            vv.tag = subviews.index(of: vv)!
            imageScrollView.addSubview(vv)
            let tap = UITapGestureRecognizer(target: self, action: #selector(detailedProductImageTableViewCell.imageClicked(_:)))
            vv.addGestureRecognizer(tap)
            vv.isUserInteractionEnabled = true
        }
        imageScrollView.contentSize = CGSize(width: xCounter, height: itemHeight)
        imageScrollView.delegate = self

    }
    //MARK:- Page + scroll
    func imageClicked(_ gesture:UITapGestureRecognizer)
    {
        if let vc = ownerVC , let idx = gesture.view?.tag
        {
            vc.openFullScreen(index: idx)
        }
        
    }
    @IBAction func pageControlValueChanged(_ sender:UIPageControl)
    {
        let itemWidth = imageScrollView.frame.size.width
        let itemHeight = imageScrollView.frame.size.height
        imageScrollView.scrollRectToVisible(CGRect(x: CGFloat(sender.currentPage) * itemWidth , y: 0, width: itemWidth, height: itemHeight), animated: true)
        autoScroll()
        
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        pageControl.currentPage = Int(x/w)
        autoScroll()

    }
    func autoScroll()
    {
        if pageControl.isHidden {
            return
        }
        if scrollTimer != nil {
            scrollTimer?.invalidate()
            scrollTimer = nil
        }
        scrollTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(detailedProductImageTableViewCell.autoScrollHandler), userInfo: nil, repeats: true)
        
    }
    func autoScrollHandler()
    {
        var nextIndex = pageControl.currentPage + 1
        if (nextIndex < pageControl.numberOfPages) == false
        {
            nextIndex = 0
        }
        pageControl.currentPage = nextIndex
        self.pageControlValueChanged(pageControl)
    }


}
