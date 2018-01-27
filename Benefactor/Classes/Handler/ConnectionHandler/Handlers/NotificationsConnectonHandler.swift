//
//  NotificationsConnectonHandler.swift
//  Benefactor
//
//  Created by MacBook Pro on 5/11/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit
import SwiftyJSON

class NotificationsConnectonHandler: ConnectionHandler {
    //MARK:var
    var totalPages:Int = 0
    var currentPage:Int = 1
    var arrayOfData:[DTONotification]?
    var hasMoreData:Bool = false
    //MARK:Methods
    func retrieveNotifications(completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    {
        let urlString = endPoint_notifications()
        let postData = ["pageNumber":currentPage]
        Connection.performPostWithToken(urlString: urlString,postData: postData, success: { (result) in
            if result["data"].exists()
            {
                self.handleSuccessResponse(result: result, completion: completion)
            }else
            {
                failed(MESSAGE_SERVER_DOWN,nil)
            }
        }) { (error) in
            failed(error?.localizedDescription,nil)
        }
    }
    private func handleSuccessResponse(result:JSON,completion:@escaping SucessBlock)
    {
        let data = result["data"]
        
        self.totalPages = result["pagesNumber"].intValue
        self.currentPage = result["currentPage"].intValue
        if arrayOfData != nil {
            let arr = DTONotification.collection(data: data)
            arrayOfData?.append(contentsOf: arr)
        }else
        {
            arrayOfData = DTONotification.collection(data: data)
        }
        if totalPages == 0 {
            hasMoreData = false
            completion(true)
        }else
        {
            if self.currentPage < totalPages
            {
                hasMoreData = true
                currentPage = currentPage + 1
            }else
            {
                hasMoreData = false
            }
            completion(true)
        }
    }
    func addDevice()
    {
        guard let refresToken = UserDefaults.standard.value(forKey: "deviceToken") as? String else {
            return
        }
        let urlString = endPoint_addDevice()
        let postData = ["fcmToken" : refresToken,"platform":"ios","imei":UIDevice.current.identifierForVendor!.uuidString]
        //
        Connection.performPostWithToken(urlString: urlString, postData: postData , success:
            { (result) in

        }) { (error) in

        }
    }
    func deleteDevice()
    {

        let urlString = endPoint_deleteDevice()
        let postData = ["imei":UIDevice.current.identifierForVendor!.uuidString]

        //
        Connection.performPostWithToken(urlString: urlString, postData: postData, success:
            { (result) in

        }) { (error) in

        }
    }
    class func getUnreadCount()
    {
        let urlString = ConnectionHandler().endPoint_unreadNotifications()
        let postData = [String:String]()

        Connection.performPostWithToken(urlString: urlString, postData: postData, success:
            { (result) in
            if result["data"].exists()
            {
                UIApplication.shared.applicationIconBadgeNumber = result["data"]["unreadCount"].intValue
                NotificationCenter.default.post(name: Notification.Name(rawValue: NOTIFICATION_COUNT_CHANGE), object: nil)
            }
        }) { (error) in
        }
    }

}
