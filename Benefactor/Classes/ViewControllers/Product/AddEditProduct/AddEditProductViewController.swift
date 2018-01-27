//
//  AddEditProductViewController.swift
//  Benefactor
//
//  Created by MacBook Pro on 2/15/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit
import XLActionController
import IQDropDownTextField
import IQKeyboardManagerSwift
import SwiftValidators
import MisterFusion
import SCLAlertView

class AddEditProductViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {
    //MARK:- UI
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var counterHeightLayout: NSLayoutConstraint!
//    @IBOutlet weak var initialLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var categoryTextField: IQDropDownTextField!
//    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var imagesLabel: UILabel!
    @IBOutlet weak var addImage1: AddImageHolderView!
    @IBOutlet weak var addImage2: AddImageHolderView!
    @IBOutlet weak var addImage3: AddImageHolderView!
    @IBOutlet weak var addImage4: AddImageHolderView!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    //MARK:- data
    var preSelectedCategryIndex:Int?
    var itemToEdit:DTOProduct?
    var arrayOfImages = [Any]()
    var arrayOfCategories:[DTOCategory]?
    var uploadProductID :Int!
    var uploadImagesArr :[UIImage]!
    var uploadImageCounter = 0
    var deleteImagesArr :[DTOImage]?
    var deleteImageCounter = 0
    var dataIsEdited = false
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if UIDevice.modelFromSize() == .iPhone4 {
            counterHeightLayout.constant = 480
        }
        self.adjustOutlets()
        let leftButton = UIBarButtonItem(image: UIImage(named:"back"), style: .plain, target: self, action: #selector(AddEditProductViewController.customBackAction))
        leftButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = leftButton
        //
        categoryTextField.placeholderText = categoryTextField.placeholder
        categoryTextField.optionalItemText = "Select Category"
        //
        self.addLineViewToTextField(titleTextField)
        self.addLineViewToTextField(descriptionTextView)
        self.addLineViewToTextField(categoryTextField)
        //
        loadUI()
        //
        reloadImages()
        //
        hideSubviews()
        
      
    }
    
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        let arr = [ addImage1,addImage2,addImage3,addImage4]
//        
//        
//        for x in arr {
//            x!.circleView()
//        }
//        
//    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        if arrayOfCategories == nil
        {
            loadCategories()
        }
    }
    deinit {
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
    }
    //MARK:- Actions
    @IBAction func cancelClicked() {
        self.customBackAction()
    }
    @IBAction func acceptClicked() {
        //
        if categoryTextField.selectedRow == -1
        {
            self.showErrorMsg(MESSAGE_ENTER_CATEGORY)
            return
        }
        //
        if titleTextField.text?.isEmpty == true
        {
            self.showErrorMsg(MESSAGE_ENTER_TITILE)
            return
        }
        if (titleTextField.text?.characters.count)! > 70
        {
            self.showErrorMsg(MESSAGE_VALID_TITILE)
            return
        }
        //
//        if descriptionTextView.text?.isEmpty == true
//        {
//            self.showErrorMsg(MESSAGE_ENTER_DESCRIPTION)
//            return
//        }
        //
        if arrayOfImages.count == 0{
            self.showErrorMsg(MESSAGE_ENTER_IMAGE)
            return
        }
        //
        sendDataToServer()
    }
    //MARK:- Methods
    func adjustOutlets()
    {
//        initialLabel.customizeBoldFont()
        imagesLabel.customizeBoldFont()
        let placeHolderColor = UIColor(rgba: "#888888")
        titleTextField.customizePlaceHolder(placeHolderColor)
        categoryTextField.customizePlaceHolder(placeHolderColor)
        descriptionTextView.customizePlaceHolder(placeHolderColor)
        titleTextField.customizeFont()
        categoryTextField.customizeFont()
        descriptionTextView.customizeFont()
        acceptButton.titleLabel?.customizeFont()
        cancelButton.titleLabel?.customizeFont()
        //
        categoryTextField.createRightArrow()
    }
    func loadUI()
    {
        if let item  = itemToEdit
        {
            self.title = "Edit Item"
            titleTextField.text = item.product_name
            descriptionTextView.text = item.product_description
            if let arr = item.product_images
            {
                for img in arr
                {
                    arrayOfImages.append(img)
                }
            }
        }else
        {
            self.title = "Add Item"
            
        }
    }
    func addLineViewToTextField(_ textField:UIView)
    {
        //textView padding differ from textField
        if let txtView = textField as? UITextView {
            let vvv = UIView()
            vvv.backgroundColor = UIColor(rgba: "#dfdfdf")
            _ = txtView.superview!.addLayoutSubview(vvv, andConstraints: [vvv.width |==| txtView.width |-| 8 , vvv.height |==| 1 , vvv.top
                |==| txtView.bottom  |+| 2, vvv.right |==| txtView.right |-| 4 ])

        }else
        {
            let vvv = UIView()
            vvv.backgroundColor = UIColor(rgba: "#dfdfdf")
            _ = textField.superview!.addLayoutSubview(vvv, andConstraints: [vvv.width |==| textField.width , vvv.height |==| 1 , vvv.top
                |==| textField.bottom  |+| 2, vvv.right |==| textField.right])

        }
    }
    
    func sendDataToServer()
    {
        startLoading()
        if let item = itemToEdit
        {
            item.product_categoryID = arrayOfCategories![categoryTextField.selectedRow].category_ID?.intValue
            item.product_name = titleTextField.text!
            item.product_description = descriptionTextView.text
            ProductConnectionHandler().editProduct(product: item, completion: { (result) in
                self.dismissLoading()
                self.uploadProductID = item.product_id
                self.processDeletingImages()
                }, failed: { (msg3, _) in
                    if let message = msg3
                    {
                        self.showErrorMsg(message)
                    }
                    self.endLoadingError(nil)
            })
        }else
        {
            let item = DTOProduct()
            item.product_categoryID = arrayOfCategories![categoryTextField.selectedRow].category_ID?.intValue
            item.product_name = titleTextField.text!
            item.product_description = descriptionTextView.text
            ProductConnectionHandler().addProduct(product: item, completion: { (result) in
                self.dismissLoading()
                self.uploadProductID = result as! Int
                self.processDeletingImages()
                }, failed: { (msg3, _) in
                    if let message = msg3
                    {
                        self.showErrorMsg(message)
                    }
                    self.endLoadingError(nil)
            })
            
        }
        
    }
    func processDeletingImages()
    {
        guard deleteImagesArr != nil else {
            processUploadingImages()
            return
        }
        deleteImage()
        
    }
    func deleteImage()
    {
        if deleteImagesArr!.count == deleteImageCounter{
            processUploadingImages()
            return
        }
        deleteImageCounter = deleteImageCounter + 1
        //
        let message = "Deleting Image \(deleteImageCounter)"
        self.startLoading(message)
        ProductConnectionHandler().deleteProductImage(productID: self.itemToEdit!.product_id,imageURLString: deleteImagesArr![deleteImageCounter-1].image_urlString, completion: { (result) in
            self.endLoadingSuccess("Deleted")
            self.deleteImage()
        }) { (msg3, _) in
            if let message = msg3
            {
                self.showErrorMsg(message)
            }
            self.endLoadingError(nil)
        }
        
    }
    func processUploadingImages()
    {
        
        uploadImagesArr = [UIImage]()
        for item in arrayOfImages
        {
            if let img = item as? UIImage
            {
                uploadImagesArr.append(img)
            }
        }
        uploadImage()
    }
    func uploadImage()
    {
        if uploadImagesArr.count == uploadImageCounter{
            self.dismissLoading()
            self.backButtonClicked()
            return
        }
        uploadImageCounter = uploadImageCounter + 1
        //
        let message = "Uploading Image \(uploadImageCounter)"
        self.startLoading(message)
        ProductConnectionHandler().addProductImage(productID: uploadProductID, image: uploadImagesArr[uploadImageCounter-1], completion: { (result) in
            self.endLoadingSuccess("Uploaded")
            self.uploadImage()
        }) { (msg3, _) in
            if let message = msg3
            {
                self.showErrorMsg(message)
            }
            self.endLoadingError(nil)
        }
        
    }
    func loadCategories()  {
//        startLoading()
        CategoryConnectionHandler.sharedInstance.requestCategories(completion: { (result) in
            self.dismissLoading()
            self.arrayOfCategories = result as? [DTOCategory]
            self.categoryTextField.itemList = self.arrayOfCategories!.map { $0.category_name! }
            if let item = self.itemToEdit
            {
                self.categoryTextField.isOptionalDropDown = false
                let index = self.arrayOfCategories!.index{$0.category_ID?.intValue == (item.product_categoryID)!}!
                self.categoryTextField.selectedRow = index
                
            }else if let index = self.preSelectedCategryIndex
            {
                self.categoryTextField.isOptionalDropDown = false
                self.categoryTextField.selectedRow = index
            }
            self.showSubviews()
            }, failure: { (msg3, _) in
                if let message = msg3
                {
                    self.showErrorMsg(message)
                }
                self.endLoadingError(nil)
        })
    }
    func reloadImages()
    {
        let arr = [ addImage1,addImage2,addImage3,addImage4]
        var counter = 0
        for item in arrayOfImages
        {
            if let img = item as? UIImage
            {
                arr[counter]?.loadImage(image: img, target: self, action: #selector(AddEditProductViewController.deleteImageClicked(btn:)),tag:counter)
            }else if let img = item as? DTOImage
            {
                arr[counter]?.loadImage(urlString: img.image_urlString, target: self, action: #selector(AddEditProductViewController.deleteImageClicked(btn:)),tag:counter)
            }
            arr[counter]?.isHidden = false
            counter = counter + 1
        }
        if counter == 4 {
            return
        }else if  counter < 4 {
            
            arr[counter]?.initialState(target: self, action: #selector(AddEditProductViewController.addImageClicked))
            arr[counter]?.isHidden = false
            counter = counter + 1
        }
        while  counter < 4 {
            arr[counter]?.isHidden = true
            counter = counter + 1
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
    func deleteImageClicked(btn:UIButton)
    {
        if let img = arrayOfImages[btn.tag] as? DTOImage
        {
            if deleteImagesArr == nil
            {
                deleteImagesArr = [DTOImage]()
            }
            deleteImagesArr!.append(img)
            didEdited()
        }
        arrayOfImages.remove(at: btn.tag)
        reloadImages()
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
        arrayOfImages.append(image)
        self.reloadImages()
        picker.dismiss(animated: true, completion: nil)
        didEdited()

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == categoryTextField
        {
            titleTextField.becomeFirstResponder()
        }else if textField == titleTextField
        {
            descriptionTextView.becomeFirstResponder()
        }else
        {
            textField.resignFirstResponder()
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == categoryTextField {
            if let item = self.itemToEdit  {
                let id = arrayOfCategories![categoryTextField.selectedRow].category_ID?.intValue
                if item.product_categoryID != id
                {
                    didEdited()
                }
            }else
            {
                if let index = preSelectedCategryIndex
                {
                    if index !=  categoryTextField.selectedRow{
                        didEdited()
                    }
                }else if categoryTextField.selectedRow != -1
                {
                    didEdited()
                }
            }
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        didEdited()
        if textField == titleTextField {
            guard let text = textField.text else { return true }
            let newLength = text.characters.count + string.characters.count - range.length
            return newLength <= 70 // Bool
        }
        return true
    }
    //MARK: - isEdited
    func didEdited(){
            dataIsEdited = true
    }
    func customBackAction()
    {
        if self.dataIsEdited
        {
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let alert = SCLAlertView(appearance: appearance)
            
            alert.addButton("Lose it") {
                self.backButtonClicked()
            }
            alert.addButton("Cancel") {}
            alert.showError("You will lose the entered Data", subTitle: "")
        }else
        {
            self.backButtonClicked()
        }
    }
}
//MARK:- Show/Hide
extension AddEditProductViewController
{
    func hideSubviews()
    {
        for v in scrollView.subviews
        {
            v.alpha = 0
        }
        self.view.isUserInteractionEnabled = false;

    }
    func showSubviews()
    {
        UIView.animate(withDuration: 1.5, animations: { 
            for v in self.scrollView.subviews
            {
                v.alpha = 1
            }
            }) { (_) in
                self.view.isUserInteractionEnabled = true;
        }
    }
}
