//
//  CategoryConnectionHandler.swift
//  Benefactor
//
//  Created by MacBook Pro on 1/4/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit
import SwiftyJSON

class CategoryConnectionHandler: ConnectionHandler {
    //singleton
    class var sharedInstance: CategoryConnectionHandler {
        struct Static {
            static let instance = CategoryConnectionHandler()
        }
        return Static.instance
    }
    //singleton
    var arrayOfCategory:[DTOCategory]?
    func requestCategories(completion:@escaping SucessBlock,failure failed: @escaping FailureBlock)
    {
        if let arr = arrayOfCategory
        {
            completion(arr)
            return
        }
        let urlString = endPoint_category()
        Connection.performGet(urlString: urlString, success: { (result) in
            self.handleCategoryResult(result: result,completion: completion, failed: failed)
        }) { (error) in
            failed(error?.localizedDescription,nil)
        }
    }
    func handleCategoryResult(result:JSON,completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    {
        if result["success"].intValue == 1
        {
            let data = result["data"]
            let arr = DTOCategory.collection(data: data)
            arrayOfCategory = arr
            completion(arr)
        }else
        {
            failed(MESSAGE_SERVER_DOWN,nil)
        }
    }
}
