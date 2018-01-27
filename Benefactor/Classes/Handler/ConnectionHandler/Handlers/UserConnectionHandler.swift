//
//  UserConnectionHandler.swift
//  Benefactor
//
//  Created by MacBook Pro on 1/4/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class UserConnectionHandler: ConnectionHandler {
    var errorStep:InputType = .mail
    var totalPages:Int = 0
    var currentPage:Int = 1
    var arrayOfUsers:[DTOUser]?
    var hasMoreData:Bool = false
    
    //MARK: - Login
    func logIn(name:String,password:String,completion:@escaping SucessBlock,failed: @escaping FailureBlock) {
        
        // headers
        let headers = ["Authentication":"Basic c3RvcmVjbGllbnQ6c3RvcmVjbGllbnRwYXNzd29yZA=="]
        let urlString = endPoint_login()
        let postData = ["username" : name,"password" : password]
        
        Connection.performPost(urlString: urlString, extraHeaders: headers, postData: postData, success:
            { (result) in
                
                self.handleLoginResult(json: result, completion: completion, failed: failed)
                
        }) { (error) in
            
            failed(error?.localizedDescription,nil)
        }
    }
    
    private func handleLoginResult(json:JSON,completion:@escaping SucessBlock,failed: @escaping FailureBlock) {
        
        if json["error"].exists() {
            
            let errorCode = (json["error"].string)!
            switch errorCode {
            case "invalid_credentials":
                failed(MESSAGE_WRONG_USER_DATA,nil)
                
            default:
                if let msg = json["error_description"].string
                {
                    failed(msg,nil)
                }else
                {
                    failed(errorCode,nil)
                }
                
            }
            
        }else if json["token"].exists()
        {
            completion(DTOUser(json))
        }else
        {
            failed(MESSAGE_SERVER_DOWN,nil)
        }
    }
    
    //MARK: - Register
    func register(user:RegisterUser,completion:@escaping SucessBlock,failed: @escaping FailureBlock) {
        
        let urlString = endPoint_signup()
        var postData = ["username" : user.user_nickName!,
                        "password" : user.user_password!]
        if let name = user.user_firstName
        {
            postData["firstName"] = name
        }
        if let name = user.user_lastName
        {
            postData["lastName"] = name
        }
        if let mail = user.user_mail
        {
            postData["email"] = mail
        }
        if let imgPath = user.user_imagePath
        {
            postData["profilePicURL"] = imgPath
        }
        print(postData)
        //
        Connection.performPost(urlString: urlString, extraHeaders: nil, postData: postData, success:
            { (result) in
                self.handleRegisterResult(json: result, completion: completion, failed: failed)
        }) { (error) in
            failed(error?.localizedDescription,nil)
        }
    }
    
    private func handleRegisterResult(json:JSON,completion:@escaping SucessBlock,failed: @escaping FailureBlock) {
        
        if json["error"].exists() {
            
            let errorCode = (json["error"].string)!
            switch errorCode {
            case "invalid_username":
                failed(json["error_description"].string ?? MESSAGE_USER_NAME_EXISTED,InputType.userName)
            case "invalid_email":
                failed(json["error_description"].string ?? MESSAGE_WRONG_DATA,InputType.mail)
            default:
                
                if let msg = json["error_description"].string {
                    
                    failed(msg,nil)
                    
                } else {
                    
                    failed(errorCode,nil)
                }
            }
        } else if json["success"].intValue == 1 {
            completion(DTOUser(json))
        } else {
            
            failed(MESSAGE_SERVER_DOWN,nil)
        }
    }
    //MARK: - UserInfo
    func getCurrentUser(completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    {
        let urlString = endPoint_currentUserInfo()
        Connection.performGetWithToken(urlString: urlString, success: { (result) in
            if result["success"].intValue == 1 {
                let user = DTOUser(profile: result["data"])
                completion(user)
            }else
            {
                failed(MESSAGE_SERVER_DOWN,nil)
            }
        }) { (error) in
            failed(error?.localizedDescription,nil)
        }
    }

    func getUser(_ userID:Int?,completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    {
        let paramater = userID ?? (DTOUser.currentUser()!.user_id)!
        let urlString = endPoint_userInfo()
        let postData = ["id":paramater]
        Connection.performPostWithToken(urlString: urlString,postData:postData, success: { (result) in
            if result["success"].intValue == 1 {
                let user = DTOUser(profile: result["data"])
                completion(user)
            }else
            {
                failed(MESSAGE_SERVER_DOWN,nil)
            }
        }) { (error) in
            failed(error?.localizedDescription,nil)
        }
    }
    //MARK: - Follow users
    func getFollowings(completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    {
        let urlString = endPoint_getFollowings()
        let postData  = ["pageNumber":currentPage]
        Connection.performPostWithToken(urlString: urlString, postData: postData, success: { (result) in
            if result["data"].exists(){
                self.totalPages = result["pagesNumber"].intValue
                self.currentPage = result["currentPage"].intValue

                let arr = result["data"].arrayValue
                var newArr = [DTOUser]()
                for item in arr
                {
                    let user = DTOUser(otherProfile:item)
                    newArr.append(user)
                }
                self.handleUsersArray(newArr)
                completion(nil)
            }else
            {
                failed(MESSAGE_SERVER_DOWN,nil)
            }
        }) { (error) in
            failed(error?.localizedDescription,nil)
        }
    }
    func getFollowers(completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    {
        let urlString = endPoint_getFollowers()
        let postData  = ["pageNumber":currentPage]
        Connection.performPostWithToken(urlString: urlString, postData: postData, success: { (result) in
            if result["data"].exists(){
                self.totalPages = result["pagesNumber"].intValue
                self.currentPage = result["currentPage"].intValue
                
                let arr = result["data"].arrayValue
                var newArr = [DTOUser]()
                for item in arr
                {
                    let user = DTOUser(otherProfile:item)
                    newArr.append(user)
                }
                self.handleUsersArray(newArr)
                completion(nil)
            }else
            {
                failed(MESSAGE_SERVER_DOWN,nil)
            }
        }) { (error) in
            failed(error?.localizedDescription,nil)
        }
    }
    
    func handleUsersArray(_ newArr:[DTOUser])
    {
        if self.arrayOfUsers != nil {
            self.arrayOfUsers?.append(contentsOf: newArr)
        }else
        {
            self.arrayOfUsers = newArr
        }
        if self.totalPages == 0 {
            self.hasMoreData = false
            
        }else
        {
            if self.currentPage < totalPages
            {
                self.hasMoreData = true
                currentPage = currentPage + 1
            }else
            {
                self.hasMoreData = false
            }
        }
    }
    //MARK: - Edit
    func changePassword(old:String,new:String,completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    {
        let urlString = endPoint_changePassword()
        //
        let postData = ["oldPassword":old,"newPassword":new]
        //
        Connection.performPostWithToken(urlString: urlString,postData: postData, success: { (result) in
            let json = result
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
            
           
            
        }) { (error) in
            failed(error?.localizedDescription,nil)
        }
        
    }
    func editProfilePic(_ image:UIImage,completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    {
        let headers = ["Access-Token":DTOUser.access_token(),"Content-Type":"application/x-www-form-urlencoded"]

        let data = UIImageJPEGRepresentation(image, 0.2)!
        let urlString = endPoint_editUserImage()
        Alamofire.upload(multipartFormData:{ multipartFormData in
            multipartFormData.append(data, withName: "profilePic", fileName: "image1.jpeg", mimeType: "image/jpeg")
        },
                         usingThreshold:UInt64.init(),
                         to:urlString,
                         method:.post,
                         headers:headers,
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.responseJSON { response in
                                    //                        debugPrint(response)
                                    switch response.result {
                                    case .success(let value):
                                        let ss = value as! [String:Any]
                                        self.handleProfilePic(json: JSON(ss), completion: completion, failed: failed)
                                    case .failure(let error):
                                        failed(error.localizedDescription,nil)
                                    }
                                }
                            case .failure(let encodingError):
                                failed(encodingError.localizedDescription,nil)
                            }
        })
        
//        Alamofire.upload(
//            multipartFormData: { multipartFormData in
//                multipartFormData.append(data, withName: "profilePic", fileName: "image1.jpeg", mimeType: "image/jpeg")
//            },
//            to: urlString,
//            encodingCompletion: { encodingResult in
//                switch encodingResult {
//                case .success(let upload, _, _):
//                    upload.responseJSON { response in
//                        //                        debugPrint(response)
//                        switch response.result {
//                        case .success(let value):
//                            let ss = value as! [String:Any]
//                            print(ss["error"])
//                            self.handleProfilePic(json: JSON(ss), completion: completion, failed: failed)
//                        case .failure(let error):
//                            failed(error.localizedDescription,nil)
//                        }
//                    }
//                case .failure(let encodingError):
//                    failed(encodingError.localizedDescription,nil)
//                }
//            }
//        )
    }
    
    fileprivate func handleProfilePic(json:JSON,completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    {
        if json["success"].exists() {
            if json["success"].intValue == 1
            {
                    let user = DTOUser.currentUser()!
                    user.user_image = json["profilePicURL"].string
                    user.saveUser()
                    completion(true)
                    
            }else if json["error_description"].exists()
            {
                let errorCode = (json["error_description"].string)!
                switch errorCode {
                    //                case "PRODUCT_REPORT_EXIST":
                //                    failed(MESSAGE_ITEM_ALREADY_REPORTED,InputType.mail)
                default:
                    
                    if let msg = json["error_description"].string {
                        
                        failed(msg,nil)
                        
                    } else {
                        
                        failed(errorCode,nil)
                    }
                }
            }else
            {
                failed(MESSAGE_SERVER_DOWN,nil)
            }
        }else
        {
            failed(MESSAGE_SERVER_DOWN,nil)
        }
        
    }
    
    func editUser(first:String,last:String,mail:String,completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    {
        let urlString = endPoint_editUser()
        let postData = ["firstName":first,"lastName":last,"email":mail]
        //
        Connection.performPostWithToken(urlString: urlString,postData: postData, success: { (result) in
            let json = result
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
                    let user = DTOUser.currentUser()!
                    user.user_firstName = first
                    user.user_lastName = last
                    user.user_email = mail
                    user.saveUser()
                    completion(true)
                }else
                {
                    failed(ERROR_IN_API_ACTION,nil)
                }
            }else
            {
                failed(MESSAGE_SERVER_DOWN,nil)
            }

//            if json["sucess"].exists() {
//                if json["sucess"].boolValue == true
//                {
//                    let user = DTOUser.currentUser()!
//                    user.user_firstName = first
//                    user.user_lastName = last
//                    user.user_email = mail
//                    user.saveUser()
//                    completion(true)
//                }else if json["error"]["code"].exists()
//                {
//                    let errorCode = (json["error"]["code"].string)!
//                    switch errorCode {
//                        //                    case "PRODUCT_LIKE_EXIST","PRODUCT_FAVORITE_EXIST":
//                        //                        completion(true)
//                        //                    case "PRODUCT_REPORT_EXIST":
//                    //                        failed(MESSAGE_ITEM_ALREADY_REPORTED,InputType.mail)
//                    default:
//                        
//                        if let msg = json["error"]["message"].string {
//                            
//                            failed(msg,nil)
//                            
//                        } else {
//                            
//                            failed(errorCode,nil)
//                        }
//                    }
//                }else
//                {
//                    failed(MESSAGE_SERVER_DOWN,nil)
//                }
//            }else
//            {
//                failed(MESSAGE_SERVER_DOWN,nil)
//            }
//            
            
        }) { (error) in
            failed(error?.localizedDescription,nil)
        }
    }
}

