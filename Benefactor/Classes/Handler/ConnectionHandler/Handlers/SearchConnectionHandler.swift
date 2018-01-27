//
//  SearchConnectionHandler.swift
//  Benefactor
//
//  Created by MacBook Pro on 2/14/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class SearchConnectionHandler: ConnectionHandler {
    //
    var totalPages:Int = 0
    var currentPage:Int = 1
    var arrayOfProducts:[DTOProduct]?
    var hasMoreData:Bool = false
    // MARK: - all products
    func searchProducts(text:String,distance:Int,lat:Double,lng:Double,completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    {
        var finalDistance:Int
        if DistanceHandler.sharedManager.isMile()
        {
            let meters = Float(distance) / (0.000621371192)
            finalDistance =  Int(meters/1000)
        }else
        {
            finalDistance = distance
        }
        let urlString = endPoint_searchProducts()
        let postData = ["pageNumber":currentPage,"kmDistance":finalDistance,"latitude":lat,"longitude":lng,"searchText":text] as [String : Any]
        Connection.performPostWithToken(urlString: urlString,postData: postData, success: { (result) in
            if result["data"].exists()
            {
                self.handleProductsSuccessResponse(result: result,lat:lat,lng:lng, completion: completion)
            }else
            {
                failed(MESSAGE_SERVER_DOWN,nil)
            }
        }) { (error) in
            failed(error?.localizedDescription,nil)
        }
    }
    private func handleProductsSuccessResponse(result:JSON,lat:Double,lng:Double,completion:@escaping SucessBlock)
    {
        let data = result["data"]
        
        self.totalPages = result["pagesNumber"].intValue
        self.currentPage = result["currentPage"].intValue

        if arrayOfProducts != nil {
            let arr = DTOProduct.collection(data: data,lat: lat,lng: lng)
            arrayOfProducts?.append(contentsOf: arr)
        }else
        {
            arrayOfProducts = DTOProduct.collection(data: data,lat: lat,lng: lng)
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
    
}
