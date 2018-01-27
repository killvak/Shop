//
//  SignUpSecondLayerViewController.swift
//  Benefactor
//
//  Created by MacBook Pro on 12/31/16.
//  Copyright © 2016 Old Warriors. All rights reserved.
//

import UIKit
import SwiftValidators

class SignUpSecondLayerViewController: UIViewController {
    
    //MARK:- vars
    weak var sharedUser:RegisterUser!
    
    //UI
    @IBOutlet weak var headerProgress: YLProgressBar!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var personalBtn: UIButton!
    @IBOutlet weak var personalLabel: UILabel!
    @IBOutlet weak var corporateBtn: UIButton!
    @IBOutlet weak var corporateLabel: UILabel!
    @IBOutlet weak var footerLabel: UILabel!
    @IBOutlet weak var createBtn: UIButton!
    //
    // MARK: - LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustOutlets()
        personalBtn.isSelected = true
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    // MARK: - UI Draming
    func adjustOutlets() {
        
        //BG
        self.view.applyGradient(colours: [UIColor(rgba: "#51509d"), UIColor(rgba: "#2bb2ed")], locations: [0.0, 0.7])
        
        // progress
        headerProgress.type = YLProgressBarType.flat
        headerProgress.progressTintColors = [UIColor.white]
        headerProgress.progress = 1
        
        //Fonts
        backBtn.titleLabel?.customizeFont()
        mainTitleLabel.customizeBoldFont()
        personalLabel.customizeFont()
        corporateLabel.customizeFont()
        createBtn.titleLabel?.customizeFont()
    }
    
    // MARK: - Methods
    func openHome() {
        
        UIApplication.shared.statusBarStyle = .default
        let nav = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "home")
        nav.modalPresentationStyle = .custom
        nav.modalTransitionStyle = .coverVertical
        self.present(nav, animated: true, completion: nil)
    }
   
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
    
    // MARK: - Actions
    @IBAction func backClicked() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func checkmarkClicked(_ sender:UIButton) {
        if sender == personalBtn {
            personalBtn.isSelected = true
            corporateBtn.isSelected = false
        }else{
            corporateBtn.isSelected = true
            personalBtn.isSelected = false
        }
    }
    
    @IBAction func createClicked() {
        startLoading()
        UserConnectionHandler().register(user: sharedUser, completion: { (result) in
            self.dismissLoading()
            self.openHome()
        }) { (message, object) in
            self.dismissLoading()
            self.handleError(message: message, object: object)
        }
    }
}
