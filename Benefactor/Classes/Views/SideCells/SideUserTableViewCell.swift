//
//  SideUserTableViewCell.swift
//  Benefactor
//
//  Created by MacBook Pro on 1/2/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit

class SideUserTableViewCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var actionBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nameLbl.customizeFont()
        locationLabel.customizeFont()
        actionBtn.titleLabel?.customizeFont()
        let radius:CGFloat = (UIDevice.modelFromSize() == .iPad) ? 19 : 15
        actionBtn.addCorneredBorder(color: UIColor.clear, radius: radius)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        imgView.circleViewBorders()
        if let user = DTOUser.currentUser() {
            nameLbl.text = user.displayName
            if let image = user.user_image
            {
                imgView.imageProfile(fromString: image)
            }
//            if let city = user.user_cityName
//            {
                locationLabel.text = ""
//            }else
//            {
//                locationLabel.text = ""
//            }
        }

    }

}
