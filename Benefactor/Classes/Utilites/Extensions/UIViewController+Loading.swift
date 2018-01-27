//
//  UIViewController+Loading.swift
//  Benefactor
//
//  Created by MacBook Pro on 1/3/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit
import SVProgressHUD

extension UIViewController {
    class func configureLoading()
    {
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setMinimumSize(CGSize(width: 100, height: 100))
    }
    func startLoading() {
        
        SVProgressHUD.show()
        startAnimatingNetworkActivity()
    }
    func startLoading(_ message:String) {
        
        SVProgressHUD.show(withStatus: message)
        startAnimatingNetworkActivity()
    }
    func endLoadingSuccess(_ msg: String?) {
        stopAnimatingNetworkActivity()
        guard let message = msg else {
            SVProgressHUD.showSuccess(withStatus: "Success")
            return
        }
        SVProgressHUD.showSuccess(withStatus: message)
    }
    func endLoadingError(_ msg: String?) {
        stopAnimatingNetworkActivity()

        guard let message = msg else {
            SVProgressHUD.showError(withStatus: "Error")
            return
        }
        SVProgressHUD.showError(withStatus: message)
    }
    func dismissLoading() {
        SVProgressHUD.dismiss()
        stopAnimatingNetworkActivity()

    }
    
    private func startAnimatingNetworkActivity() {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.view.window?.isUserInteractionEnabled = false

    }
    
    private func stopAnimatingNetworkActivity() {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        self.view.window?.isUserInteractionEnabled = true

    }

    
}
