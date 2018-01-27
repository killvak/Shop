//
//  AppDelegate.swift
//  Benefactor
//
//  Created by MacBook Pro on 12/31/16.
//  Copyright © 2016 Old Warriors. All rights reserved.
//

import UIKit
import Fabric
import TwitterKit
import FBSDKCoreKit
import IQKeyboardManagerSwift
import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import GoogleSignIn
import SwiftyJSON
import SCLAlertView
import GoogleMobileAds
import GooglePlaces


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        GADMobileAds.configure(withApplicationID: AdMobAppID)
//
        
        GMSPlacesClient.provideAPIKey("AIzaSyD4sTkvCtgOfgsoxJooy_norEgiXOwkkxw")

        //
        registerNotificationMethods(currentApplication: application)
        
        //
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        
        //
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        
        //force LTR
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
        
        //status bar
        UIApplication.shared.statusBarStyle = .default
        
        // Initialize Twitter
        Fabric.with([Twitter.self])
        if DTOUser.currentUser() != nil
        {
            NotificationsConnectonHandler.getUnreadCount()
        }

        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if DTOUser.currentUser() != nil
        {
            NotificationsConnectonHandler.getUnreadCount()
        }

    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    //MARK: - Social
    private func application(application: UIApplication,
                             openURL url: URL, options: [String: AnyObject]) -> Bool {
        if GIDSignIn.sharedInstance().handle(url as URL!,
                                             sourceApplication: options["UIApplicationOpenURLOptionsSourceApplicationKey"] as? String,
                                             annotation: options["UIApplicationOpenURLOptionsAnnotationKey"]) == true
        {
            return true
        }
        else if FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: options["UIApplicationOpenURLOptionsSourceApplicationKey"] as? String, annotation: options["UIApplicationOpenURLOptionsAnnotationKey"]) == true
        {
            return true
        }
        
        else if Twitter.sharedInstance().application(application, open: url, options: options) == true
        {
            return true
        }
        
        return true
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool
    {
        if GIDSignIn.sharedInstance().handle(url,
                                             sourceApplication: sourceApplication,
                                             annotation: annotation) == true {
            return true
        }
        else if FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation) == true
        {
            return true
        }
        return false
        
    }
    


}
//MARK: - Notifications Methods  -
extension AppDelegate {
    func registerNotificationMethods(currentApplication : UIApplication){
        if #available(iOS 10, *) {
            
            //Notifications get posted to the function (delegate):  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: () -> Void)"
            
            
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
                
                guard error == nil else {
                    //Display Error.. Handle Error.. etc..
                    return
                }
                
                if granted {
                    //Do stuff here..
                    
                    //Register for RemoteNotifications. Your Remote Notifications can display alerts now :)
                    DispatchQueue.main.async {
                        currentApplication.registerForRemoteNotifications()
                    }
                    
                }
                    
                else {
                    //Handle user denying permissions..
                }
            }
            
            //Register for remote notifications.. If permission above is NOT granted, all notifications are delivered silently to AppDelegate.
            currentApplication.registerForRemoteNotifications()
        }
        else {
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            currentApplication.registerUserNotificationSettings(settings)
            currentApplication.registerForRemoteNotifications()
        }
        FIRApp.configure()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.tokenRefreshNotification),
                                               name: .firInstanceIDTokenRefresh,
                                               object: nil)
        let tokenFea = FIRInstanceID.instanceID().token() ?? ""
        //        userDefaults.set(tokenFea, forKey: DeviceToken)
        
        print(tokenFea)
    }
    
    
    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // Print message ID.
        //        if let messageID = userInfo[gcmMessageIDKey] {
        //            print("Message ID: \(messageID)")
        //        }
        
        // Print full message.
        print(userInfo)
        self.handleNotification(userInfo: userInfo["data"] as! [String : Any])
        
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // Print message ID.
        //        if let messageID = userInfo[gcmMessageIDKey] {
        //            print("Message ID: \(messageID)")
        //        }
        
        // Print full message.
        print(userInfo)
        handleNotification(userInfo: userInfo as! [String : Any])
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // [END receive_message]
    // [START refresh_token]
    func tokenRefreshNotification(_ notification: Notification) {
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
            UserDefaults.standard.set(refreshedToken, forKey: "deviceToken")
            UserDefaults.standard.synchronize()            
        }
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    // [END refresh_token]
    //     [START connect_to_fcm]
    func connectToFcm() {
        // Won't connect since there is no token
        guard FIRInstanceID.instanceID().token() != nil else {
            return
        }
        
        // Disconnect previous FCM connection if it exists.
        FIRMessaging.messaging().disconnect()
        //
        FIRMessaging.messaging().connect { (error) in
            if error != nil {
                print("Unable to connect with FCM. \(error?.localizedDescription ?? "")")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    // [END connect_to_fcm]
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    func handleNotification(userInfo : [String : Any]){
        let json = JSON(userInfo)
        if let productData = json["product"].string?.data(using: .utf8) , let userData = json["user"].string?.data(using: .utf8)
        {
            self.handleProductNotification(json,productData,userData)
        }else if let messageData = json["message"].stringValue.data(using: .utf8)  ,let userData = json["user"].stringValue.data(using: .utf8)
        {
            let messageObj  = JSON(messageData)
            let message = messageObj["message"].stringValue
            guard let nav = self.window?.rootViewController?.presentedViewController as? SlideNavigationController else
            {
                if let root = self.window?.rootViewController as? RootViewController{
                    root.message = message
                    root.userData = userData
                }
                return
            }
            let isDelivered = self.addMessageLocally(message, userData, nav)
            if isDelivered == false
            {
                self.showMessageNotification(message, userData, nav)
            }
            
        }
        


//        UIAlertView(title: json["aps"]["title"].stringValue, message: json["user"].stringValue, delegate: nil, cancelButtonTitle: "cancel", otherButtonTitles: "string" ).show()
        
    }
    private func handleProductNotification(_ json:JSON,_ productData:Data, _ userData:Data)
    {
        var type = NotificationType.response
        if json["code"].intValue == 1
        {
            type = .request
        }
        let productJson = JSON(productData)
        let userJson = JSON(userData)
        if let nav = self.window?.rootViewController?.presentedViewController as? SlideNavigationController
        {
            if let vc = nav.viewControllers.last as? NotificationsViewController
            {
                vc.selectedProduct = DTOProduct(productJson)
                vc.selectedUser = DTOUser(otherProfile:userJson)
                vc.selectedType = type
                vc.loadData()
                return
            }
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotificationsViewController") as! NotificationsViewController
            vc.selectedProduct = DTOProduct(productJson)
            vc.selectedUser = DTOUser(otherProfile:userJson)
            vc.selectedType = type
            if nav.isSideMenuOpen()
            {
                nav.setContentViewController(vc)
            }else
            {
                nav.setViewControllers([vc], animated: true)
            }
        }else if let root = self.window?.rootViewController as? RootViewController
        {
            root.selectedProduct = DTOProduct(productJson)
            root.selectedUser = DTOUser(otherProfile:userJson)
            root.selectedType = type
        }

    }
    private func addMessageLocally(_ message:String,_ userData:Data,_ nav:SlideNavigationController) ->Bool
    {
        if let vc = nav.viewControllers.last as? MessageViewController
        {
            let userJson = JSON(userData)
            let userObj = DTOUser(otherProfile:userJson)
            if vc.user.user_id == userObj.user_id
            {
                vc.newNotificationMessage(text:message,sender:userObj)
                return true
                
            }
        }
        return false
    }
    func showMessageNotification(_ message:String,_ userData:Data,_ nav:SlideNavigationController)
    {
        let userJson = JSON(userData)
        let userObj = DTOUser(otherProfile:userJson)

        let appearance = SCLAlertView.SCLAppearance(
            kWindowWidth:SCREEN_WIDTH - 100,
            kWindowHeight:SCREEN_HEIGHT/2.5,
            showCloseButton: false
        )
        let alert = SCLAlertView(appearance: appearance)
        
        let txt = alert.addTextView()
        txt.isEditable = false
        txt.textAlignment = .left
        txt.text = message
        alert.addButton("View") {
            let vc = MessageViewController()
            vc.user = userObj
            nav.pushViewController(vc, animated: true)
        }
        alert.addButton("Cancel") {}
        alert.showInfo("New Message", subTitle: userObj.displayName)

    }
}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        // Print message ID.
        //        if let messageID = userInfo[gcmMessageIDKey] {
        //            print("Message ID: \(messageID)")
        //        }
        
        // Print full message.
        print(userInfo)
        handleNotification(userInfo: userInfo["data"] as! [String : Any])
        // Change this to your preferred presentation option
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        //        if let messageID = userInfo[gcmMessageIDKey] {
        //            print("Message ID: \(messageID)")
        //        }
        
        // Print full message.
        print(userInfo)
        handleNotification(userInfo: userInfo["data"] as! [String : Any])
        
        completionHandler()
    }
    
}

extension AppDelegate : FIRMessagingDelegate {
    //     Receive data message on iOS 10 devices while app is in the foreground.
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
}

