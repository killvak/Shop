//
//  ConnectionHandler.swift
//  Pizza
//
//  Created by MacBook Pro on 1/3/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit


let mainDomain = "http://benefactorapp.net"
let baseURL = "\(mainDomain)/services/Benefactor/apis/"
//
// on success request
public typealias SucessBlock = (_ object:Any?) -> Void
// on failed request
public typealias FailureBlock = (_ msg:String?,_ object:Any?) -> Void


class ConnectionHandler: NSObject {
    
    //MARK: - URLS
    //MARK: -
    //MARK: User
    func  endPoint_login() ->String
    {
        return baseURL + "login.php"
    }
    func endPoint_signup() ->String
    {
        return baseURL + "register.php"
    }
    func endPoint_currentUserInfo() -> String
    {
        let endPoint_view = baseURL + "get_my_profile.php"
        return endPoint_view
    }

    func endPoint_userInfo() -> String
    {
        let endPoint_view = baseURL + "get_user_profile.php"
        return endPoint_view
    }
    func endPoint_getFollowings() ->String
    {
        let endPoint = baseURL + "get-followers.php"
        return endPoint
        
    }
    func endPoint_getFollowers() ->String
    {
        let endPoint = baseURL + "get-followings.php"
        return endPoint
    }
    func endPoint_editUser() -> String
    {
        let endPoint_view = baseURL + "edit_profile.php"
        return endPoint_view
    }
    func endPoint_editUserImage() -> String
    {
        let endPoint = baseURL + "edit-profile-picture.php"
        return endPoint
    }
    func endPoint_changePassword()->String
    {
        let endPoint = baseURL + "update-password.php"
        return endPoint

    }

    //MARK: category + products
    func endPoint_category () ->String
    {
        return baseURL + "get-categories.php"
    }
    func endPoint_categoryProducts() ->String
    {
        let endPoint_categoryProducts = baseURL + "get-products-by-category.php"
        return endPoint_categoryProducts
        
    }
    func endPoint_ownerProducts() ->String
    {
        let endPoint = baseURL + "get-products-by-owner.php"
        return endPoint
    }
    func endPoint_detailedProduct(_ productID:Int) -> String
    {
        let endPoint_view = baseURL + "product/\(productID)?access_token=" + DTOUser.access_token()
        return endPoint_view
    }
    func endPoint_deleteProduct() -> String
    {
        let endPoint = baseURL + "/delete-product.php"
        return endPoint
    }

    func endPoint_favorite() -> String
    {
        let endPoint = baseURL + "favorite-product.php"
        return endPoint
    }
//    func endPoint_unfavorite(_ productID:Int) -> String
//    {
//        let endPoint = baseURL + "product/favorite/\(productID)?access_token="  + DTOUser.access_token()
//        return endPoint
//    }
    func endPoint_like() -> String
    {
        let endPoint = baseURL + "like-product.php"
        return endPoint
    }
    func endPoint_reportProduct() -> String
    {
        let endPoint = baseURL + "report-product.php"
        return endPoint
    }
    //storeRestService/
    func endPoint_editProduct() -> String
    {
        let endPoint = baseURL + "edit-product.php"
        let url = Foundation.URL(string: endPoint.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!
        return url.absoluteString
    }

    func endPoint_addProduct() -> String
    {
        let endPoint = baseURL + "add-product.php"
        return endPoint
    }
    func endPoint_addProductImage() -> String
    {
        let endPoint = baseURL + "add-product-image.php"
        return endPoint
    }
    func endPoint_deleteProductImage() ->String
    {
        let endPoint = baseURL + "delete-product-image.php"
        return endPoint
    }
    func endPoint_countries() ->String
    {
        let endPoint = baseURL + "country"
        return endPoint
    }
    func endPoint_cities(_ countryID:Int) ->String
    {
        let endPoint = baseURL + "city?countryId=\(countryID)"
        return endPoint
    }
    func endPoint_completeProfile() ->String
    {
        let endPoint = baseURL + "user/info/"
        return endPoint
    }
    func endPoint_favoritedProducts() ->String
    {
        let endPoint = baseURL + "get-favorites-by-user-id.php"
        return endPoint
        
    }
    func endPoint_requstItem()-> String
    {
        let endPoint = baseURL + "request-product.php"
        return endPoint
    }
    func endPoint_markItemAsTaken()-> String
    {
        let endPoint = baseURL + "mark-product-taken.php"
        return endPoint
    }

    //MARK: Search
    func endPoint_searchProducts() ->String
    {
        let endPoint = baseURL + "search-products-by-location.php"
        return endPoint
        
    }
    //MARK: Other User
    func endPoint_follow() -> String
    {
        let endPoint = baseURL + "follow-user.php"
        return endPoint
    }
//    func endPoint_unfollow(_ userID:Int) -> String
//    {
//        let endPoint = baseURL + "user/follow/\(userID)?access_token="  + DTOUser.access_token()
//        return endPoint
//    }
//    func endPoint_checkFollow(_ userID:Int) ->String
//    {
//        let endPoint = baseURL + "user/checkiffollow/\(userID)?access_token="  + DTOUser.access_token()
//        return endPoint
//
//    }
    func endPoint_reportUser() -> String
    {
        let endPoint = baseURL + "report-user.php"
        return endPoint
    }
    //MARK: History
    func endPoint_takenProducts()->String
    {
        let endPoint = baseURL + "get-history-taken.php"
        return endPoint
    }
    func endPoint_givenProducts()->String
    {
        let endPoint = baseURL + "get-history-given.php"
        return endPoint
    }
    //MARK: Notifications
    func endPoint_unreadNotifications()->String
    {
        let endPoint = baseURL + "get-notification-unread-count.php"
        return endPoint
    }

    func endPoint_notifications()->String
    {
        let endPoint = baseURL + "get-notifications.php"
        return endPoint
    }
    func endPoint_addDevice()->String
    {
        let endPoint = baseURL + "add-device.php"
        return endPoint
    }
    func endPoint_deleteDevice()->String
    {
        let endPoint = baseURL + "delete-device.php"
        return endPoint
    }

    //MARK: Chat
    func endPoint_chatUsers()->String
    {
        let endPoint = baseURL + "get-chat-correspondents.php"
        return endPoint
    }
    func endPoint_getChat()->String
    {
        let endPoint = baseURL + "get-chat.php"
        return endPoint
    }
    func endPoint_sendMessage() ->String
    {
        let endPoint = baseURL + "send-message.php"
        return endPoint

    }
    func endPoint_deleteChat() ->String
    {
        let endPoint = baseURL + "delete-chat-room.php"
        return endPoint
    }
    //MARK: Version
    func endPoint_checkVersion() ->String
    {
        let endPoint = baseURL + "public/checkUpdate"
        return endPoint
        
    }



}

