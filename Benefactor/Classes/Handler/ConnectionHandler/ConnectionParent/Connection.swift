//
//  Connection.swift
//  Pizza
//
//  Created by MacBook Pro on 1/3/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

// on success request
public typealias ConnectionSuccess = (_ object:JSON) -> Void
// on failed request
public typealias ConnectionFailed = (_ error:Error?) -> Void
//
class Connection: NSObject {
    //get
    class public func performGet(urlString:String,success:@escaping ConnectionSuccess,failure:@escaping ConnectionFailed)
    {
        let headers:[String:String] = ["Content-Type":"application/x-www-form-urlencoded"]
        let escapedString = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        Alamofire.request(escapedString, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).validate(statusCode: 200 ..< 501).responseJSON { (response) in
            handleResponse(response: response, success: success, failure: failure)
            }.responseString{ (response) in
                print(response)
        }
    }
    class public func performGetWithToken(urlString:String,success:@escaping ConnectionSuccess,failure:@escaping ConnectionFailed)
    {
        let headers:[String:String] = ["Content-Type":"application/x-www-form-urlencoded","Access-Token":DTOUser.access_token()]
        let escapedString = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        Alamofire.request(escapedString, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers).validate(statusCode: 200 ..< 501).responseJSON { (response) in
            handleResponse(response: response, success: success, failure: failure)
            }.responseString{ (response) in
                print(response)
        }
    }

    //post
    class public func performPost(urlString:String,extraHeaders:[String:String]?,postData:[String:Any],success:@escaping ConnectionSuccess,failure:@escaping ConnectionFailed)
    {
        var headers:[String:String] = ["Content-Type":"application/x-www-form-urlencoded"]
        
        if let dic = extraHeaders {
            for item in dic{
                headers[item.key] = item.value
            }
        }
        
        Alamofire.request(urlString, method: .post, parameters: postData, encoding: URLEncoding.default, headers: headers).validate(statusCode: 200 ..< 501)
            .responseJSON { response in
                handleResponse(response: response, success: success, failure: failure)
            }
            .responseString { (response) in
                print(response)
        }
        
    }
    class public func performPostWithToken(urlString:String,postData:[String:Any],success:@escaping ConnectionSuccess,failure:@escaping ConnectionFailed)
    {
        let headers = ["Access-Token":DTOUser.access_token()]
        self.performPost(urlString: urlString, extraHeaders: headers, postData: postData, success: success, failure: failure)
        
    }

    class public func performPut(urlString:String,success:@escaping ConnectionSuccess,failure:@escaping ConnectionFailed)
    {
        let headers = ["Content-Type":"application/x-www-form-urlencoded"]
        Alamofire.request(urlString, method: .put, parameters: nil, encoding: URLEncoding.default, headers: headers).validate(statusCode: 200 ..< 501)
            .responseJSON { response in
                handleResponse(response: response, success: success, failure: failure)
            }.responseString{ (response) in
                print(response)
        }
        
    }
    //delete
    class public func performDelete(urlString:String,success:@escaping ConnectionSuccess,failure:@escaping ConnectionFailed)
    {
//        let url = Foundation.URL(string:urlString)!
        let headers:[String:String] = ["Content-Type":"application/x-www-form-urlencoded"]

        Alamofire.request(urlString, method: .delete, parameters: nil, encoding: URLEncoding.default, headers: headers).validate(statusCode: 200 ..< 501)
            .responseJSON { response in
            handleResponse(response: response, success: success, failure: failure)
        }
    }

    //handling
    class private func handleResponse(response:DataResponse<Any>,success:@escaping ConnectionSuccess,failure:@escaping ConnectionFailed)
    {
        switch response.result {
        case .success(let value):
            let ss = value as! [String:Any]
            print(ss["error"])
            let json = JSON(value)
            if let error = json["error"].string , error == "invalid_token" , DTOUser.currentUser() != nil
            {
                DTOUser.currentUser()?.logOut()
                NotificationCenter.default.post(name: Notification.Name(rawValue: NOTIFICATION_USER_EXPIRED), object: nil)
                NotificationsConnectonHandler().deleteDevice()
                let userInfo: [AnyHashable : Any] =
                    [
                        NSLocalizedDescriptionKey :  NSLocalizedString("Unauthorized", value: "invalid_token", comment: "") ,
                        NSLocalizedFailureReasonErrorKey : NSLocalizedString("Unauthorized", value: "invalid_token", comment: "")
                ]
                let errorTemp = NSError(domain:"", code:401, userInfo:userInfo)
                failure(errorTemp)
            }else
            {
                success(json)
            }
        case .failure(let error):
            failure(error)
        }
    }
    
}
