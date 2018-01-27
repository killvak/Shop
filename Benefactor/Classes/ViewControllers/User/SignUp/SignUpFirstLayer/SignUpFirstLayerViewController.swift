//
//  SignUpFirstLayerViewController.swift
//  Benefactor
//
//  Created by MacBook Pro on 12/31/16.
//  Copyright © 2016 Old Warriors. All rights reserved.
//

import UIKit
import MisterFusion
import SwiftValidators

enum InputType:Int {
    
    case mail = 1
    case userName = 2
    case password = 3
}

class SignUpFirstLayerViewController: UIViewController,UITextFieldDelegate {
    
    //MARK:- Vars
    var type:InputType = .mail
    weak var socialUser : OAuthUser?
    var singletonUser:RegisterUser!
    weak var sharedUser:RegisterUser!
    
    //UI
    @IBOutlet weak var backLowerSpace: NSLayoutConstraint!
    @IBOutlet weak var inputLabelUpperSpace: NSLayoutConstraint!
    @IBOutlet weak var actionHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomLayout: NSLayoutConstraint!
    @IBOutlet weak var headerProgress: YLProgressBar!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var footerLabel: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    
    //MARK:- Life cycle
    deinit {
        
        deregisterFromKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if  UIDevice.modelFromSize() == .iPhone4{
            actionHeight.constant = 35
            inputLabelUpperSpace.constant = 20
            backLowerSpace.constant = 20
        }
        
        UIApplication.shared.statusBarStyle = .default
        
        //
        createDummyUser()
        registerForKeyboardNotifications()
        adjustOutlets()
        
        if type != .password {
            
            textField.becomeFirstResponder()
        }
        
        loadInitialTextIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if type == .password {
            
            return
        }
        
        if !textField.isFirstResponder {
            
            textField.becomeFirstResponder()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        showErrorIfNeeded()
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Methods
    func createDummyUser() {
        
        if type == .mail {
            
            singletonUser = RegisterUser()
            sharedUser = singletonUser
        }
    }
    
    func validateAndSetData() -> Bool {
        
        switch type {
        case.mail:
            if !Validator.isEmail().apply(textField.text)
            {
                self.view.endEditing(true)
                self.showErrorMsg(MESSAGE_ENTER_VALID_MAIL)
                return false
            }
            sharedUser.user_mail = textField.text!
        case.userName:
            guard let userName = textField.text,!userName.isEmpty else {
                self.view.endEditing(true)
                self.showErrorMsg(MESSAGE_ENTER_USERNAME)
                return false
            }
            sharedUser.user_nickName = textField.text!
        case.password:
            guard let password = textField.text,!password.isEmpty else {
                self.view.endEditing(true)
                self.showErrorMsg(MESSAGE_ENTER_PASSWORD)
                return false
            }
            sharedUser.user_password = textField.text!
        }
        return true
    }
    
    func goToNextStep() {
        
        var vc:SignUpFirstLayerViewController?
        
        switch type {
        case .mail:
            vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpFirstLayerViewController") as? SignUpFirstLayerViewController
            vc?.type = .userName
            vc?.socialUser = socialUser
            vc?.sharedUser = sharedUser
        case .userName:
            vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUpFirstLayerViewController") as? SignUpFirstLayerViewController
            vc?.type = .password
            vc?.sharedUser = sharedUser
            
        default:
            break
        }
        
        if let distenation = vc {
            
            self.navigationController?.pushViewController(distenation, animated: true)
            
        } else {
            
            self.performSegue(withIdentifier: "secondLayer", sender: nil)
        }
    }
    
    func loadInitialTextIfNeeded()
    {
        
        switch type {
        case .password:
            if let pass = self.sharedUser.user_password
            {
                textField.text = pass
                
            }
        case .mail:
            if let mail = self.sharedUser.user_mail
            {
                textField.text = mail
                
            }else if let obj = socialUser
            {
                if let mail = obj.userEmail
                {
                    textField.text = mail
                }
            }
        case .userName:
            if let name = self.sharedUser.user_nickName
            {
                textField.text = name
                
            }else if let obj = socialUser
            {
                if let name = obj.userName
                {
                    textField.text = name
                }
            }
        }
    }
    
    func showErrorIfNeeded() {
        
        if let message = sharedUser.error_message {
        
            self.showErrorMsg(message)
            self.sharedUser.error_message = nil
        }
    }
    
    // MARK: - UI Draming
    func adjustOutlets() {
        
        //BG
        self.view.applyGradient(colours: [UIColor(rgba: "#51509d"), UIColor(rgba: "#2bb2ed")], locations: [0.0, 0.7])
        // progress
        headerProgress.type = YLProgressBarType.flat
        headerProgress.progressTintColors = [UIColor.white]
        
        switch type {
        case .mail:
            headerProgress.progress = 0.33
            footerLabel.isHidden = true
        case .password:
            headerProgress.progress = 1.0
        case .userName:
            headerProgress.progress = 0.66
            footerLabel.isHidden = true
            
        }
        
//        //Fonts
//        backBtn.titleLabel?.customizeFont()
//        mainTitleLabel.customizeBoldFont()
//        inputLabel.customizeFont()
//        textField.customizeFont()
//        nextBtn.titleLabel?.customizeFont()
       
        //Footer
        if type == .password {
            
            let mutable = NSMutableAttributedString(attributedString: footerLabel.attributedText!)
            mutable.beginEditing()
            mutable.enumerateAttribute(NSFontAttributeName, in: NSMakeRange(0, mutable.length), options: NSAttributedString.EnumerationOptions(rawValue: UInt(0)), using: { (value, range, stop) in
                let old:UIFont = value as! UIFont
                
                mutable.addAttribute(NSFontAttributeName, value: UIFont(name: FONT_NAME, size: old.pointSize)!, range: range)
                mutable.addAttribute(NSForegroundColorAttributeName, value: UIColor(rgba: "#282735"), range: range)
            })
            mutable.endEditing()
        }
        //
        adjustKeyboard()
    }
    
    func adjustKeyboard() {
        
        switch type {
        
        case .mail:
            textField.keyboardType = .emailAddress
       
        case .userName:
            textField.keyboardType = .default
            mainTitleLabel.text = "Pick a username"
            inputLabel.text = "Username"
            
        case .password:
            
            textField.isSecureTextEntry = true
            mainTitleLabel.text = "Create a password"
            inputLabel.text = "Password"
            
            self.nextBtn.setTitle("Create", for: .normal)
        }
        
        addLineViewToTextField(textField)
    }
    
    func addLineViewToTextField(_ txtField:UITextField) {
        
        let vvv = UIView()
        vvv.backgroundColor = UIColor.white
        _ = self.view.addLayoutSubview(vvv, andConstraints: [vvv.width |==| txtField.width , vvv.height |==| 2 , vvv.top
            |==| txtField.bottom |+| 10, vvv.right |==| txtField.right])
    }
    
    // MARK: - Keyboard
    func registerForKeyboardNotifications() {
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        var info = notification.userInfo!
        //        let animationDuration: TimeInterval = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        bottomLayout.constant = keyboardSize!.height
    }
    
    func keyboardWillBeHidden(notification: NSNotification){
       
        //Once keyboard disappears, restore original positions
        var info = notification.userInfo!

        let animationDuration: TimeInterval = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        if bottomLayout.constant == 0 {
            
            return
        }
        
        bottomLayout.constant = 0
        
        UIView.animate(withDuration: animationDuration) {
        
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK:  TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
        nextClicked()
        
        return true
    }
    
    // MARK: - Methods

    func handleError(message:String?,object:Any?) {
        
        if let item = object as? InputType {
            
            self.sharedUser.error_message = message
            
            let type:InputType = item
            
            switch type{
            case .mail:
                _ = self.navigationController?.popToViewController((self.navigationController?.viewControllers[1])!, animated: true)
                
            case .userName:
                _ = self.navigationController?.popToViewController((self.navigationController?.viewControllers[2])!, animated: true)
                
            case .password:
                _ = self.navigationController?.popViewController(animated: true)
            }
            
        } else {
            
            self.showErrorMsg(message!)
        }
    }
    func logIn()
    {
        UserConnectionHandler().logIn(name: sharedUser.user_nickName!, password: sharedUser.user_password!, completion: { (result) in
            self.dismissLoading()
            let user = result as! DTOUser
            user.setAsCurrent()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION_USER_LOGIN), object: nil)
            }, failed: { (message,_) in
                
                self.dismissLoading()
                self.showErrorMsg(message!)
        })

    }
    // MARK: - Actions
    @IBAction func backClicked() {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextClicked() {
        
        if validateAndSetData() {
            
            if type == .password {
            
                createButtonAction()
                
            } else {
            
                goToNextStep()
            }
        }
    }
    
    func createButtonAction() {
        
        startLoading()
        
        UserConnectionHandler().register(user: sharedUser, completion: { (result) in
            let user = result as! DTOUser
            user.setAsCurrent()
            self.logIn()
        }) { (message, object) in
        
            self.dismissLoading()
            self.handleError(message: message, object: object)
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "secondLayer" {
        
            let vc = segue.destination as! SignUpSecondLayerViewController
            vc.sharedUser = sharedUser
        }
    }
}
