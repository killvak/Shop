//
//  ProductConnectionHandler.swift
//  Benefactor
//
//  Created by MacBook Pro on 2/14/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ProductConnectionHandler: ConnectionHandler {
    //
    var totalPages:Int = 0
    var currentPage:Int = 1
    var arrayOfProducts:[DTOProduct]?
    var hasMoreData:Bool = false
    // MARK: - all products
    func requestProducts(categoryID:NSNumber,lat:Double,lng:Double,completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    {
        let urlString = endPoint_categoryProducts()
        //        let urlString = endPoint_categoryProducts(categoryID: categoryID, lat: lat, lng: lng,page:currentPage)
        let postData:[String:Any] = ["pageNumber":currentPage,"categoryID":categoryID,"latitude":lat,"longitude":lng,"kmDistance":DistanceHandler.sharedManager.distanceForServices()]
        
        Connection.performPostWithToken(urlString: urlString,postData:postData, success: { (result) in
            if result["data"].exists()
            {
                print(result)
                self.handleProductsSuccessResponse(result: result,lat:lat,lng:lng, completion: completion)
            }else
            {
                failed(MESSAGE_SERVER_DOWN,nil)
            }
        }) { (error) in
            failed(error?.localizedDescription,nil)
        }
    }
    private func handleProductsSuccessResponse(result:JSON,lat:Double?,lng:Double?,completion:@escaping SucessBlock)
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
    // MARK: - detailed product
    //    func requestdetails(_ product:DTOProduct,completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    //    {
    //        let urlString = endPoint_detailedProduct(product.product_id)
    //        Connection.performGet(urlString: urlString, success: { (result) in
    //            self.handleDetailedSuccess(product: product, result: result, completion: completion, failed: failed)
    //        }) { (error) in
    //            failed(error?.localizedDescription,nil)
    //        }
    //    }
    //    private func handleDetailedSuccess(product:DTOProduct, result:JSON,completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    //    {
    //        if result["sucess"].bool == true
    //        {
    //            product.refreshDetailedProperties(result["data"])
    //            completion(true)
    //        }else
    //        {
    //            failed(MESSAGE_SERVER_DOWN,nil)
    //        }
    //    }
    //MARK: - products
    func requestFavoriteProducts(ownerID:Int,lat:Double?,lng:Double?,completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    {
        let urlString = endPoint_favoritedProducts()
        Connection.performGetWithToken(urlString: urlString, success: { (result) in
            if result["data"].exists()
            {
                let data = result["data"]
                self.arrayOfProducts = DTOProduct.collection(data: data,lat: lat,lng: lng)
                self.hasMoreData = false
                completion(true)
                
            }else
            {
                failed(MESSAGE_SERVER_DOWN,nil)
            }
        }) { (error) in
            failed(error?.localizedDescription,nil)
        }
        
    }
    func requestProducts(ownerID:Int,lat:Double?,lng:Double?,completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    {
        let urlString = endPoint_ownerProducts()
        let postData = ["ownerID":ownerID,"pageNumber":currentPage]
        Connection.performPostWithToken(urlString: urlString, postData: postData, success: { (result) in
            if result["data"].exists()
            {
                self.handleProductsSuccessResponse(result: result, lat: lat, lng: lng, completion: completion)
            }else
            {
                failed(MESSAGE_SERVER_DOWN,nil)
            }
        }) { (error) in
            failed(error?.localizedDescription,nil)
        }
        
    }
    //    private func handleOwnerProductsSuccess(result:JSON,lat:Double?,lng:Double?,completion:@escaping SucessBlock)
    //    {
    //        let data = result["data"]
    //
    //        self.totalPages = result["pagesNumber"].intValue
    //        self.currentPage = result["currentPage"].intValue
    //        if arrayOfProducts != nil {
    //            let arr = DTOProduct.collection(data: data,lat: lat,lng: lng)
    //            arrayOfProducts?.append(contentsOf: arr)
    //        }else
    //        {
    //            arrayOfProducts = DTOProduct.collection(data: data,lat: lat,lng: lng)
    //        }
    //        if totalPages == 0 {
    //            hasMoreData = false
    //            completion(true)
    //
    //        }else
    //        {
    //            if self.currentPage < totalPages
    //            {
    //                hasMoreData = true
    //            }else
    //            {
    //                hasMoreData = false
    //            }
    //
    //            completion(true)
    //        }
    //    }
    //MARK: - Adding & Editing
    func addProductImage(productID:Int,image:UIImage,completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    {
        let headers = ["Access-Token":DTOUser.access_token(),"Content-Type":"application/x-www-form-urlencoded"]
        
        let data = UIImageJPEGRepresentation(image, 0.2)!
        let urlString = endPoint_addProductImage()
        Alamofire.upload(multipartFormData:{ multipartFormData in
            multipartFormData.append(data, withName: "image", fileName: "image1.jpeg", mimeType: "image/jpeg")
            multipartFormData.append("\(productID)".data(using: .utf8, allowLossyConversion: false)!, withName: "productID")
        },
                         usingThreshold:UInt64.init(),
                         to:urlString,
                         method:.post,
                         headers:headers,
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.responseString(completionHandler: { (res) in
                                    print(res)
                                })
                                upload.responseJSON { response in
                                    //                        debugPrint(response)
                                    switch response.result {
                                    case .success(let value):
                                        let ss = value as! [String:Any]
                                        let result = JSON(ss)
                                        if result["success"].exists() {
                                            if result["success"].intValue == 1
                                            {
                                                completion(result["data"]["id"].intValue)
                                            }else
                                            {
                                                failed(ERROR_IN_API_ACTION,nil)
                                            }
                                        }else
                                        {
                                            failed(MESSAGE_SERVER_DOWN,nil)
                                        }
                                        
                                    case .failure(let error):
                                        failed(error.localizedDescription,nil)
                                    }
                                }
                            case .failure(let encodingError):
                                failed(encodingError.localizedDescription,nil)
                            }
        })
        
        //        print("productId \(productID)")
        //        let data = UIImageJPEGRepresentation(image, 0.2)!
        //        let urlString = endPoint_addProductImage()
        //        Alamofire.upload(
        //            multipartFormData: { multipartFormData in
        //                multipartFormData.append(data, withName: "image", fileName: "image1.jpeg", mimeType: "image/jpeg")
        //                multipartFormData.append("\(productID)".data(using: .utf8, allowLossyConversion: false)!, withName: "productID")
        //            },
        //            to: urlString,
        //            encodingCompletion: { encodingResult in
        //                switch encodingResult {
        //                case .success(let upload, _, _):
        //                    upload.responseString(completionHandler: { (res) in
        //                        print(res)
        //                    })
        //                    upload.responseJSON { response in
        //                        //                        debugPrint(response)
        //                        switch response.result {
        //                        case .success(let value):
        //                            let ss = value as! [String:Any]
        //                            let result = JSON(ss)
        //                            if result["success"].exists() {
        //                                if result["success"].intValue == 1
        //                                {
        //                                    completion(result["data"]["id"].intValue)
        //                                }else
        //                                {
        //                                    failed(ERROR_IN_API_ACTION,nil)
        //                                }
        //                            }else
        //                            {
        //                                failed(MESSAGE_SERVER_DOWN,nil)
        //                            }
        //
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
    func deleteProductImage(productID:Int,imageURLString:String,completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    {
        let urlString = endPoint_deleteProductImage()
        //
        let postData = ["productID":productID,"imageURL":imageURLString] as [String : Any]
        Connection.performPostWithToken(urlString: urlString, postData: postData, success: { (result) in
            if result["success"].exists() {
                if result["success"].intValue == 1
                {
                    completion(result["data"]["id"].intValue)
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
    func editProduct(product:DTOProduct,completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    {
        let urlString = endPoint_editProduct()
        //
        let postData:[String:Any] = ["id":product.product_id!,"name":product.product_name!,"description":(product.product_description ?? ""),"categoryID":product.product_categoryID!,"latitude":LocationHandler.latitude,"longitude":LocationHandler.longitude]
        
        Connection.performPostWithToken(urlString: urlString,postData:postData, success: { (result) in
            if result["success"].exists() {
                if result["success"].intValue == 1
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
    
    func addProduct(product:DTOProduct,completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    {
        let urlString = endPoint_addProduct()
        let postData:[String:Any] = ["name":product.product_name!,"description":(product.product_description ?? ""),"categoryID":product.product_categoryID!,"latitude":LocationHandler.latitude,"longitude":LocationHandler.longitude]
        
        Connection.performPostWithToken(urlString: urlString,postData:postData, success: { (result) in
            if result["success"].exists() {
                if result["success"].intValue == 1
                {
                    completion(result["data"]["id"].intValue)
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
        
        //        print(LocationHandler.latitude)
        //        print(LocationHandler.longitude)
        //        Alamofire.upload(
        //            multipartFormData: { multipartFormData in
        //                multipartFormData.append("\(product.product_categoryID!)".data(using: .utf8, allowLossyConversion: false)!, withName: "categoryId")
        //                multipartFormData.append("\(LocationHandler.latitude)".data(using: .utf8, allowLossyConversion: false)!, withName: "latitude")
        //                multipartFormData.append("\(LocationHandler.longitude)".data(using: .utf8, allowLossyConversion: false)!, withName: "longitude")
        //                multipartFormData.append("\(product.product_name!)".data(using: .utf8, allowLossyConversion: false)!, withName: "name")
        //                multipartFormData.append("\(product.product_description!)".data(using: .utf8, allowLossyConversion: false)!, withName: "description")
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
        //                            self.handleAddingProducts(json: JSON(ss), completion: completion, failed: failed)
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
    fileprivate func handleAddingProducts(json:JSON,completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    {
        if json["sucess"].exists() {
            if json["sucess"].boolValue == true
            {
                if json["data"]["id"].exists() {
                    completion(DTOProduct(json["data"]))
                    
                }else
                {
                    completion(nil)
                }
            }else if json["error"]["code"].exists()
            {
                let errorCode = (json["error"]["code"].string)!
                switch errorCode {
                    //                case "PRODUCT_REPORT_EXIST":
                //                    failed(MESSAGE_ITEM_ALREADY_REPORTED,InputType.mail)
                default:
                    
                    if let msg = json["error"]["message"].string {
                        
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
    //MARK: - product Actions
    func deleteProduct(productID:Int,completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    {
        let urlString = endPoint_deleteProduct()
        let postData = ["productID":productID]
        //
        Connection.performPostWithToken(urlString: urlString,postData: postData, success: { (result) in
            self.handleActionResponse(json: result, completion: completion, failed: failed)
            
        }) { (error) in
            failed(error?.localizedDescription,nil)
        }
    }
    
    func favoriteProduct(productID:Int,completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    {
        self.favorateProduct(productID: productID, isFavorate: 1, completion: completion, failed: failed)
    }
    func unfavoriteProduct(productID:Int,completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    {
        self.favorateProduct(productID: productID, isFavorate: 0, completion: completion, failed: failed)
    }
    private func favorateProduct(productID:Int,isFavorate:Int,completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    {
        let urlString = endPoint_favorite()
        let postData = ["productID" : productID,"isFavorit":isFavorate]
        //
        Connection.performPostWithToken(urlString: urlString, postData: postData, success:
            { (result) in
                self.handleActionResponse(json: result, completion: completion, failed: failed)
        }) { (error) in
            failed(error?.localizedDescription,nil)
        }
        
    }
    func likeProduct(productID:Int,completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    {
        self.likeProduct(productID: productID, isLike: 1, completion: completion, failed: failed)
    }
    func unlikeProduct(productID:Int,completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    {
        self.likeProduct(productID: productID, isLike: 0, completion: completion, failed: failed)
    }
    private func likeProduct(productID:Int,isLike:Int,completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    {
        let urlString = endPoint_like()
        let postData = ["productID" : productID,"isLike":isLike]
        //
        Connection.performPostWithToken(urlString: urlString, postData: postData, success:
            { (result) in
                self.handleActionResponse(json: result, completion: completion, failed: failed)
        }) { (error) in
            failed(error?.localizedDescription,nil)
        }
        
    }
    
    func reportProduct(productID:Int,reason:String,completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    {
        let urlString = endPoint_reportProduct()
        let postData = ["productID" : productID,"msg":reason] as [String : Any]
        //
        Connection.performPostWithToken(urlString: urlString, postData: postData, success:
            { (result) in
                self.handleActionResponse(json: result, completion: completion, failed: failed)
        }) { (error) in
            failed(error?.localizedDescription,nil)
        }
        
    }
    func requestProduct(productID:Int,ownerID:Int,completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    {
        let urlString = endPoint_requstItem()
        let postData = ["productID" : productID,"ownerID":ownerID] as [String : Any]
        //
        Connection.performPostWithToken(urlString: urlString, postData: postData, success:
            { (result) in
                self.handleActionResponse(json: result, completion: completion, failed: failed)
        }) { (error) in
            failed(error?.localizedDescription,nil)
        }
        
    }
    func markItemTaken(productID:Int,userID:Int,completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    {
        let urlString = endPoint_markItemAsTaken()
        let postData = ["productID" : productID,"userID":userID] as [String : Any]
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
    
    //MARK: - Taken
    
    
}
