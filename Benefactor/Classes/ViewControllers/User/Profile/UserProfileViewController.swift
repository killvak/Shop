//
//  UserProfileViewController.swift
//  Benefactor
//
//  Created by MacBook Pro on 2/16/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit
import XLActionController
import SCLAlertView

class UserProfileViewController: MyProfileViewController {
    //MARK: - UI
    weak var followButton:UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func adjustTable() {
        super.adjustTable()
        tblView.register(UINib(nibName: "ProductsRegularTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tblView.estimatedRowHeight = 300
        tblView.rowHeight = UITableViewAutomaticDimension
        //
    }
    override func tableHeader() -> UIView {
        let header = (Bundle.main.loadNibNamed("OtherProfileHeaderView", owner: self, options: nil)?[0] as? OtherProfileHeaderView)!
        header.loadUser(user: user!)
        header.firstSlideView.followButton?.addTarget(self, action: #selector(UserProfileViewController.followUser(_:)), for: .touchUpInside)
        self.followButton = header.firstSlideView.followButton
        return header
    }
    override func cell(table: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let arr = connectionHandler.arrayOfProducts!
        let cell = table.dequeueReusableCell(withIdentifier: "cell") as! ProductsRegularTableViewCell
        cell.loadProduct(arr[indexPath.row])
        return cell
    }
    override func currentCordinates() -> (Double?,Double?)
    {
        return (lat: LocationHandler.latitude, lng: LocationHandler.longitude)
    }
    override func addBarButtons() {
        self.adjustBackButton()
        if self.userID != DTOUser.currentUser()?.user_id
        {
            let rightButton = UIBarButtonItem(image: UIImage(named:"3dots"), style: .plain, target: self, action: #selector(UserProfileViewController.moreClicked))
            self.navigationItem.rightBarButtonItem = rightButton
            rightButton.tintColor = UIColor.white
            
        }
    }
    //MARK:- Actions
    func moreClicked()
    {
        let actionController = CustomActionSheetActionController()
        actionController.addAction(Action("report user", style: .default, handler: { action in
            self.reportClicked()
        }))
        present(actionController, animated: true, completion: nil)
    }
    
    @IBAction func followUser(_ sender: AnyObject) {
        if user!.user_isFollowed == true {
            doUnfollow()
        }else
        {
            doFollow()
        }
    }
    func doFollow()
    {
        self.startLoading()
        OtherUserConnectionHandler().followUser(userID: user!.user_id, completion: { (_) in
            self.dismissLoading()
            self.user!.user_isFollowed = true
            self.followButton?.setTitle("Unfollow", for: .normal)
        }) { (message, _) in
            self.endLoadingError(message!)
            self.showErrorMsg(message!)
        }
    }
    func doUnfollow()
    {
        self.startLoading()
        OtherUserConnectionHandler().unfollowUser(userID: user!.user_id, completion: { (_) in
            self.dismissLoading()
            self.user!.user_isFollowed = false
            self.followButton?.setTitle("Follow", for: .normal)
        }) { (message, _) in
            self.endLoadingError(message!)
            self.showErrorMsg(message!)
        }
    }
    func confirmReport(reason:String)
    {
        self.startLoading()
        OtherUserConnectionHandler().reportUser(userID: user!.user_id, reason: reason, completion: { (_) in
            self.dismissLoading()
        }) { (message, _) in
            self.endLoadingError(message!)
            self.showErrorMsg(message!)
        }
        
    }
    func reportClicked()
    {
        let appearance = SCLAlertView.SCLAppearance(
            kWindowWidth:SCREEN_WIDTH - 100,
            kWindowHeight:SCREEN_HEIGHT/2.5,
            showCloseButton: false
        )
        let alert = SCLAlertView(appearance: appearance)
        
        let txt = alert.addTextView()
        alert.addButton("Report") {
            self.confirmReport(reason: txt.text)
        }
        alert.addButton("Cancel") {}
        alert.showError("Report User", subTitle: "Write your resaons")
        
    }
    //
//    override func loadExtra() {
//        OtherUserConnectionHandler().chechFollow(userID: self.userID, completion: { (result) in
//            let isFollow = result as! Bool
//            if isFollow
//            {
//                self.user!.user_isFollowed = true
//                self.followButton?.setTitle("Unfollow", for: .normal)
//            }else
//            {
//                self.user!.user_isFollowed = false
//                self.followButton?.setTitle("Follow", for: .normal)
//            }
//            super.loadExtra()
//        }) { (message, _) in
//            self.dismissLoading()
//            self.showErrorMsg(message!)
//        }
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
