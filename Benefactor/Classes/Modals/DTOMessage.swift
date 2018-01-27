//
//  DTOMessage.swift
//  Benefactor
//
//  Created by Ahmed Shawky on 8/10/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit
import SwiftyJSON

enum MessageType
{
    case receive
    case send
}
class DTOMessage: NSObject {
    var messageText:String!
    var messageType = MessageType.receive
    var messageDateString:String!
    init(_ json:JSON) {
        super.init()
        messageText = json["message"].stringValue
        let currentID = DTOUser.currentUser()!.user_id
        if json["senderUserID"].intValue == currentID  {
            messageType = .send
        }else
        {
            messageType = .receive
        }
        //
        let interval = json["datePosted"].floatValue
        let date = Date(timeIntervalSince1970: TimeInterval(interval))
        convertDateToString(date)

    }
    init(sendMessage:String) {
        super.init()
        messageText = sendMessage
        messageType = .send
        convertDateToString(Date())
    }
    init(notificationMessage:String) {
        super.init()
        messageText = notificationMessage
        messageType = .receive
        convertDateToString(Date())
    }
    
    fileprivate func convertDateToString(_ date:Date)
    {
        let dateformat = DateFormatter()
        dateformat.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        dateformat.dateStyle = .long
        dateformat.timeStyle = .short
        messageDateString =  dateformat.string(from: date)
    }

    
    

}
