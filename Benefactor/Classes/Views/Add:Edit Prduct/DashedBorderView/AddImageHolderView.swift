//
//  DashedBorderView.swift
//  Benefactor
//
//  Created by MacBook Pro on 2/18/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit
import MisterFusion

class AddImageHolderView: UIView {
    
    
    let _border = CAShapeLayer()
    weak var imageView:UIImageView!
    weak var deleteButton:UIButton!
//    weak var deleteButton:UIImageView!
    weak var tapGesture:UITapGestureRecognizer?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    init() {
        super.init(frame: CGRect.zero)
        setup()
    }
    
    func setup() {
        //
        let imgView = UIImageView(frame:CGRect(x: 0, y: 0, width: 150, height: 150))
        _ = self.addLayoutSubview(imgView, andConstraints: [imgView.top |+| 10,
                                                            imgView.bottom |-| 10,
                                                            imgView.leading |+| 10,
                                                            imgView.trailing |-| 10])
        imgView.image = UIImage(named:"plusImage")
        imgView.contentMode = .center
        imgView.clipsToBounds = true
        imageView = imgView
//        imageView.circleView()
        imageView.layer.cornerRadius = self.frame.size.width / 2
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        //
        let btn = UIButton(type:.custom)
        btn.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        btn.backgroundColor = .red
        btn.titleLabel?.customizeBoldFont()
        btn.setTitle("X", for: .normal)
        btn.circleView()
        _ = self.addLayoutSubview(btn, andConstraints: [btn.top |+| 9,
                                                        btn.trailing |-| 8,
                                                        btn.width |==| 20,
                                                        btn.height |==| 20])
        deleteButton = btn
        //
        setUpBorder()
        //
        self.backgroundColor = .clear
        //
//        imageView.addCorneredBorder(color: .clear, radius: 8)

    }
    func setUpBorder()
    {
        _border.strokeColor = UIColor(rgba:"#888888").cgColor
        _border.fillColor = nil
        _border.lineDashPattern = [4, 4]
        self.layer.addSublayer(_border)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        _border.path = UIBezierPath(roundedRect: self.bounds, cornerRadius:8).cgPath
        _border.frame = self.bounds
    }
    func initialState(target: Any?, action: Selector?)
    {
        _border.isHidden = false
        imageView.contentMode = .center
        imageView.image = UIImage(named:"plusImage")
        deleteButton.isHidden = true
        let tap = UITapGestureRecognizer(target: target, action: action)
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
        tapGesture = tap
        
    }
    func loadImage(image:UIImage,target: Any?, action: Selector,tag:Int)
    {
        _border.isHidden = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = image
        deleteButton.isHidden = false
        deleteButton.tag = tag
        deleteButton.addTarget(target, action: action, for: .touchUpInside)
        if tapGesture != nil {
            imageView.removeGestureRecognizer(tapGesture!)
            tapGesture = nil
        }
    }
    func loadImage(urlString:String,target: Any?, action: Selector,tag:Int)
    {
        imageView.image = nil
        _border.isHidden = true
        imageView.contentMode = .scaleAspectFill
        imageView.imageRegular(fromString: urlString)
        deleteButton.isHidden = false
        deleteButton.tag = tag
        deleteButton.addTarget(target, action: action, for: .touchUpInside)
        if tapGesture != nil {
            imageView.removeGestureRecognizer(tapGesture!)
            tapGesture = nil
        }
    }
}
