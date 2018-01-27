//
//  UserTableViewCell.swift
//  Benefactor
//
//  Created by Ahmed Shawky on 7/22/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLabel.customizeFont()
        imgView.circleView(width: 44)
    }
    func loadItem(_ user:DTOUser)
    {
        if let image = user.user_image
        {
            imgView.imageProfile(fromString: image)
        }else
        {
            imgView.image = UIImage(named:"defaultImage")
        }
        nameLabel.text = user.displayName
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
