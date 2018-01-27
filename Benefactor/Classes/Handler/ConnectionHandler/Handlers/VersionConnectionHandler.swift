//
//  VersionConnectionHandler.swift
//  Benefactor
//
//  Created by Ahmed Shawky on 8/30/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit
import SwiftyJSON

class VersionConnectionHandler: ConnectionHandler {
    class func checkUpdate(completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    {
        let urlString = ConnectionHandler().endPoint_checkVersion()
        let postData = ["osName" : "ios"] as [String : Any]
        //
        Connection.performPost(urlString: urlString, extraHeaders: nil, postData: postData, success:
            { (result) in
                print(result)
                if result["sucess"].bool == true {
                    var dic = [String:Any]()
                    dic["force"] = result["data"]["isForceUpdate"].boolValue
                    dic["version"] = result["data"]["releaseNumber"].intValue
                    completion(dic)
                }else
                {
                    failed(MESSAGE_SERVER_DOWN,nil)
                }
                
        }) { (error) in
            failed(error?.localizedDescription,nil)
        }
        
    }

}
