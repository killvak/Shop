//
//  CompleteProfileConnectionHandler.swift
//  Benefactor
//
//  Created by MacBook Pro on 3/3/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit
import SwiftyJSON

class CompleteProfileConnectionHandler: ConnectionHandler {
    func requestCountries(completion:@escaping SucessBlock,failure failed: @escaping FailureBlock)
    {
        let urlString = endPoint_countries()
        
        Connection.performGet(urlString: urlString, success: { (result) in
            self.handleCountryResult(result: result,completion: completion, failed: failed)
        }) { (error) in
            failed(error?.localizedDescription,nil)
        }
    }
    func handleCountryResult(result:JSON,completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    {
        if result["sucess"].bool == true
        {
            let data = result["data"]
            let arr = DTOCountry.collection(data: data)
            completion(arr)
        }else
        {
            failed(MESSAGE_SERVER_DOWN,nil)
        }
    }
    
    func requestCities(countryID:Int,completion:@escaping SucessBlock,failure failed: @escaping FailureBlock)
    {
        let urlString = endPoint_cities(countryID)
        
        Connection.performGet(urlString: urlString, success: { (result) in
            self.handleCitiesResult(result: result,completion: completion, failed: failed)
        }) { (error) in
            failed(error?.localizedDescription,nil)
        }
    }
    func handleCitiesResult(result:JSON,completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    {
        if result["sucess"].bool == true
        {
            let data = result["data"]
            let arr = DTOCity.collection(data: data)
            completion(arr)
        }else
        {
            failed(MESSAGE_SERVER_DOWN,nil)
        }
    }
    func completeProfile(countryID:Int,cityID:Int,region:String?,zipCode:String?,completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    {
        let urlString = endPoint_completeProfile()
        let postData = ["countryId" : countryID,"cityId":cityID,"region":region ?? "","zipCode":zipCode ?? "","access_token":DTOUser.access_token()] as [String : Any]
        //
        Connection.performPost(urlString: urlString, extraHeaders: nil, postData: postData, success:
            { (result) in
                self.handleCompleteResult(result: result, completion: completion, failed: failed)
        }) { (error) in
            failed(error?.localizedDescription,nil)
        }

    }
    func handleCompleteResult(result:JSON,completion:@escaping SucessBlock,failed: @escaping FailureBlock)
    {
        if result["sucess"].bool == true
        {
            let user = DTOUser(profile: result["data"])
            if user.user_id == DTOUser.currentUser()?.user_id
            {
                let current = DTOUser.currentUser()!
                current.user_image = user.user_image
//                current.user_cityID = user.user_cityID
//                current.user_cityName = user.user_cityName
                current.user_region = user.user_region
                current.user_zipCode = user.user_zipCode
                current.saveUser()
                current.setAsCurrent()
            }
            completion(user)
        }else
        {
            failed(MESSAGE_SERVER_DOWN,nil)
        }
    }

    
}
