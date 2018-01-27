//
//  TakerTableViewCell.swift
//  Benefactor
//
//  Created by Ahmed Shawky on 7/22/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit

class TakerTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
