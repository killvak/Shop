//
//  NotificationTableViewCell.swift
//  Benefactor
//
//  Created by MacBook Pro on 6/4/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        imgView.circleView(width:47)
        userNameLabel.customizeFont()
        dateLabel.customizeFont()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func loadItem(item:DTONotification)
    {
        if item.notification_isRead == true {
            bodyLabel.customizeFont()
            bodyLabel.textColor = UIColor(rgba:"#888888")
        }else
        {
            bodyLabel.customizeBoldFont()
            bodyLabel.textColor = UIColor(rgba:"#595959")
        }
        if let source = item.notification_UserImage
        {
            imgView.imageRegular(fromString: source)
        }else
        {
            imgView.image = UIImage(named: "defaultImage")
        }
        userNameLabel.text = item.notification_UserName
        dateLabel.text = item.notification_dateString
        bodyLabel.text = item.notification_text
        
    }

}
