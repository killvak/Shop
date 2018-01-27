//
//  DTONotification.swift
//  Benefactor
//
//  Created by MacBook Pro on 5/11/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit
import SwiftyJSON
enum NotificationType
{
    case request
    case response
    case chat
    case none
}
class DTONotification: NSObject {
    //MARK: - Var
    var notification_id: Int!
    var notification_type: NotificationType = .none
    var notification_text: String!
    var notification_dateString: String!
    var notification_isRead: Bool!
    var notification_UserName: String!
    var notification_UserImage: String?
    var notification_sender:DTOUser?
    var notification_product:DTOProduct?
    //MARK: - Parse
    init(_ json:JSON)
    {
        super.init()
        notification_id = json["id"].intValue
        notification_text = json["body"].stringValue
        notification_isRead = false//json["read"].boolValue
        notification_UserImage = json["senderUser"]["profilePicURL"].string
        if let first = json["senderUser"]["firstName"].string,let last = json["senderUser"]["lastName"].string
        {
            notification_UserName = first + " " + last

        }else
        {
            notification_UserName = json["senderUser"]["username"].stringValue

        }
        //
        let interval = json["datePosted"].floatValue
        let date = Date(timeIntervalSince1970: TimeInterval(interval))
        convertDateToString(date)
        //
        guard let typeString = json["type"].int else {
            return
        }
        if typeString == 1 {
            notification_sender = DTOUser(otherProfile:json["senderUser"])
            notification_product = DTOProduct(json["product"])
            self.notification_type = .request
        }else if typeString == 2
        {
            notification_sender = DTOUser(otherProfile:json["senderUser"])
            notification_product = DTOProduct(json["product"])
            self.notification_type = .response
        }
    }
    class func collection(data:JSON) -> [DTONotification]
    {
        let contents = data
        let arr = (contents.array)!
       
        var result = [DTONotification]()
        for dic in arr
        {
            result.append(DTONotification(dic))
        }
        return result
    }

    //MARK: - Helpers
    fileprivate func convertDateToString(_ date:Date)
    {
        let dateformat = DateFormatter()
        dateformat.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        dateformat.dateStyle = .long
        dateformat.timeStyle = .short
        notification_dateString =  dateformat.string(from: date)
    }

}
