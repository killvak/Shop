//
//  ProfileHeaderView.swift
//  Benefactor
//
//  Created by MacBook Pro on 2/16/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit

class MyProfileHeaderView: OtherProfileHeaderView ,UIScrollViewDelegate{

    @IBOutlet weak var secondSlideView: NumbersProfileInnerView!
    @IBOutlet weak var scrlView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!

    override func awakeFromNib() {
        super.awakeFromNib()
        scrlView.isPagingEnabled = true
        scrlView.delegate = self
    }
    override func loadUser(user:DTOUser)
    {
        super.loadUser(user: user)
        secondSlideView.loadUser(user: user)
    }
    //MARK:- Page + scroll
    @IBAction func pageControlChanged(_ sender: UIPageControl) {
        let itemWidth = scrlView.frame.size.width
        let itemHeight = scrlView.frame.size.height
        scrlView.scrollRectToVisible(CGRect(x: CGFloat(sender.currentPage) * itemWidth , y: 0, width: itemWidth, height: itemHeight), animated: true)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        pageControl.currentPage = Int(x/w)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
