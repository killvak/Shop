//
//  DTOProduct.swift
//  Benefactor
//
//  Created by MacBook Pro on 2/14/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreLocation

enum ItemProductStatus:Int
{
    case available = 1
    case banned = 2
    case deleted = 3
    case taken = 4
    case pendingTaken = 5
    case other  = 0
}
fileprivate var currentLocation:CLLocation? = nil
class DTOProduct: NSObject {
    //MARK: - Var
    var product_id:Int!
    var product_name:String!
    var product_description:String?
    var product_status:ItemProductStatus = .available
//    var product_date:Date!
    var product_viewsCount:Int!
    var product_images:[DTOImage]?
//    var product_location:CLLocation!
    var product_likesCount:Int!
    var product_categoryID:Int!
    var product_categoryName:String?
//    var product_ownerName:String!
//    var product_ownerImage:String!
    var product_ownerID:Int!
//    var product_ownerIsFollowed:Bool = false
    var product_isLiked:Bool!
    var product_isFavorited:Bool!
    var product_urlString:String!
    //
//    var product_detailsIsLoaded:Bool = false
    var product_distance:String!
    var product_dateStringShort:String!
    var product_dateStringLong:String!
    //MARK: - init
    override init() {
        super.init()
    }
    init(_ json:JSON) {
        super.init()
        product_id = json["id"].intValue
        product_status = ItemProductStatus(rawValue: json["statusID"].intValue)!
        product_categoryID = json["categoryID"].intValue
        product_name = json["name"].string
        product_description = json["description"].string
        product_viewsCount = json["viewsCount"].intValue
        product_likesCount = json["likesCount"].intValue
        product_urlString = json["shareURL"].stringValue
                product_ownerID = json["ownerID"].intValue
                product_isLiked = (json["isLiked"].intValue != 0)
                product_isFavorited = json["isFavorited"].boolValue


        //date
        let interval = json["datePosted"].floatValue
        let date = Date(timeIntervalSince1970: TimeInterval(interval))
        convertDateToString(date)
        //distance
        if currentLocation != nil {
            let lat = json["latitude"].doubleValue
            let lng = json["longitude"].doubleValue
            let loc = CLLocation(latitude: lat, longitude: lng)
            calcDistance(loc)
        }
        //images
        if let images = json["images"].array
        {
            if images.count > 0
            {
                product_images = [DTOImage]()
                for imgObj in images
                {
                    product_images?.append(DTOImage(stringOnly:imgObj))
                }
            }
        }
    }
//    init(notifyProduct json:JSON) {
//        super.init()
//        product_id = json["ProductId"].intValue
//        product_status = ItemProductStatus(rawValue: json["StatusId"].intValue)!
//        product_categoryID = json["CategoryId"].intValue
//        product_name = json["Name"].string
//        product_description = json["Description"].string
//        product_viewsCount = json["Views"].intValue
//        product_likesCount = json["ProductImages"].intValue
//        
//        //date
//        let interval = json["DatePosted"].floatValue / 1000.0
//        let date = Date(timeIntervalSince1970: TimeInterval(interval))
//        convertDateToString(date)
//        //distance
//        if currentLocation != nil {
//            let lat = json["Latitude"].doubleValue
//            let lng = json["Longitude"].doubleValue
//            let loc = CLLocation(latitude: lat, longitude: lng)
//            calcDistance(loc)
//        }
//        //images
//        if let images = json["ProductImages"].array
//        {
//            if images.count > 0
//            {
//                product_images = [DTOImage]()
//                for imgObj in images
//                {
//                    product_images?.append(DTOImage(stringOnly:imgObj))
//                }
//            }
//        }
//    }
    init(notifySmallProduct json:JSON) {
        super.init()
        product_id = json["id"].intValue
        product_categoryID = json["categoryID"].intValue
        product_name = json["name"].string
//        product_ownerID = json["ownerId"].intValue
        
        //distance
        if currentLocation != nil {
            let lat = json["latitude"].doubleValue
            let lng = json["longitude"].doubleValue
            let loc = CLLocation(latitude: lat, longitude: lng)
            calcDistance(loc)
        }
        //images
        //FIXME:test after image upload
        if let images = json["images"].array
        {
            if images.count > 0
            {
                product_images = [DTOImage]()
                for imgObj in images
                {
                    product_images?.append(DTOImage(stringOnly:imgObj))
                }
            }
        }
    }
    class func collection(data:JSON,lat:Double?,lng:Double?) -> [DTOProduct]
    {
        if lat != nil{
            currentLocation = CLLocation(latitude: lat!, longitude: lng!)
        }
        let contents = data
        let arr = (contents.array)!
        var result = [DTOProduct]()
        for dic in arr
        {
            result.append(DTOProduct(dic))
        }
        return result
    }
    class func collectionSearch(data:JSON,lat:Double?,lng:Double?) -> [DTOProduct]
    {
        if lat != nil{
            currentLocation = CLLocation(latitude: lat!, longitude: lng!)
        }
        let contents = data["content"]
        let arr = (contents.array)!
        var result = [DTOProduct]()
        for dic in arr
        {
            result.append(DTOProduct(dic["entity"]))
        }
        return result
    }

    //MARK: - Details
//    func refreshDetailedProperties(_ json:JSON)
//    {
//        product_detailsIsLoaded = true
//        product_likesCount = json["likesCount"].intValue
//    
////        product_ownerImage = json["ownerImageURL"].stringValue
////        product_ownerID = json["ownerId"].intValue
////        product_ownerIsFollowed = json["ownerFollowed"].bool ?? false
////        guard let first = json["ownerFirstName"].string ,let last = json["ownerLastName"].string else {
////            product_ownerName = json["ownerUserName"].stringValue
////            return
////        }
////        product_ownerName = first + " " + last
//    }
    //MARK: - Helpers
    fileprivate func convertDateToString(_ date:Date)
    {
        let dateformat = DateFormatter()
        dateformat.dateStyle = .long
        dateformat.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        product_dateStringShort =  dateformat.string(from: date)
        dateformat.dateStyle = .long
        dateformat.timeStyle = .short
        product_dateStringLong =  dateformat.string(from: date)

    }
    fileprivate func calcDistance(_ location:CLLocation)
    {
        let loc = currentLocation!
        let meters = loc.distance(from: location)
        if DistanceHandler.sharedManager.isMile()
        {
            let miles = meters * (0.000621371192)
            let milesNum = Float(miles)
            product_distance = String(format: "%.2f", milesNum)
        }else
        {
            let kilos = meters * (0.001)
            let kilosNum = Float(kilos)
            product_distance = String(format: "%.2f", kilosNum)
        }
    }

}
class DTOImage:NSObject
{
    var image_urlString:String!
    var image_id:Int!
    init(_ json:JSON) {
        super.init()
        image_id = json["id"].intValue
        image_urlString = json["url"].stringValue
    }
    init(stringOnly json:JSON) {
        super.init()
        image_id = 0
        image_urlString = json.stringValue
    }

}
