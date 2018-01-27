//
//  SideRegulareTableViewCell.swift
//  Benefactor
//
//  Created by MacBook Pro on 1/2/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit

class SideRegulareTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        titleLbl.customizeBoldFont()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
