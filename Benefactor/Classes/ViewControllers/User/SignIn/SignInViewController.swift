//
//  SignInViewController.swift
//  Benefactor
//
//  Created by MacBook Pro on 12/31/16.
//  Copyright © 2016 Old Warriors. All rights reserved.
//

import UIKit
import MisterFusion
import SwiftyJSON
import GoogleSignIn
import SCLAlertView
import TwitterKit


class SignInViewController: UIViewController,OAuthIntegrationDelegate,GIDSignInUIDelegate,UITextFieldDelegate,CMSwitchViewDelegate,SocialHandlerDelegate {
    //MARK:- Vars
    
    //MARK:UI
    @IBOutlet weak var footerView: UIView!
    
    //
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    
    //
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    //
    @IBOutlet weak var rememberMeLabel: UILabel!
    @IBOutlet weak var footerTitleLabel: UILabel!
    weak var rememberSwitch:CMSwitchView!
    //
    @IBOutlet weak var buttomViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var userInputUpperSpace: NSLayoutConstraint!
    @IBOutlet weak var userInputLowerSpace: NSLayoutConstraint!
//    @IBOutlet weak var remeberMeCenterLayout: NSLayoutConstraint!
//    @IBOutlet var remeberMeTopLayout: NSLayoutConstraint!
    @IBOutlet weak var logoAspectLayout: NSLayoutConstraint!

    //MARK:Data
    var socialHandler:OAuthIntegration?
    var socialUser : OAuthUser?
    var isRememberMeEnabled = true
    var shouldDisplayExired = false
    //MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addRememberSwitch()
        adjustOutlets()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if shouldDisplayExired {
            shouldDisplayExired = false
            SCLAlertView().showInfo("Session Expired", subTitle: "Please login again")
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- Drawing UI
    func adjustOutlets()
    {
        //BG
        self.view.applyGradient(colours: [UIColor(rgba: "#51509d"), UIColor(rgba: "#2bb2ed")], locations: [0.0, 0.7])
      
        //Place Holder
        let placeHolderColor = nameTextField.textColor!
        nameTextField.customizePlaceHolder(placeHolderColor)
        passwordTextField.customizePlaceHolder(placeHolderColor)
        // corner+border
        let radius:CGFloat = (UIDevice.modelFromSize() == .iPad) ? 25 : 20
        loginButton.addCorneredBorder(color:UIColor.clear,radius:radius)
        facebookButton.addCorneredBorder(color: UIColor(rgba:"#2bb2ed"),radius:radius)
        twitterButton.addCorneredBorder(color: UIColor(rgba:"#2bb2ed"),radius:radius)
        googleButton.addCorneredBorder(color: UIColor(rgba:"#2bb2ed"),radius:radius)
    }
    
    func addRememberSwitch() {
        
        switch UIDevice.modelFromSize() {
        
        case .iPhone4:
           
            userInputUpperSpace.constant = 0
            userInputLowerSpace.constant = 0
//            remeberMeTopLayout.constant = 8
            buttomViewHeightConstraint.constant = 100
            logoAspectLayout.constant = 52
            
        case .iPhone5:
        
//            remeberMeTopLayout.constant = 20
            buttomViewHeightConstraint.constant = 116
            
        case .iPad:
            
//            remeberMeTopLayout.constant = 20
            buttomViewHeightConstraint.constant = 146

        default:
            break
        }
        
        let switchVw = CMSwitchView(frame: CGRect(x: 0, y: 0, width: 50, height: 17))
        switchVw.dotColor = UIColor.white
        switchVw.color = UIColor.clear
        switchVw.tintColor = UIColor(rgba:"#51509d")
        switchVw.dotWeight = 14
        switchVw.borderColor = UIColor.white
        switchVw.setSelected(isRememberMeEnabled, animated: false)
        switchVw.delegate = self
//        remeberMeCenterLayout.constant = -(switchVw.frame.size.width/2)
//        _ = self.view.addLayoutSubview(switchVw, andConstraints: [switchVw.leading |==| rememberMeLabel.trailing |+| 8,
//                                                                  switchVw.centerY |==| rememberMeLabel.centerY,
//                                                                  switchVw.width |==| switchVw.frame.size.width,
//                                                                  switchVw.height |==| switchVw.frame.size.height])
//        rememberSwitch = switchVw
    }
    //MARK:- Actions
    func switchValueChanged(_ sender: Any!, andNewValue value: Bool) {
        isRememberMeEnabled = value
    }
    @IBAction func facebookClicked(_ sender: AnyObject) {
      
        socialUser = nil
        
        let social = OAuthIntegration()
        social.delegate = self
        social.requestFacebook(ownerVC: self)
        socialHandler = social
        
        startLoading()
    }
    
    @IBAction func twitterClicked(_ sender: AnyObject) {
    
        socialUser = nil
        
        let social = OAuthIntegration()
        social.delegate = self
        social.requestTwitter(ownerVC: self)
        socialHandler = social
        
        startLoading()
    }
    func requestTwitter()
    {
        Twitter.sharedInstance().logIn { session, error in
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
                                self.integrationDidLoad(data: result, type: .twitter)
                                
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
                        self.integrationDidFail(msg: (error?.localizedDescription)!, type: .twitter)
                        
                    }
                    
                })
            } else {
                //                print("\(error?.localizedDescription)")
                //                print("\((error as! NSError).code)")
                //                self.delegate?.integrationDidFail(msg: (error?.localizedDescription)!, type: .twitter)
                self.integrationDidCancelled(.twitter)
                
            }
        }
        
    }

    
    @IBAction func googleClicked(_ sender: AnyObject) {
    
        socialUser = nil
        
        let social = OAuthIntegration()
        social.delegate = self
        social.requestGoogle(googleUIDelegate: self)
        socialHandler = social
        
        startLoading()
    }
    
    @IBAction func loginClicked(_ sender: AnyObject) {
    
        self.view.endEditing(true)
        
        if isValidInputs() {
        
            startLoading()
            
            UserConnectionHandler().logIn(name: nameTextField.text!, password: passwordTextField.text!, completion: { (result) in
                self.dismissLoading()
                let user = result as! DTOUser
                user.setAsCurrent()
                if self.isRememberMeEnabled == true
                {
                    user.saveUser()
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_USER_LOGIN), object: nil)
                NotificationsConnectonHandler().addDevice()
                NotificationsConnectonHandler.getUnreadCount()
            }, failed: { (message,_) in
                 
                    self.dismissLoading()
                    self.showErrorMsg(message!)
            })
        }
    }
    
    //MARK:- Validation
    func isValidInputs() -> Bool {
        
        guard let userName = nameTextField.text,!userName.isEmpty else {
        
            self.showErrorMsg(MESSAGE_ENTER_USERNAME)
            return false
        }
        
        guard let password = nameTextField.text,!password.isEmpty else {
        
            self.showErrorMsg(MESSAGE_ENTER_PASSWORD)
            return false
        }
        
        return true
    }

    //MARK:- Social Delegate
    func linkingDidSucceed(result: DTOUser) {
        dismissLoading()
        let user = result
        user.setAsCurrent()
        if self.isRememberMeEnabled == true
        {
            user.saveUser()
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_USER_LOGIN), object: nil)
        NotificationsConnectonHandler().addDevice()
        NotificationsConnectonHandler.getUnreadCount()

    }
    func linkingDidFail(msg: String) {
        self.showErrorMsg(msg)
        dismissLoading()

    }
    func integrationDidFail(msg: String, type: SocialNetwork) {
        
        self.showErrorMsg(msg)
        dismissLoading()
    }
    
    func integrationDidLoad(data: OAuthUser!, type: SocialNetwork) {
        let handler = SocialHandler()
        handler.user = data
        handler.delegate = self
        handler.login1()
//        socialUser = data
//        socialUser?.saveUser()
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_USER_LOGIN), object: nil)
    }
    
    func integrationDidCancelled(_ type: SocialNetwork) {
        dismissLoading()
//        self.showErrorMsg("Cancelled")        
    }
    
    //MARK:- Google UIDelegate
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        self.dismissLoading()
    }
    
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
        
    }
    // MARK: - Text Field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField
        {
            passwordTextField.becomeFirstResponder()
        }else
        {
            self.loginClicked(loginButton)
        }
        return true
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "register"
        {
            guard let vc = segue.destination as? SignUpFirstLayerViewController else {
                return
            }
            vc.socialUser = socialUser
        }
    }
    
    
}
