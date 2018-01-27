//
//  HistoryConnectionHandler.swift
//  Benefactor
//
//  Created by MacBook Pro on 4/29/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HistoryConnectionHandler: ConnectionHandler {
    //
    var totalPages:Int = 0
    var currentPage:Int = 1
    var arrayOfProducts:[DTOProduct]?
    var hasMoreData:Bool = false
    //MARK:- Taken
    func getTakenProducts(completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    {
        let urlString = endPoint_takenProducts()
        historyRequest(urlString: urlString, completion: completion, failed: failed)

    }
    //MARK:- Given
    func getGivenProducts(completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    {
        let urlString = endPoint_givenProducts()
        historyRequest(urlString: urlString, completion: completion, failed: failed)
    }
    //
    private func historyRequest(urlString:String,completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    {
        let postData = ["pageNumber":currentPage]
        Connection.performPostWithToken(urlString: urlString, postData: postData, success: { (result) in
            if result["data"].exists()
            {
                self.handleProductsSuccessResponse(result: result, completion: completion,failed: failed)
            }else
            {
                failed(MESSAGE_SERVER_DOWN,nil)
            }

        }) { (error) in
            failed(error?.localizedDescription,nil)

        }
    }
    //MARK:- Parse
    private func handleProductsSuccessResponse(result:JSON,completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    {
        let data = result["data"]
        
        self.totalPages = result["pagesNumber"].intValue
        self.currentPage = result["currentPage"].intValue
        let arr = DTOProduct.collection(data: data,lat: nil,lng: nil)
        detectCategory(arr:arr,completion:completion,failed:failed)
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
    private func detectCategory(arr:[DTOProduct],completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    {
        CategoryConnectionHandler.sharedInstance.requestCategories(completion: { (result) in
            let categories = result as! [DTOCategory]
            var newArr = [DTOProduct]()
            for item in arr {
                let category = categories.filter{ $0.category_ID?.intValue == item.product_categoryID }.first
                item.product_categoryName = category?.category_name ?? ""
                newArr.append(item)
            }
            if self.arrayOfProducts != nil {
                self.arrayOfProducts?.append(contentsOf: newArr)
            }else
            {
                self.arrayOfProducts = newArr
            }
            completion(true)
            }, failure: { (msg3, _) in
                failed(msg3,nil)
        })
    }
}
