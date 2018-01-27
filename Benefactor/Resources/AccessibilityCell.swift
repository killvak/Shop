//
//  AccessibilityCell.swift
//  Benefactor
//
//  Created by admin on 1/27/18.
//  Copyright © 2018 Old Warriors. All rights reserved.
//

import UIKit

class AccessibilityCell: UITableViewCell,CMSwitchViewDelegate {
    
    @IBOutlet weak var receiveOffer: CMSwitchView!
    @IBOutlet weak var chatSwitch: CMSwitchView!
    @IBOutlet weak var follow1Switch: CMSwitchView!
    @IBOutlet weak var follow2Switch: CMSwitchView!
    
    var enableReceiveOffer = false
    var enableChat = false
    var enableFollow1 = true
    var enableFollow2 = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let ara : [(Bool,CMSwitchView)] = [(enableReceiveOffer,receiveOffer),(enableChat,chatSwitch),(enableFollow1,follow1Switch),(enableFollow2,follow2Switch)]
        // Initialization code
        for (value, swi) in ara {
            swi.dotColor = value ?  .orange :  UIColor.lightGray
            swi.setSelected(value, animated: false)
            swi.color = UIColor.white
            swi.tintColor = UIColor.white
            swi.delegate = self
        }
    }
    func switchValueChanged(_ sender: Any!, andNewValue value: Bool) {
        guard let sender = sender as? CMSwitchView else {
            return
        }
        switch sender  {
        case receiveOffer :
            enableReceiveOffer = value
        case chatSwitch :
            enableChat = value
        case follow1Switch :
            enableFollow1 = value
        case follow2Switch :
            enableFollow2 = value
        default : print("Error in switch in AccessibilityCell ")
        }
        sender.dotColor = value ?  .orange :  UIColor.lightGray
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
