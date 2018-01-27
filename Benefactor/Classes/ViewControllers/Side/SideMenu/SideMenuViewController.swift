//
//  SideMenuViewController.swift
//  Benefactor
//
//  Created by MacBook Pro on 12/31/16.
//  Copyright © 2016 Old Warriors. All rights reserved.
//

import UIKit
import SCLAlertView

class SideMenuViewController: UITableViewController {
    weak var ownerVC:SlideNavigationController?
    let arrayOfData = ["Categories","Favorites","Chat","Notification","History","Invite friends","Settings","Logout"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayOfData.count + 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            if UIDevice.modelFromSize() == .iPad {
                return 280
            }
            return 230
            
        } else {
            
            return 50
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "user") as! SideUserTableViewCell
            cell.actionBtn.addTarget(self, action: #selector(SideMenuViewController.completeProfileClicked), for: .touchUpInside)
            return cell
        }else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SideRegulareTableViewCell
            cell.titleLbl.text = arrayOfData[indexPath.row - 1]
            return cell
            
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case arrayOfData.count:
            DTOUser.currentUser()?.logOut()
            NotificationCenter.default.post(name: Notification.Name(rawValue: NOTIFICATION_USER_LOGOUT), object: nil)
            NotificationsConnectonHandler().deleteDevice()
        case 0:
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyProfileViewController")
            self.sideMenuController()?.setContentViewController(vc)
        case 1:
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController")
            self.sideMenuController()?.setContentViewController(vc)
        case 2:
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserFavoritesViewController") as! UserFavoritesViewController
            self.sideMenuController()?.setContentViewController(vc)
        case 3:
            let vc = ChatListViewController()
            self.sideMenuController()?.setContentViewController(vc)
        case 4:
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotificationsViewController") as! NotificationsViewController
            self.sideMenuController()?.setContentViewController(vc)
        case 5:
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HistoryHolderViewController") as! HistoryHolderViewController
            self.sideMenuController()?.setContentViewController(vc)
        case 6:
            inviteFriendClicked()
        case 7:
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
            self.sideMenuController()?.setContentViewController(vc)

        default:
            break
        }
    }
    func inviteFriendClicked()
    {
        //close slide menu
        self.sideMenuController()?.sideMenu?.toggleMenu()
        //url to share
        var itemTOShare = [AnyObject]()
        let url = NSURL(string: "http://benefactorapp.net:8080/storeRestService/public/RedirecOnlineStore")!
        itemTOShare.append(url as AnyObject)
        //activityViewController
        let activityViewController = UIActivityViewController(activityItems: itemTOShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        // present the view controller
        self.ownerVC?.present(activityViewController, animated: true, completion: nil)
    }
    func completeProfileClicked()
    {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserProfileVC") 
        self.sideMenuController()?.setContentViewController(vc)
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
