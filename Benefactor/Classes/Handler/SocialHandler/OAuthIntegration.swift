//
//  OAuthIntegration.swift
//  SocialIntegration
//
//  Created by MacBook Pro on 12/30/16.
//  Copyright © 2016 MacBook Pro. All rights reserved.
//

import UIKit
import FBSDKShareKit
import FBSDKLoginKit
import FBSDKCoreKit
import TwitterKit
import GoogleSignIn


enum SocialNetwork:Int
{
    case facebook = 1
    case twitter = 2
    case googlePlus = 3
}
protocol OAuthIntegrationDelegate {
    func integrationDidLoad(data:OAuthUser!,type:SocialNetwork)
    func integrationDidFail(msg:String,type:SocialNetwork)
    func integrationDidCancelled(_ type:SocialNetwork)
    
}

class OAuthIntegration: NSObject ,GIDSignInDelegate{
    var delegate:OAuthIntegrationDelegate?
    var networkType:SocialNetwork = .facebook
    //MARK:- Facebook
    func requestFacebook(ownerVC:UIViewController)
    {
        guard let accessToken = FBSDKAccessToken.current() else {
            
            let loginManager = FBSDKLoginManager()
            
            loginManager.logIn(withReadPermissions: ["public_profile","email"], from: ownerVC, handler: { (loginResult, error) in
                
                if let error = error {
                    
                    self.delegate?.integrationDidFail(msg: (error.localizedDescription), type: .facebook)
                    
                    return
                }
                
                
                guard let loginResult = loginResult else {
                    
                    self.delegate?.integrationDidFail(msg: "", type: .facebook)
                    
                    return
                }
                
                if loginResult.isCancelled {
                    
                    self.delegate?.integrationDidCancelled(.facebook)
                    
                    return
                }
                
                self.retrieveFBData(token: loginResult.token.tokenString)
                
            })
            
            return
        }
        
        self.retrieveFBData(token: accessToken.tokenString)
    }
    
    private func retrieveFBData(token:String)
    {
        let req = FBSDKGraphRequest(graphPath: "me?fields=id,email,name,first_name,last_name,picture.width(720).height(720)", parameters: nil, tokenString: token, version: nil, httpMethod: "GET")!
        req.start(completionHandler: { (connection, result, error) in
            if(error == nil)
            {
                print("result \(result)")
                let dic = result as! [String:Any]
                let result = OAuthUser()
                result.userName = dic["name"] as? String
                result.userEmail = dic["email"] as? String
                result.userFirstName = dic["first_name"] as! String
                result.userLastName = dic["last_name"] as! String
                result.userID = "\(dic["id"]!)"
                if let pic = ((dic["picture"] as? [String:Any])?["data"] as? [String:Any])?["url"] as? String
                {
                    result.userImageSource = pic
                }
//                let facebookProfileUrl = "http://graph.facebook.com/\(dic["id"]!)/picture?type=large"
//                result.userImageSource = facebookProfileUrl
                result.userToken = token
                self.delegate?.integrationDidLoad(data: result, type: .facebook)
                
            }
            else
            {
                self.delegate?.integrationDidFail(msg: (error?.localizedDescription)!, type: .facebook)
            }
            
        })
        
    }
    //MARK:- Twitter
    func requestTwitter(ownerVC:UIViewController)
    {
        Twitter.sharedInstance().logIn(with: ownerVC, methods: [.systemAccounts]) { (session, error) in

//        Twitter.sharedInstance().logIn(withMethods: .systemAccounts) { session, error in
            if (session != nil) {
                print("signed in as \(session?.userName)");
                let client = TWTRAPIClient.withCurrentUser()
                let request = client.urlRequest(withMethod: "GET",
                                                url: "https://api.twitter.com/1.1/account/verify_credentials.json",
                                                parameters: ["include_email": "true", "skip_status": "true"],
                                                error: nil)
                client.sendTwitterRequest(request, completion: { (response, data, error) in
                    if(error == nil)
                    {
                        let datastring = String(data: data!, encoding: .utf8)
                        do {
                            if let dictionaryOK = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject] {
                                // parse JSON
                                print("result \(dictionaryOK)")
                                let result = OAuthUser()
                                result.userName = dictionaryOK["name"] as? String
                                result.userEmail = dictionaryOK["email"] as? String
                                result.userID = dictionaryOK["id"]?.stringValue
                                let test = SplitHandler.dividedName(name: result.userName!)
                                result.userFirstName = test.0
                                result.userLastName = test.1
                                result.userToken = session?.authToken
                                result.userImageSource = dictionaryOK["profile_image_url"] as? String
                                self.delegate?.integrationDidLoad(data: result, type: .twitter)
                                
                            }
                        } catch {
                            print(error)
                        }
                        print("result \(datastring)")
                        //                        let dic = result as! [String:Any]
                        //                        let result = OAuthUser()
                        //                        result.userName = dic["name"] as? String
                        //                        result.userEmail = dic["email"] as? String
                        //                        self.delegate?.integrationDidLoad(data: result, type: .googlePlus)
                        
                    }
                    else
                    {
                        print("error \(error)")
                        self.delegate?.integrationDidFail(msg: (error?.localizedDescription)!, type: .twitter)
                        
                    }
                    
                })
            } else {
                //                print("\(error?.localizedDescription)")
                //                print("\((error as! NSError).code)")
                //                self.delegate?.integrationDidFail(msg: (error?.localizedDescription)!, type: .twitter)
                if(error == nil)
                {
                self.delegate?.integrationDidCancelled(.twitter)
                }else{
                    self.delegate?.integrationDidFail(msg: (error?.localizedDescription)!, type: .twitter)

                }
                
            }
        }
        
    }
    //MARK:- Google
    func requestGoogle(googleUIDelegate:GIDSignInUIDelegate)
    {
        GIDSignIn.sharedInstance().delegate = self
        
        GIDSignIn.sharedInstance().uiDelegate = googleUIDelegate
        
        GIDSignIn.sharedInstance().signIn()
    }
    // The sign-in flow has finished and was successful if |error| is |nil|.
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)
    {
        if (error == nil) {
            print(user.profile.email)
            print(user.profile.givenName)
            print(user.profile.familyName)
            let result = OAuthUser()
            result.userName = user.profile.name
            result.userEmail = user.profile.email
            result.userToken = user.authentication.idToken
            result.userFirstName = user.profile.givenName
            result.userLastName = user.profile.familyName
            result.userID = user.userID

            if user.profile.hasImage == true {
                result.userImageSource = user.profile.imageURL(withDimension: 200).absoluteString
            }
            self.delegate?.integrationDidLoad(data: result, type: .googlePlus)
        } else {
            if  (error as NSError).code == -5 {
                // code
                self.delegate?.integrationDidCancelled(.googlePlus)
            }else
            {
                print("\(error.localizedDescription)")
                print("\((error as NSError).code)")
                self.delegate?.integrationDidFail(msg: (error?.localizedDescription)!, type: .googlePlus)
            }
            
            
        }
        
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    
}
class SplitHandler{
    
    class func dividedName(name:String) -> (String,String)
    {
        guard let range = name.range(of:" ") else {
            return (name," ")
        }
        let first = name.substring(to: range.lowerBound)
        let end = name.index(after: range.lowerBound)
        let last = name.substring(from: end)
        return (first,last)
        
        
    }
}
