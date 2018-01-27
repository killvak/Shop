//
//  UIImageView+Online.swift
//  Benefactor
//
//  Created by MacBook Pro on 1/17/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit
import Kingfisher
//import ObjectiveC
//var AssociatedObjectHandle: UInt8 = 0


extension UIImageView
{
    func imageProfile(fromString:String)
    {
        guard fromString != "" else {
            self.image = UIImage(named:"defaultImage")

            return
        }
        
        let url = Foundation.URL(string: fromString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!
        self.kf.setImage(with: url, placeholder: UIImage(named:"placeholderImage"), options: nil, progressBlock: nil, completionHandler: {
            (image, error, cacheType, imageUrl) in
            if image == nil{
                self.image = UIImage(named:"defaultImage")
//                self.associtedVar = ""
            }else
            {
//                self.associtedVar = "tamam"
            }
        })

    }
    func imageRegular(fromString:String)
    {
        guard fromString != "" else {
            self.image = UIImage(named:"defaultImage")
            
            return
        }

        let url = Foundation.URL(string: fromString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!
        self.kf.setImage(with: url, placeholder: UIImage(named:"placeholderImage"), options: nil, progressBlock: nil, completionHandler:{
            (image, error, cacheType, imageUrl) in
            if image == nil{
                self.image = UIImage(named:"defaultImage")
//                self.associtedVar = ""
            }else
            {
//                self.associtedVar = "tamam"
            }
            })
        
    }
//    var associtedVar:String {
//        get {
//            return objc_getAssociatedObject(self, &AssociatedObjectHandle) as? String ?? ""
//        }
//        set {
//            objc_setAssociatedObject(self, &AssociatedObjectHandle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        }
//    }
//    func isLoaded() -> Bool
//    {
//        return self.associtedVar == "tamam"
//    }


}

