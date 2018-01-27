//
//  ImageProfileInnerView.swift
//  Benefactor
//
//  Created by MacBook Pro on 2/16/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit

class ImageProfileInnerView: UIView {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var followButton:UIButton?
    @IBOutlet weak var imgHeightLayout:NSLayoutConstraint!
    @IBOutlet weak var imgTopLayout:NSLayoutConstraint!
    @IBOutlet weak var nameTopLayout:NSLayoutConstraint!
    @IBOutlet weak var cityTopLayout:NSLayoutConstraint!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        switch UIDevice.modelFromSize() {
        case .iPhone4:
            imgTopLayout.constant = 8
            imgHeightLayout.constant = 65
            nameTopLayout.constant = 5
            cityTopLayout.constant = 5
        case .iPhone5:
            imgTopLayout.constant = 8
            imgHeightLayout.constant = 70
            nameTopLayout.constant = 5
            cityTopLayout.constant = 5
        case .iPhone6Plus:
            imgTopLayout.constant = 20
            imgHeightLayout.constant = 90
            nameTopLayout.constant = 15
            cityTopLayout.constant = 15
            
        default:
            imgTopLayout.constant = 8
            
        }
        self.backgroundColor = UIColor.clear
        nameLabel.customizeFont()
        cityLabel.customizeFont()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imgView.circleViewBorders()
        if let btn = followButton
        {
            btn.addCorneredBorder(color: UIColor(red: 0.83984375, green: 0.83984375, blue: 0.83984375, alpha: 1), radius: 18)
        }
    }
    func loadUser(user:DTOUser)
    {
        if let image = user.user_image
        {
            imgView.imageProfile(fromString: image)
        }
        nameLabel.text = user.displayName
        cityLabel.text = ""
        if user.user_id == DTOUser.currentUser()?.user_id {
            followButton?.isHidden = true
        }else
        {
            if user.user_isFollowed == true {
                followButton?.setTitle("Unfollow", for: .normal)
            }else
            {
                followButton?.setTitle("Follow", for: .normal)
            }
        }
        
    }
    
    
}
