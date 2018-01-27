//
//  DTOUser.swift
//  Benefactor
//
//  Created by MacBook Pro on 1/4/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit
import SwiftyJSON

//regular User:used in sign in/sign up/profile
private var sharedUser:DTOUser? = nil

final class DTOUser: NSObject,NSCoding {
    var user_id: Int!
    var user_token: String!
    var user_name: String?
    var user_firstName: String?
    var user_lastName: String?
    var user_email: String?
    var user_image: String?
//    var user_cityName:String?
//    var user_cityID:Int?
//    var user_countryID:Int?
    var user_followersCount:Int?
    var user_followingCount:Int?
    var user_viewsCount:Int?
    var user_takenCount:Int?
    var user_givenCount:Int?
    var user_whishCount:Int?
    var user_region:String?
    var user_zipCode:String?
    var user_isFollowed:Bool = false
    var displayName: String{
        guard let fName = user_firstName,let lName = user_lastName , fName != "" , lName  != "" else {
            return self.user_name!
        }
        return (fName + " " + lName)
    }

    //MARK: - parsing
    init(_ json: JSON) {
        super.init()
        //token
        user_token = json["token"].stringValue
        //user data
        let profile = json["data"]
        user_id = profile["id"].intValue
        user_name = profile["username"].string
        user_email = profile["email"].string
        user_image = profile["profilePicURL"].string
        user_firstName = profile["firstName"].stringValue
        user_lastName = profile["lastName"].stringValue
    }
    init(profile: JSON) {
        super.init()
        //user data
        user_id = profile["id"].intValue
        user_name = profile["username"].string
        user_email = profile["email"].string
        user_image = profile["profilePicURL"].string
//        let city = profile["city"]
//        user_cityName = city["name"].string
//        user_cityID = city["id"].int
//        user_countryID = city["countryId"].int
        user_followersCount = profile["followersCount"].int
        user_followingCount = profile["followingCount"].int
        user_viewsCount = profile["viewsCount"].int
        user_takenCount = profile["takenCount"].int
        user_givenCount = profile["givenCount"].int
        user_whishCount = profile["viewsCount"].int
//        user_region = profile["region"].string
//        user_zipCode = profile["zipCode"].string
        user_firstName = profile["firstName"].string
        user_lastName = profile["lastName"].string
        
        user_isFollowed = (profile["isFollow"].intValue != 0)
        //
        self.checkForCacheRefresh()
    }
    init(otherProfile: JSON) {
        super.init()
        //user data
        user_id = otherProfile["id"].intValue
        user_name = otherProfile["username"].string
        user_email = otherProfile["email"].string
        user_image = otherProfile["profilePicURL"].string
//        let city = otherProfile["city"]
//        user_cityName = city["name"].string
//        user_cityID = city["id"].int
//        user_countryID = city["countryId"].int
        user_followersCount = otherProfile["followersCount"].int
        user_followingCount = otherProfile["followingCount"].int
        user_viewsCount = otherProfile["viewsCount"].int
        user_takenCount = otherProfile["takenCount"].int
        user_givenCount = otherProfile["givenCount"].int
        user_whishCount = otherProfile["viewsCount"].int
        user_region = otherProfile["region"].string
        user_zipCode = otherProfile["zipCode"].string
        user_firstName = otherProfile["firstName"].stringValue
        user_lastName = otherProfile["lastName"].stringValue

    }
    
//    init(notifyUser otherProfile: JSON) {
//        super.init()
//        //user data
//        user_id = otherProfile["UserId"].intValue
//        user_name = otherProfile["Username"].string
//        user_firstName = otherProfile["FirstName"].stringValue
//        user_lastName = otherProfile["LastName"].stringValue
//        user_email = otherProfile["Email"].string
//        user_image = otherProfile["ProfilePicURL"].string
////        let city = otherProfile["City"]
////        user_cityName = city["CityName"].string
////        user_cityID = otherProfile["CityId"].int
////        user_countryID = city["CountryId"].int
////        user_followersCount = otherProfile["followersCount"].int
////        user_followingCount = otherProfile["followingCount"].int
////        user_viewsCount = otherProfile["viewsCount"].int
////        user_takenCount = otherProfile["takenCount"].int
////        user_givenCount = otherProfile["givenCount"].int
////        user_whishCount = otherProfile["viewsCount"].int
//        user_region = otherProfile["Region"].string
//        user_zipCode = otherProfile["ZipCode"].string
//    }


    
    func checkForCacheRefresh()
    {
        if self.user_id == DTOUser.currentUser()?.user_id
        {
            let current = DTOUser.currentUser()!
            self.user_token = current.user_token
            self.setAsCurrent()
            self.saveUser()
        }
    }
    //MARK: - saving
    class func savedUser() -> DTOUser?
    {
        if let encodedData = UserDefaults.standard.data(forKey: "User") {
            let user = NSKeyedUnarchiver.unarchiveObject(with: encodedData) as? DTOUser
            return user
        }
        return nil
    }
    required public init(coder decoder:NSCoder) {
        self.user_id = decoder.decodeObject(forKey: "id") as! Int
        self.user_token = decoder.decodeObject(forKey: "token") as! String
        self.user_name = decoder.decodeObject(forKey: "name") as? String
        self.user_firstName = decoder.decodeObject(forKey: "first") as? String
        self.user_lastName = decoder.decodeObject(forKey: "last") as? String
        self.user_email = decoder.decodeObject(forKey: "email") as? String
        self.user_image = decoder.decodeObject(forKey: "image") as? String
//        self.user_cityID = decoder.decodeObject(forKey: "cityID") as? Int
//        self.user_cityName = decoder.decodeObject(forKey: "cityName") as? String
        self.user_region = decoder.decodeObject(forKey: "user_region") as? String
        self.user_zipCode = decoder.decodeObject(forKey: "user_zipCode") as? String
    }
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(user_token, forKey: "token")
        aCoder.encode(user_id, forKey: "id")
        aCoder.encode(user_name, forKey: "name")
        aCoder.encode(user_firstName, forKey: "first")
        aCoder.encode(user_lastName, forKey: "last")
        aCoder.encode(user_email, forKey: "email")
        aCoder.encode(user_image, forKey: "image")
//        aCoder.encode(user_cityID, forKey: "cityID")
//        aCoder.encode(user_cityName, forKey: "cityName")
        aCoder.encode(user_region, forKey: "user_region")
        aCoder.encode(user_zipCode, forKey: "user_zipCode")
    }
    func saveUser()
    {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: self)
        UserDefaults.standard.set(encodedData, forKey: "User")
        UserDefaults.standard.synchronize()
    }
    //MARK: - cashing
    func setAsCurrent()
    {
        sharedUser = self
    }
    class func access_token() ->String
    {
        guard let current = sharedUser else {
            return ""
        }
        return current.user_token
    }
    class func currentUser() -> DTOUser?
    {
        return sharedUser
    }
    //MARK: - logOut
    func logOut()
    {
        if DTOUser.savedUser() != nil {
            UserDefaults.standard.removeObject(forKey: "User")
            UserDefaults.standard.synchronize()
        }
        sharedUser = nil
    }

}
//used to collect data from social network
class OAuthUser:NSObject {
    
    var userName:String?
    var userEmail:String?
    var userFirstName:String!
    var userLastName:String!
    var userID:String!
    var userImageSource:String?
    var userToken:String?
   
//    class  func getCasedUser() -> OAuthUser? {
//        
//        let defaults = UserDefaults.standard
//        if  defaults.object(forKey: "authUser") != nil {
//            let user = OAuthUser()
//            user.userName = defaults.object(forKey: "authUser") as? String
//            user.userEmail = defaults.object(forKey: "authUserEmail") as? String
//            user.userImageSource = defaults.object(forKey: "authUserImageSource") as? String
//            user.userToken = defaults.object(forKey: "authUserToken") as? String
//            return user
//        }
//        return nil
//    }
//    
//    func saveUser() {
//        
//        guard let name = userName else {
//            return
//        }
//        guard let token = userToken else {
//            return
//        }
//        if name.isEmpty || token.isEmpty {
//            return
//        }
//        let defaults = UserDefaults.standard
//        defaults.set(name, forKey: "authUser")
//        defaults.set(userEmail, forKey: "authUserEmail")
//        defaults.set(userImageSource, forKey: "authUserImageSource")
//        defaults.set(token, forKey: "authUserToken")
//        defaults.synchronize()
//    }
//    
//    func logOut() {
//        
//        let defaults = UserDefaults.standard
//        defaults.removeObject(forKey: "authUser")
//        defaults.removeObject(forKey: "authUserEmail")
//        defaults.removeObject(forKey: "authUserImageSource")
//        defaults.removeObject(forKey: "authUserToken")
//        defaults.synchronize()
//    }
}

//used to collect data from all registration steps
class RegisterUser: NSObject {
   
    var user_nickName:String?
    var user_mail:String?
    var user_password:String?
    var user_firstName:String?
    var user_lastName:String?
    var user_imagePath:String?
    var error_message:String?
}
