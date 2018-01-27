//
//  UIViewController+Alert.swift
//  Benefactor
//
//  Created by MacBook Pro on 1/4/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit
import SCLAlertView

extension UIViewController
{
    func showErrorMsg(_ message:String)
    {
        SCLAlertView().showError("Error", subTitle: message)
    }
}
