//
//  ChatTableViewCell.swift
//  Benefactor
//
//  Created by Ahmed Shawky on 8/11/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.circleView(width: 50)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func loadItem(message:DTOMessage,user:DTOUser)
    {
        if let image = user.user_image
        {
            userImageView.imageProfile(fromString: image)
        }else
        {
            userImageView.image = UIImage(named:"defaultImage")
        }
        if message.messageType == .receive
        {
            userNameLabel.text = user.displayName

        }
        //
        messageLabel.text = message.messageText
        //
        timeLabel.text = message.messageDateString
        
    }
    
}
