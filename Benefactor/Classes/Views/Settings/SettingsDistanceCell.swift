//
//  SettingsDistanceCell.swift
//  Benefactor
//
//  Created by Ahmed Shawky on 8/26/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit

class SettingsDistanceCell: UITableViewCell {
    @IBOutlet weak var slider: UISlider!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.slider.value = Float(DistanceHandler.sharedManager.distance)
        
        // Initialization code
    }

    @IBAction func changeValue() {
        let value = Int(self.slider.value)
        if value != DistanceHandler.sharedManager.distance
        {
           DistanceHandler.sharedManager.distance = value
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
