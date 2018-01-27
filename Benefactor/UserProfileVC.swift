//
//  UserProfileVC.swift
//  Benefactor
//
//  Created by Killva on 1/25/18.
//  Copyright © 2018 Old Warriors. All rights reserved.
//

import UIKit
import IQDropDownTextField
import IQKeyboardManagerSwift
import SwiftValidators
import MisterFusion
import XLActionController
import SCLAlertView
import SwiftyStarRatingView

class UserProfileVC: UIViewController , UITextFieldDelegate ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var memberSinceLbl: UILabel!
    //MARK: Payment Methods
    @IBOutlet weak var cashBtn: UIButton!
    @IBOutlet weak var paypalBtn: UIButton!
    @IBOutlet weak var creditCardBtn: UIButton!
    //
    @IBOutlet weak var followBtn: UIButtonX!
    @IBOutlet weak var paypalEmailAccountTxt: UITextField!
    @IBOutlet weak var canDeliverFromTTxt: UITextField!
    @IBOutlet weak var canDeliverToTxt: UITextField!
    @IBOutlet weak var purchesCollectionV: UICollectionView!
    @IBOutlet weak var sellingCollectionV: UICollectionView!
    @IBOutlet weak var ratingView: SwiftyStarRatingView!
    
    @IBOutlet weak var currencyTypeTxt: IQDropDownTextField!
    
    var dataIsEdited = false
    var updatedImage:UIImage?
 let user = DTOUser.currentUser()!
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUser()
        title = "User Profile"
         self.addBarButtons()
        currencyTypeTxt.isOptionalDropDown = false
        currencyTypeTxt.itemList = ["(US Dollar)", "(Candian Dollar)"]
        // Do any additional setup after loading the view.
        paypalEmailAccountTxt.customizePlaceHolder(.white)
        canDeliverFromTTxt.customizePlaceHolder(.white)
        canDeliverToTxt.customizePlaceHolder(.white)
        
        sellingCollectionV.delegate = self
        sellingCollectionV.dataSource = self
        purchesCollectionV.delegate = self
        purchesCollectionV.dataSource = self
        if   let user = DTOUser.currentUser() {

        if let image = user.user_image
        {
            profileImg.imageProfile(fromString: image)
        }else
        {
            profileImg.image = UIImage(named:"defaultImage")
        }
     }
        
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(EditProfileViewController.addImageClicked))
        profileImg.isUserInteractionEnabled = true
        profileImg.addGestureRecognizer(tap)
    }
    
    func addBarButtons() {
        self.adjustMenuBarButton()
        let rightButton1 = self.searchBarButton()
         self.navigationItem.rightBarButtonItems = [rightButton1]
    }
    
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
    func loadDataIfExisted()
    {
        
        titleLbl.text = user.user_firstName
//        lastNameTextField.text = user.user_lastName
        emailLbl.text = user.user_email
        if let image = user.user_image
        {
            profileImg.imageProfile(fromString: image)
        }else
        {
            profileImg.image = UIImage(named:"defaultImage")
        }
        
    }
    func paymentMethod() {
//
//        if (DistanceHandler.sharedManager.isMile()) {
//            milesBtn.setImage(#imageLiteral(resourceName: "radio_on"), for: .normal)
//        }else {
//            kmBtn.setImage(#imageLiteral(resourceName: "radio_on"), for: .normal)
//
//        }
    }
    @IBAction func paymentMethodshandler(_ sender : UIButton) {
        
        switch sender.tag {
            
        case 0 :
            cashBtn.setImage(#imageLiteral(resourceName: "radio_on"), for: .normal)
            paypalBtn.setImage(#imageLiteral(resourceName: "radio_off"), for: .normal)
            creditCardBtn.setImage(#imageLiteral(resourceName: "radio_off"), for: .normal)
        case 1 :
            paypalBtn.setImage(#imageLiteral(resourceName: "radio_on"), for: .normal)
            cashBtn.setImage(#imageLiteral(resourceName: "radio_off"), for: .normal)
            creditCardBtn.setImage(#imageLiteral(resourceName: "radio_off"), for: .normal)
        case 2 :
            creditCardBtn.setImage(#imageLiteral(resourceName: "radio_on"), for: .normal)
            paypalBtn.setImage(#imageLiteral(resourceName: "radio_off"), for: .normal)
            cashBtn.setImage(#imageLiteral(resourceName: "radio_off"), for: .normal)
        default : break
        }
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


extension UserProfileVC {
    
    
 
    
    @IBAction func followUser(_ sender: AnyObject) {
        if user.user_isFollowed == true {
            doUnfollow()
        }else
        {
            doFollow()
        }
    }
    func doFollow()
    {
        self.startLoading()
        OtherUserConnectionHandler().followUser(userID: user.user_id, completion: { (_) in
            self.dismissLoading()
            self.user.user_isFollowed = true
            self.followBtn?.setTitle("Unfollow", for: .normal)
        }) { (message, _) in
            self.endLoadingError(message!)
            self.showErrorMsg(message!)
        }
    }
    func doUnfollow()
    {
        self.startLoading()
        OtherUserConnectionHandler().unfollowUser(userID: user.user_id, completion: { (_) in
            self.dismissLoading()
            self.user.user_isFollowed = false
            self.followBtn?.setTitle("Follow", for: .normal)
        }) { (message, _) in
            self.endLoadingError(message!)
            self.showErrorMsg(message!)
        }
    }
    
    func confirmReport(reason:String)
    {
        self.startLoading()
        OtherUserConnectionHandler().reportUser(userID: user.user_id, reason: reason, completion: { (_) in
            self.dismissLoading()
        }) { (message, _) in
            self.endLoadingError(message!)
            self.showErrorMsg(message!)
        }
        
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
        profileImg.image = image
        picker.dismiss(animated: true, completion: nil)
        didEdited()
        
    }
    func didEdited(){
        dataIsEdited = true
    }
    
}
extension UserProfileVC : UICollectionViewDelegate , UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard  collectionView == sellingCollectionV else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserProfileCell1", for: indexPath) as! UserProfileCell
             if let image = user.user_image
            {
                cell.imageView.imageProfile(fromString: image)
            }else
            {
                  cell.imageView.image = UIImage(named:"defaultImage")
            }
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserProfileCell2", for: indexPath) as! UserProfileCell
        if let image = user.user_image
        {
            cell.imageView.imageProfile(fromString: image)
        }else
        {
            cell.imageView.image = UIImage(named:"defaultImage")
        }
        
        return cell
    }
    
    
}
