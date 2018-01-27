//
//  UIViewController+back.swift
//  Benefactor
//
//  Created by MacBook Pro on 2/17/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit

extension UIViewController
{
    func adjustBackButton()
    {
        let leftButton = UIBarButtonItem(image: UIImage(named:"back"), style: .plain, target: self, action: #selector(UIViewController.backButtonClicked))
        leftButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = leftButton
    }
    func backButtonClicked()
    {
        if let nav = self.navigationController as? CustomPresentedNavigationController
        {
            if nav.viewControllers.count == 1
            {
                self.dismiss(animated: true, completion: nil)
                return
            }
        }
        _ = self.navigationController?.popViewController(animated: true)
    }
    func searchBarButton() -> UIBarButtonItem
    {
        let leftButton = UIBarButtonItem(image: UIImage(named:"search"), style: .plain, target: self, action: #selector(UIViewController.searchButtonClicked))
        leftButton.tintColor = UIColor.white
        return leftButton
    }
    func searchButtonClicked()
    {
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "test")
//        vc.navigationController?.view.frame = (self.view.window?.frame)!
//        vc.navigationController?.view.addSubview(vc.view)
//        vc.didMove(toParentViewController: (vc.navigationController)!)

        if let nav = self.navigationController as? SlideNavigationController
        {
            nav.openSearch()
        }
    }
    func addProductBarButton() -> UIBarButtonItem
    {
        let leftButton = UIBarButtonItem(image: UIImage(named:"add"), style: .plain, target: self, action: #selector(UIViewController.addProductButtonClicked))
        leftButton.tintColor = UIColor.white
        return leftButton
    }
    func addProductButtonClicked()
    {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddEditProductViewController") as! AddEditProductViewController
        self.navigationController?.pushViewController(vc, animated: true)

    }
    func adjustMenuBarButton()
    {
        let leftButton = UIBarButtonItem(image: UIImage(named:"menu"), style: .plain, target: nil, action: #selector(UIViewController.toggleSideMenuView))
        leftButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = leftButton
    }
}
