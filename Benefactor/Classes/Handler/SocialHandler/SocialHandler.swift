//
//  SocialHandler.swift
//  Benefactor
//
//  Created by Ahmed Shawky on 9/28/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit
protocol SocialHandlerDelegate {
    func linkingDidSucceed(result:DTOUser)
    func linkingDidFail(msg:String)
    
}

class SocialHandler: NSObject {
    var user:OAuthUser!
    var delegate : SocialHandlerDelegate!
    func login1()
    {
        UserConnectionHandler().logIn(name: user.userID!, password: user.userID!, completion: { (result) in
            self.delegate.linkingDidSucceed(result: result as! DTOUser)

            }, failed: { (message,_) in
                if message == "Wrong username or password"
                {
                    self.signUp()
                }else{
                    self.delegate.linkingDidFail(msg: message!)

                }
        })
    }
    func login2()
    {
        UserConnectionHandler().logIn(name: user.userID!, password: user.userID!, completion: { (result) in
            self.delegate.linkingDidSucceed(result: result as! DTOUser)
            }, failed: { (message,_) in
                self.delegate.linkingDidFail(msg: message!)
        })
    }

    func signUp()
    {
        let sharedUser = RegisterUser()
        sharedUser.user_nickName = user.userID!
        sharedUser.user_password = user.userID!
        sharedUser.user_mail = user.userEmail
        sharedUser.user_firstName = user.userFirstName!
        sharedUser.user_lastName = user.userLastName!
        sharedUser.user_imagePath = user.userImageSource

        UserConnectionHandler().register(user: sharedUser, completion: { (result) in
            self.login2()
        }) { (message, object) in
            self.delegate.linkingDidFail(msg: message!)
        }

    }
}
