//
//  ChatConnectionHandler.swift
//  Benefactor
//
//  Created by Ahmed Shawky on 7/18/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit
import SwiftyJSON

class ChatConnectionHandler: ConnectionHandler {
    var totalPages:Int = 0
    var currentPage:Int = 1
    var arrayOfData:[DTOMessage]?
    var hasMoreData:Bool = false

    func getChatUsers(completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    {
        let urlString = endPoint_chatUsers()
        Connection.performGetWithToken(urlString: urlString, success: { (result) in
            if result["data"].exists() == true {
                var allUsersDic = [Int:DTOUser]()
                let arr = result["data"].arrayValue
                for item in arr
                {
                    let user1 = DTOUser(otherProfile:item)
                    allUsersDic[user1.user_id] = user1
//                    let user = DTOUser(otherProfile:item["reciever"])
//                    allUsersDic[user.user_id] = user
                }
//                allUsersDic.removeValue(forKey: (DTOUser.currentUser()?.user_id)!)
                let allUsersArr = Array(allUsersDic.values)
                completion(allUsersArr)
            }else
            {
                failed(MESSAGE_SERVER_DOWN,nil)
            }
        }) { (error) in
            failed(error?.localizedDescription,nil)
        }

    }
    func getChatHistory(userID:Int,completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    {
        let urlString = endPoint_getChat()
        let postData = ["userID":userID,"pageNumber":currentPage]
        Connection.performPostWithToken(urlString: urlString,postData: postData, success: { (result) in
            if result["data"].exists(){
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
        let receivedArr = data.arrayValue
        if arrayOfData != nil {
            var arr = [DTOMessage]()
            for inner in receivedArr
            {
                arr.append(DTOMessage(inner))
            }
            
            arrayOfData?.append(contentsOf: arr)
        }else
        {
            var arr = [DTOMessage]()
            for inner in receivedArr
            {
                arr.append(DTOMessage(inner))
            }
            arrayOfData = arr
        }
        if self.totalPages == 0 {
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
    func sendMessage(userID:Int,message:String,completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    {
        let urlString = endPoint_sendMessage()
        let postData = ["userID" : userID,
                        "message" : message] as [String : Any]
        //
        Connection.performPostWithToken(urlString: urlString, postData: postData, success:
            { (result) in
                if result["success"].intValue == 1
                {
                    self.arrayOfData?.insert(DTOMessage(sendMessage: message), at: 0)
                    completion(nil)
                }else
                {
                    failed(MESSAGE_SERVER_DOWN,nil)
                }

        }) { (error) in
            failed(error?.localizedDescription,nil)
        }

    }
    func deleteChat(userID:Int,completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    {
        let urlString = endPoint_deleteChat()
        let postData = ["userID":userID]
        Connection.performPostWithToken(urlString: urlString,postData: postData, success: { (result) in
            if result["success"].intValue == 1
            {
                completion(nil)
            }else
            {
                failed(MESSAGE_SERVER_DOWN,nil)
            }
        }) { (error) in
            failed(error?.localizedDescription,nil)
        }
        
    }

}
