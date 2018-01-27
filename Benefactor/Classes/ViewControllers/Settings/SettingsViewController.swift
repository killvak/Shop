//
//  SettingsViewController.swift
//  Benefactor
//
//  Created by MacBook Pro on 6/7/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    //Outlet
    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        self.automaticallyAdjustsScrollViewInsets = false
        addBarButtons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func addBarButtons() {
        self.adjustMenuBarButton()
        let rightButton1 = self.searchBarButton()
        //        let rightButton2 = self.addProductBarButton()
        let rightButton2 = UIBarButtonItem(image: UIImage(named:"add"), style: .plain, target: self, action: #selector(SettingsViewController.addButtonClicked))
        rightButton2.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItems = [rightButton1,rightButton2]
    }
    @IBAction func addButtonClicked()
    {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddEditProductViewController") as! AddEditProductViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    // MARK: - Table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cell\(indexPath.row)"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier)!
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileVC
//            vc.isSecondLayer = true
            self.navigationController?.pushViewController(vc, animated: true)
        case 4:
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            } else {
                UIApplication.shared.openURL(settingsUrl)
            }
            
        case 2:
            let vc = TextDisplayerViewController()
            vc.fileName = "terms"
            vc.title = "Terms of use"
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = TextDisplayerViewController()
            vc.fileName = "privacy"
            vc.title = "Privacy policy"
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.row != 5 else {
             return 166
        }
        return 60
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
