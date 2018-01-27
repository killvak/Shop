//
//  SlideNavigationController.swift
//  slideMenu
//
//  Created by MacBook Pro on 12/31/16.
//  Copyright © 2016 Old Warriors. All rights reserved.
//

import UIKit
import MisterFusion

class SlideNavigationController: ENSideMenuNavigationController, ENSideMenuDelegate {
    weak var dimmedView:UIView?
    weak var weakSearch:SearchView?
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustNavigationBar()
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "side") as! SideMenuViewController
        vc.ownerVC = self
        sideMenu = ENSideMenu(sourceView: self.view, menuViewController: vc, menuPosition: .left, blurStyle: .dark)
        if UIDevice.modelFromSize() == .iPad {
            sideMenu?.menuWidth = SCREEN_WIDTH * (212/414)
        }else
        {
            sideMenu?.menuWidth = SCREEN_WIDTH * (307/414)

        }
        sideMenu?.delegate = self
        self.view.applyGradient(colours: [UIColor(rgba: "#51509d"), UIColor(rgba: "#2bb2ed")], locations: [0.0, 0.7])
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let v = weakSearch
        {
            v.tblView.reloadData()
        }
    }
    func adjustNavigationBar()
    {
        let titleFontSize : CGFloat = (UIDevice.modelFromSize() == .iPad) ? 22 : 18
//        let navigationController = self
//        navigationController.navigationBar.barTintColor = UIColor.clear
//        navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(rgba:"#fffeff"),NSFontAttributeName:UIFont(name: FONT_NAME, size: titleFontSize)!]
//        navigationController.navigationBar.isTranslucent = true
//        navigationController.navigationBar.tintColor = UIColor.clear
//        navigationController.navigationBar.shadowImage = UIImage()
        let nav = self
//        nav.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        nav.navigationBar.shadowImage = UIImage()
        nav.navigationBar.isTranslucent = true
        nav.navigationBar.backgroundColor = UIColor.white
        nav.view.backgroundColor = UIColor.white
        nav.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(rgba:"#6AC2AA"),NSFontAttributeName:UIFont(name: FONT_NAME, size: titleFontSize)!]

    }
    func closeSideMenu()
    {
        self.hideSideMenuView()

    }
    func sideMenuWillOpen() {
        let vc = self.sideMenu?.menuViewController as! SideMenuViewController
        vc.tableView.reloadData()
        if dimmedView == nil {
            let vv = UIView()

            vv.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            _ = self.view.insertLayoutSubview(vv, at: self.view.subviews.count - 1,
                                              andConstraints: [vv.top |+| 0,
                                                               vv.left |+| 0,
                                                               vv.right |+| 0,
                                                               vv.bottom |+| 0])
            dimmedView = vv
            dimmedView?.alpha = 0

            UIView.animate(withDuration: 0.4, animations: {
                self.dimmedView?.alpha = 0.7
                
            }) { (_) in
                let tap = UITapGestureRecognizer(target: self, action: #selector(SlideNavigationController.closeSideMenu))
                self.dimmedView?.addGestureRecognizer(tap)
            }

        }
    }
    func sideMenuWillClose() {
        UIView.animate(withDuration: 0.4, animations: { 
            self.dimmedView?.alpha = 0

            }) { (_) in
                self.dimmedView?.removeFromSuperview()
                self.dimmedView = nil
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func openSearch()
    {
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController")
//        vc.didMove(toParentViewController: self)
        let searchView = Bundle.main.loadNibNamed("SearchView", owner: self, options: nil)?[0] as! SearchView
                searchView.frame = (self.view.window?.frame)!
        searchView.ownerVC = self
        self.navigationBar.isUserInteractionEnabled = false
        self.topViewController?.view.isUserInteractionEnabled = false
        self.view.addSubview(searchView)
        self.sideMenu!.allowLeftSwipe  = false
        self.sideMenu!.allowRightSwipe  = false
        weakSearch = searchView
    }
    func searchWillClose()
    {
        self.navigationBar.isUserInteractionEnabled = true
        self.topViewController?.view.isUserInteractionEnabled = true
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
