//
//  OtherUserConnectionHandler.swift
//  Benefactor
//
//  Created by MacBook Pro on 3/3/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit
import SwiftyJSON

class OtherUserConnectionHandler: ConnectionHandler {
    //
    func followUser(userID:Int,completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    {
        self.followUser(userID: userID, isFollow: 1, completion: completion, failed: failed)
        
    }
    func unfollowUser(userID:Int,completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    {
        self.followUser(userID: userID, isFollow: 0, completion: completion, failed: failed)
//        let urlString = endPoint_unfollow(userID)
//        //
//        Connection.performDelete(urlString: urlString, success: { (result) in
//            self.handleActionResponse(json: result, completion: completion, failed: failed)
//            
//        }) { (error) in
//            failed(error?.localizedDescription,nil)
//        }
    }
    private func followUser(userID:Int,isFollow:Int,completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    {
        let urlString = endPoint_follow()
        let postData = ["userID" : userID,"isFollow":isFollow]
        //
        Connection.performPostWithToken(urlString: urlString, postData: postData, success:
            { (result) in
                self.handleActionResponse(json: result, completion: completion, failed: failed)
        }) { (error) in
            failed(error?.localizedDescription,nil)
        }
        
    }

//    func chechFollow(userID:Int,completion:@escaping SucessBlock,failed: @escaping FailureBlock){
//        let urlString = endPoint_checkFollow(userID)
//        //
//        Connection.performGet(urlString: urlString, success: { (result) in
////            self.handleActionResponse(json: result, completion: completion, failed: failed)
//            print(result)
//            if let flag = result["sucess"].bool , flag == true
//            {
//                completion(result["data"].boolValue)
//            }else
//            {
//                failed(MESSAGE_SERVER_DOWN,nil)
//            }
//        }) { (error) in
//            failed(error?.localizedDescription,nil)
//        }
//
//
//    }
    func reportUser(userID:Int,reason:String,completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    {
        let urlString = endPoint_reportUser()
        let postData = ["userID" : userID,"msg":reason] as [String : Any]
        //
        Connection.performPostWithToken(urlString: urlString, postData: postData, success:
            { (result) in
                self.handleActionResponse(json: result, completion: completion, failed: failed)
        }) { (error) in
            failed(error?.localizedDescription,nil)
        }
        
    }
    func handleActionResponse(json:JSON,completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    {
        if json["error"].exists() {
            
            let errorCode = (json["error"].string)!
            switch errorCode {
//            case "invalid_credentials":
//                failed(MESSAGE_WRONG_USER_DATA,nil)
                
            default:
                if let msg = json["error_description"].string
                {
                    failed(msg,nil)
                }else
                {
                    failed(errorCode,nil)
                }
                
            }
            
        }else if json["success"].exists() {
            if json["success"].intValue == 1
            {
                completion(true)
            }else
            {
                failed(ERROR_IN_API_ACTION,nil)
            }
        }else
        {
            failed(MESSAGE_SERVER_DOWN,nil)
        }
    }

    
//    fileprivate func handleActionResponse(json:JSON,completion:@escaping SucessBlock,failed: @escaping FailureBlock)
//    {
//        if json["sucess"].exists() {
//            if json["sucess"].boolValue == true
//            {
//                completion(true)
//            }else if json["error"]["code"].exists()
//            {
//                let errorCode = (json["error"]["code"].string)!
//                switch errorCode {
//                case "USER_FOLLOW_ALREADY_EXIST","USER_FOLLOW_NOT_EXIST":
//                    completion(true)
//                case "PRODUCT_REPORT_EXIST":
//                    failed(MESSAGE_ITEM_ALREADY_REPORTED,InputType.mail)
//                default:
//                    
//                    if let msg = json["error"]["message"].string {
//                        
//                        failed(msg,nil)
//                        
//                    } else {
//                        
//                        failed(errorCode,nil)
//                    }
//                }
//            }else
//            {
//                failed(MESSAGE_SERVER_DOWN,nil)
//            }
//        }else
//        {
//            failed(MESSAGE_SERVER_DOWN,nil)
//        }
//    }

}
