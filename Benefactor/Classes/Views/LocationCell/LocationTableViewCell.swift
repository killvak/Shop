//
//  LocationTableViewCell.swift
//  Benefactor
//
//  Created by MacBook Pro on 3/8/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.accessoryType = .checkmark
        }else
        {
            self.accessoryType = .none
        }
        // Configure the view for the selected state
    }

}
