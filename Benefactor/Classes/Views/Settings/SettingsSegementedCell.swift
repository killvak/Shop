//
//  SettingsSegementedCell.swift
//  Benefactor
//
//  Created by Ahmed Shawky on 8/26/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit

class SettingsSegementedCell: UITableViewCell {

    @IBOutlet weak var milesBtn: UIButton!
    @IBOutlet weak var kmBtn: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setDistanceUnit()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setDistanceUnit() {
        
        if (DistanceHandler.sharedManager.isMile()) {
            milesBtn.setImage(#imageLiteral(resourceName: "radio_on"), for: .normal)
        }else {
            kmBtn.setImage(#imageLiteral(resourceName: "radio_on"), for: .normal)
            
        }
    }
    @IBAction func changeEvent(_ sender : UIButton) {
        if sender.tag == 0
        {
            DistanceHandler.sharedManager.unit =  DistanceHandler.sharedManager.firstUnit()
            milesBtn.setImage(#imageLiteral(resourceName: "radio_on"), for: .normal)
             kmBtn.setImage(#imageLiteral(resourceName: "radio_off"), for: .normal)
        }else
        {
            DistanceHandler.sharedManager.unit =  DistanceHandler.sharedManager.secondUnit()
            milesBtn.setImage(#imageLiteral(resourceName: "radio_off"), for: .normal)
            kmBtn.setImage(#imageLiteral(resourceName: "radio_on"), for: .normal)
        }
    }

}
