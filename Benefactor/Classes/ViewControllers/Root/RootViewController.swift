//
//  RootViewController.swift
//  Benefactor
//
//  Created by MacBook Pro on 12/31/16.
//  Copyright © 2016 Old Warriors. All rights reserved.
//

import UIKit
import SCLAlertView
import CoreLocation
import GooglePlaces

class RootViewController: UIViewController,LocationHandlerDelegate {
    
//    var shouldOpenHome = false
    var locationHandler = LocationHandler()
    weak var locationAlert:SCLAlertView?
    var selectedUser:DTOUser?
    var selectedProduct:DTOProduct?
    var selectedType:NotificationType?
    var message:String?
    var userData:Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //
        UIViewController.configureLoading()
        //
        checkUpdate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        //
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openHomeScene() {
        
        let nav = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "home")
        nav.modalTransitionStyle = .crossDissolve
        self.present(nav, animated: true, completion: nil)
    }
    func openGuideScene() {
        
        let nav = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "guide")
        nav.modalTransitionStyle = .crossDissolve
        self.present(nav, animated: true, completion: nil)
    }
    func startLocationDetection()
    {
        if locationHandler.isWaitingForLocation == false
        {
            self.startMainApp()
            return
        }
        self.locationHandler.delegate = self
        self.locationHandler.createManager()


    }
    func autocompleteClicked() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }

    func startApp()
    {
        addNeededObserver()
        var saved:DTOUser?
        if let user = DTOUser.currentUser()
        {
            saved = user
        }else if let user = DTOUser.savedUser()
        {
            saved = user

        }
    
        let shouldOpenHome = (saved != nil)
        //
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
            if shouldOpenHome {
                saved?.setAsCurrent()
                self.startLocationDetection()
            } else {
                self.openSignIn(false)
            }
        }

    }
    func startMainApp() {
        if UserDefaults.standard.object(forKey: "guide") != nil
        {
            if let user = self.selectedUser,let product = self.selectedProduct,let type = self.selectedType
            {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotificationsViewController") as! NotificationsViewController
                vc.selectedProduct = product
                vc.selectedUser = user
                vc.selectedType = type
                let nav = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "home") as! UINavigationController
                nav.setViewControllers([vc], animated: true)
                nav.modalTransitionStyle = .crossDissolve
                self.present(nav, animated: true, completion: nil)
                self.selectedUser = nil
                self.selectedType = nil
                self.selectedProduct = nil

            }else if let msge =  self.message , let dta = self.userData
            {
                let nav = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "home") as! SlideNavigationController
                nav.modalTransitionStyle = .crossDissolve
                self.present(nav, animated: true, completion: nil)
                let delegate = UIApplication.shared.delegate as! AppDelegate
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    delegate.showMessageNotification(msge, dta, nav)
                    
                }

                self.message = nil
                self.userData = nil
            }else{
                openHomeScene()
            }


        }else{
            UserDefaults.standard.set("guide", forKey: "guide")
            UserDefaults.standard.synchronize()
            openGuideScene()
        }
        
    }
    
    func openSignIn(_ popUp:Bool) {
        
        let nav = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sign") as! UINavigationController
        let vc = nav.viewControllers[0] as! SignInViewController
        vc.shouldDisplayExired = popUp
        nav.modalTransitionStyle = .crossDissolve
        
        self.present(nav, animated: true, completion: nil)
    }
    //MARK:- Force Update
    func checkUpdate()
    {
        //        if isCheckedBefore == true
        //        {
        //            startApp()
        //            return
        //        }
//        VersionConnectionHandler.checkUpdate(completion: { (result) in
//            let dic = result as! [String:Any]
//            let currentVersion = 1
//            let servicesVerion = dic["version"] as! Int
//            if currentVersion < servicesVerion            {
//                let force = dic["force"] as! Bool
//                self.displayUpdatePopUp(force)
//            }else
//            {
//                self.startApp()
//            }
//        }) { (message, _) in
//            self.displayRetryPopUp()
//
//        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.startApp()

        }
    }
//    func start()
//    {
//        //        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
////        self.locationHandler.delegate = self
////        self.locationHandler.createManager()
////        //        }
//        autocompleteClicked()
//    }

    func displayUpdatePopUp(_ force:Bool)
    {
        
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("Update") {
            UIApplication.shared.openURL(URL(string: "https://itunes.apple.com/us/app/benefactor/id1169227922?ls=1&mt=8")!)
        }
        if !force{
            alertView.addButton("Skip") {
                self.startApp()
            }
        }
        alertView.showError("", subTitle: "New Version has arrived")
    }
    func displayRetryPopUp()
    {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("Retry") {
            self.checkUpdate()
        }
        alertView.showError("Error", subTitle: "Check your internet conection")
    }
    //MARK:- Observer
    func addNeededObserver() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(RootViewController.userDidFinishLogin), name: NSNotification.Name(rawValue: NOTIFICATION_USER_LOGIN), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(RootViewController.userDidLogOut), name: NSNotification.Name(rawValue: NOTIFICATION_USER_LOGOUT), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RootViewController.userSessionDidExpired), name: NSNotification.Name(rawValue: NOTIFICATION_USER_EXPIRED), object: nil)
    }
    
    func userDidLogOut() {
        
        self.presentedViewController?.dismiss(animated: true, completion: {
            self.openSignIn(false)
        })
    }
    func userSessionDidExpired() {
        
        self.presentedViewController?.dismiss(animated: true, completion: {
            self.openSignIn(true)
        })
    }
    
    
    func userDidFinishLogin() {
        
        self.presentedViewController?.dismiss(animated: true, completion: {
            
            self.startApp()
        })
    }
    //MARK:- Location
    func locationHandlerSucceed() {
        if let old = locationAlert
        {
            old.hideView()
            locationAlert = nil
        }
        self.startMainApp()

        
    }
    func locationHandlerFailed(msg: String) {
//        let alertView = SCLAlertView(appearance: appearance)
//        alertView.addButton("Current Location") {
//            self.locationHandler.delegate = self
//            self.locationHandler.createManager()
//        }
//        alertView.addButton("Enter Location Manually") {
//            self.autocompleteClicked()
//        }
//
//        alertView.showInfo("Location Needed", subTitle: "Benefactor want to know your location to detect your nearby products")
        if LocationHandler.isThereCashedLocation() {
            locationHandlerSucceed()
            return
        }
        if let old = locationAlert
        {
            old.hideView()
            locationAlert = nil
        }
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("Enter Location Manually") {
            self.autocompleteClicked()
        }

//        alertView.showError("Location Error", subTitle: "App Cannot start without your current location.\nPlease enable Location services")
        alertView.showInfo("Location Needed", subTitle: "Benefactor want to know your location to detect your nearby products")

        locationAlert = alertView

    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension RootViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
//        print("Place name: \(place.name)")
//        print("Place address: \(place.formattedAddress)")
//        print("Place attributions: \(place.attributions)")
        self.locationHandler.manualLocation(place.coordinate)
        
        dismiss(animated: true, completion: nil)
        self.startMainApp()

    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
        self.startLocationDetection()
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
        self.startLocationDetection()

    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}

