//
//  CompleteProfileViewController.swift
//  Benefactor
//
//  Created by MacBook Pro on 3/3/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit
import MisterFusion
import IQDropDownTextField
import IQKeyboardManagerSwift

class CompleteProfileViewController: UIViewController,UITextFieldDelegate {
    //MARK: - UI
    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var regionTextField: UITextField!
    @IBOutlet weak var cityTextField: IQDropDownTextField!
    @IBOutlet weak var countryTextField: IQDropDownTextField!
    @IBOutlet weak var countryLabel: UILabel!
    //MARK: - Data
    var arrayOfCountres:[DTOCountry]!
    var arrayOfCities:[DTOCity]?
    var isSecondLayer = false
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "complete profile"
        if self.isSecondLayer {
            self.adjustBackButton()
        }else
        {
            self.adjustMenuBarButton()
        }
        adjustOutlets()
        loadUser()
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        loadDataIfExisted()
    }
    deinit {
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - Services
    private func loadUser()
    {
        self.startLoading()
        let userID:Int = (DTOUser.currentUser()?.user_id)!
        
        UserConnectionHandler().getUser(userID, completion: { (result) in
            self.loadDataIfExisted()
            self.loadCountries()
        }) { (message, _) in
            self.endLoadingError(message!)
            self.showErrorMsg(message!)
        }
    }
    
    func loadCountries()
    {
        self.startLoading()
        CompleteProfileConnectionHandler().requestCountries(completion: { (result) in
            self.arrayOfCountres = result as! [DTOCountry]
            self.countryTextField.itemList = self.arrayOfCountres!.map { $0.country_name }
            //
            let user = DTOUser.currentUser()!
//            if let countryID = user.user_countryID
//            {
//                self.countryTextField.isOptionalDropDown = false
//                let index = self.arrayOfCountres!.index{$0.country_ID == (countryID)}!
//                
//                self.countryTextField.selectedRow = index
//                self.loadCiteis()
//                
//            }else
//            {
                self.dismissLoading()
//            }
            
        }) { (msg3, _) in
            if let message = msg3
            {
                self.showErrorMsg(message)
            }
            self.endLoadingError(nil)
        }
    }
    func loadCiteis()
    {
        self.cityTextField.isOptionalDropDown = true
        self.cityTextField.itemList = [String]()
        self.cityTextField.selectedRow = -1
        
        if countryTextField.selectedRow == -1
        {
            return
        }
        let selectedCountry = arrayOfCountres[countryTextField.selectedRow]
        self.startLoading()
        CompleteProfileConnectionHandler().requestCities(countryID: selectedCountry.country_ID, completion: { (result) in
            self.dismissLoading()
            self.arrayOfCities = result as? [DTOCity]
            self.cityTextField.itemList = self.arrayOfCities!.map { $0.city_name }
            //
//            let user = DTOUser.currentUser()!
//            var selectedIndex = 0
//            if let cityID = user.user_cityID
//            {
//                self.cityTextField.isOptionalDropDown = false
//                
//                if let index = self.arrayOfCities!.index(where: {$0.city_ID == (cityID)})
//                {
//                    selectedIndex = index
//                }
//                self.cityTextField.selectedRow = selectedIndex
//                self.dismissLoading()
//            }
        }) { (msg3, _) in
            if let message = msg3
            {
                self.showErrorMsg(message)
            }
            self.endLoadingError(nil)
        }
        
    }
    func sendData()
    {
        let selectedCity = arrayOfCities![cityTextField.selectedRow]
        let selectedCountry = arrayOfCountres[countryTextField.selectedRow]
        self.startLoading()
        CompleteProfileConnectionHandler().completeProfile(countryID: selectedCountry.country_ID, cityID: selectedCity.city_ID, region: regionTextField.text!, zipCode: zipCodeTextField.text!, completion: { (result) in
            self.dismissLoading()
            //            let user = result as! DTOUser
            //            user.saveUser()
            //            user.setAsCurrent()
            self.cancelClicked()
            //            self.arrayOfCities = result as? [DTOCity]
        }) { (msg3, _) in
            if let message = msg3
            {
                self.showErrorMsg(message)
            }
            self.endLoadingError(nil)
        }
    }
    //MARK: - Actions
    @IBAction func acceptClicked()
    {
        if countryTextField.selectedRow == -1
        {
            self.showErrorMsg(MESSAGE_SELECT_COUNTRY)
            return
        }
        if cityTextField.selectedRow == -1
        {
            self.showErrorMsg(MESSAGE_SELECT_CITY)
            return
        }
        //        if regionTextField.text?.isEmpty == true
        //        {
        //            self.showErrorMsg(MESSAGE_ENTER_REGION)
        //            return
        //        }
        //        if zipCodeTextField.text?.isEmpty == true
        //        {
        //            self.showErrorMsg(MESSAGE_ENTER_ZIP)
        //            return
        //        }
        sendData()
    }
    @IBAction func cancelClicked()
    {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController")
        //        self.sideMenuController()?.setContentViewController(vc)
        self.navigationController?.setViewControllers([vc], animated: true)
    }
    //MARK: - Methods
    func loadDataIfExisted()
    {
        let user = DTOUser.currentUser()!
        if let region = user.user_region
        {
            regionTextField.text = region
        }
        if let zipCode = user.user_zipCode
        {
            zipCodeTextField.text = zipCode
        }
        countryTextField.createRightArrow()
        cityTextField.createRightArrow()
        
    }
    func adjustOutlets()
    {
        countryLabel.customizeBoldFont()
        let arr = [countryTextField,cityTextField,regionTextField,zipCodeTextField]
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
    //MARK: - TextField
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == countryTextField
        {
            loadCiteis()
        }
    }
    //    func selectCountry()
    //    {
    //        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectLocationViewController") as! SelectLocationViewController
    //        vc.arrayOfSelections = self.arrayOfCountres!.map{$0.country_name}
    //        vc.block = { index in
    //            self.selectedCountry = self.arrayOfCountres[index]
    //            self.countryTextField.text = self.selectedCountry?.country_name
    //            self.loadCiteis()
    //            self.selectedCity = nil
    //            self.cityTextField.text = ""
    //            vc.block = nil
    //
    //        }
    //        self.navigationController?.pushViewController(vc, animated: true)
    //    }
    //    func selectCity()
    //    {
    //        guard let arr = arrayOfCities else {
    //            return
    //        }
    //        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectLocationViewController") as! SelectLocationViewController
    //        vc.arrayOfSelections = arr.map{$0.city_name}
    //        vc.block = { index in
    //            self.selectedCity = arr[index]
    //            self.cityTextField.text = self.selectedCity?.city_name
    //            vc.block = nil
    //        }
    //        self.navigationController?.pushViewController(vc, animated: true)
    //    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
