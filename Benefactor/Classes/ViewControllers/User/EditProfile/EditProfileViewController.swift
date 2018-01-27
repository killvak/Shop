//
//  EditProfileViewController.swift
//  Benefactor
//
//  Created by Ahmed Shawky on 8/18/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit
import SwiftValidators
import MisterFusion
import XLActionController
import SCLAlertView


class EditProfileViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    var dataIsEdited = false
    var updatedImage:UIImage?
    var isSecondLayer = false

    override func viewDidLoad() {
        super.viewDidLoad()
        if self.isSecondLayer {
            let leftButton = UIBarButtonItem(image: UIImage(named:"back"), style: .plain, target: self, action: #selector(EditProfileViewController.cancelClicked))
            leftButton.tintColor = UIColor.white
            self.navigationItem.leftBarButtonItem = leftButton
        }else
        {
            self.adjustMenuBarButton()
        }

        //
        adjustOutlets()
        loadUser()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - Methods
    func loadDataIfExisted()
    {
        let user = DTOUser.currentUser()!
        firstNameTextField.text = user.user_firstName
        lastNameTextField.text = user.user_lastName
        emailTextField.text = user.user_email
        if let image = user.user_image
        {
            imgView.imageProfile(fromString: image)
        }else
        {
            imgView.image = UIImage(named:"defaultImage")
        }
        
    }
    func adjustOutlets()
    {
        imgView.circleView(width: 128)
        let tap = UITapGestureRecognizer(target: self, action: #selector(EditProfileViewController.addImageClicked))
        imgView.isUserInteractionEnabled = true
        imgView.addGestureRecognizer(tap)
        //
        let arr = [firstNameTextField,lastNameTextField,emailTextField]
        let placeHolderColor = UIColor(rgba: "#888888")
        let textColor = UIColor.black
        for txtFld in arr
        {
            txtFld?.customizeFont()
            txtFld?.customizePlaceHolder(placeHolderColor)
            txtFld?.textColor = textColor
            txtFld?.delegate = self
            self.addLineViewToTextField(txtFld!)
        }
    }
    func addLineViewToTextField(_ textField:UITextField)
    {
        let vvv = UIView()
        vvv.backgroundColor = UIColor(rgba: "#dfdfdf")
        _ = self.view.addLayoutSubview(vvv, andConstraints: [vvv.width |==| textField.width , vvv.height |==| 1 , vvv.top
            |==| textField.bottom  |+| 2, vvv.right |==| textField.right])
    }
    func didEdited(){
        dataIsEdited = true
    }
    func close()
    {
        let count = self.navigationController!.viewControllers.count
        if count == 1
        {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController")
            self.navigationController?.setViewControllers([vc], animated: true)
        }else
        {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: - Services
    private func loadUser()
    {
        self.startLoading()
        let userID:Int = (DTOUser.currentUser()?.user_id)!
        
        UserConnectionHandler().getUser(userID, completion: { (result) in
            self.dismissLoading()
            self.loadDataIfExisted()
        }) { (message, _) in
            self.endLoadingError(message!)
            self.showErrorMsg(message!)
        }
    }
    
    func sendData(first:String,last:String,mail:String)
    {
        self.startLoading()
        UserConnectionHandler().editUser(first: first, last: last, mail: mail, completion: { (result) in
            self.dataIsEdited = false
            self.uploadImageIfNeeded()
        }) { (msg3, _) in
            if let message = msg3
            {
                self.showErrorMsg(message)
            }
            self.endLoadingError(nil)
        }
    }
    func uploadImageIfNeeded()
    {
        guard  let image = updatedImage else {
            self.dismissLoading()
            self.cancelClicked()
            return
        }
        self.dismissLoading()
        self.startLoading("Uploading Image")
        UserConnectionHandler().editProfilePic(image, completion: { (_) in
            self.dismissLoading()
            self.close()
            
        }) { (msg3, _) in
            if let message = msg3
            {
                self.showErrorMsg(message)
            }
            self.endLoadingError(nil)
        }
    }
    //MARK: - Actions
    @IBAction func changePasswordClicked() {
        let appearance = SCLAlertView.SCLAppearance(
            kWindowWidth:SCREEN_WIDTH - 100,
            kWindowHeight:SCREEN_HEIGHT/2.5,
            showCloseButton: false
        )
        let alert = SCLAlertView(appearance: appearance)
        
        let txt0 = alert.addTextField()
        txt0.placeholder = "Old Password"
        txt0.textAlignment = .left
        txt0.isSecureTextEntry = true
        let txt1 = alert.addTextField()
        txt1.placeholder = "New Password"
        txt1.textAlignment = .left
        txt1.isSecureTextEntry = true
        let txt2 = alert.addTextField()
        txt2.placeholder = "Confirm Password"
        txt2.textAlignment = .left
        txt2.isSecureTextEntry = true

        alert.addButton("OK") {
            guard let pass0 = txt0.text , pass0 != "" else
            {
                self.showErrorMsg(MESSAGE_ENTER_OLD_PASSWORD)
                return
            }

            guard let pass1 = txt1.text , pass1 != "" else
            {
                self.showErrorMsg(MESSAGE_ENTER_NEW_PASSWORD)
                return
            }
            guard let pass2 = txt2.text , pass2 != "" else
            {
                self.showErrorMsg(MESSAGE_ENTER_CONFIRM_PASSWORD)
                return
            }
            if pass1 != pass2
            {
                self.showErrorMsg(MESSAGE_PASSWORD_NOT_MATCH)
                return
            }
            self.startLoading()
            UserConnectionHandler().changePassword(old: pass0, new: pass1, completion: { (_) in
                self.dismissLoading()
            }) { (msg3, _) in
                if let message = msg3
                {
                    self.showErrorMsg(message)
                }
                self.endLoadingError(nil)
            }
        }
        alert.addButton("Cancel") {}
        alert.showInfo("New Password", subTitle: "")
        
        
    }
    func addImageClicked()
    {
        let actionController = CustomActionSheetActionController()
        actionController.addAction(Action("Camera", style: .default, handler: { action in
            self.cameraSelection()
        }))
        actionController.addAction(Action("Gallery", style: .default, handler: { action in
            self.gallerySelection()
        }))
        present(actionController, animated: true, completion: nil)
    }
    
    @IBAction func acceptClicked()
    {
        guard let first = firstNameTextField.text , first != "" else {
            self.showErrorMsg(MESSAGE_ENTER_FIRST)
            return
        }
        guard let last = lastNameTextField.text , last  != ""  else {
            self.showErrorMsg(MESSAGE_ENTER_LAST)
            return
        }
        guard let mail = emailTextField.text , mail != "" else {
            self.showErrorMsg(MESSAGE_ENTER_VALID_MAIL)
            return
        }
        if !Validator.isEmail().apply(mail)
        {
            self.view.endEditing(true)
            self.showErrorMsg(MESSAGE_ENTER_VALID_MAIL)
            return
        }
        
        sendData(first:first,last:last,mail:mail)
    }
    
    @IBAction func cancelClicked()
    {
        if self.dataIsEdited
        {
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let alert = SCLAlertView(appearance: appearance)
            
            alert.addButton("Lose it") {
                self.close()
            }
            alert.addButton("Cancel") {}
            alert.showError("You will lose the entered Data", subTitle: "")
        }else
        {
            self.close()
        }
        
    }
    //MARK: - TextField
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        didEdited()
        return true
    }
    //MARK:- Image Selection
    func cameraSelection()
    {
        let cameraController = UIImagePickerController()
        cameraController.sourceType = .camera
        cameraController.allowsEditing = false
        cameraController.delegate = self
        self.present(cameraController, animated: false, completion: nil)
    }
    func gallerySelection()
    {
        let cameraController = UIImagePickerController()
        cameraController.sourceType = .photoLibrary
        cameraController.allowsEditing = false
        cameraController.delegate = self
        self.present(cameraController, animated: false, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        updatedImage = image
        imgView.image = image
        picker.dismiss(animated: true, completion: nil)
        didEdited()
        
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
