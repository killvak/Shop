//
//  detailedProductOwnerTableViewCell.swift
//  Benefactor
//
//  Created by MacBook Pro on 2/15/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit

class detailedProductOwnerTableViewCell: UITableViewCell {

    @IBOutlet weak var detailsLabel: UILabel!
//    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
//    @IBOutlet weak var imgView: UIImageView!
//    @IBOutlet weak var followButton: UIButton!
    
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var paymentLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        //
        detailsLabel.customizeFont()
        nameLabel.customizeFont()
//        dateLabel.customizeFont()
        priceLbl.customizeFont()
        paymentLbl.customizeFont()

//        followButton.titleLabel?.customizeFont()
        //
//        followButton.addCorneredBorder(color: UIColor(rgba: "#51509d"), radius: 12)
//        self.imgView.isHidden = true
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//            self.imgView.circleViewBorders()
//            self.imgView.isHidden = false
//        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func loadProduct(_ product:DTOProduct,_ owner:DTOUser)
    {
//        if let src = owner.user_image
//        {
//            imgView.imageProfile(fromString: src)
//
//        }
        nameLabel.text = owner.displayName
//        dateLabel.text = product.product_dateStringLong
        detailsLabel.text = product.product_description
//        if owner.user_id == DTOUser.currentUser()?.user_id {
//            followButton.isHidden = true
//        }else
//        {
//            if owner.user_isFollowed == true {
//                followButton.setTitle("Unfollow", for: .normal)
//            }else
//            {
//                followButton.setTitle("Follow", for: .normal)
//            }
//        }
    }
}
