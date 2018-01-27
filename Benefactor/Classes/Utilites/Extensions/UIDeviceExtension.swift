//
//  UIDeviceExtension.swift
//  Benefactor
//
//  Created by MacBook Pro on 12/31/16.
//  Copyright © 2016 Old Warriors. All rights reserved.
//

import class UIKit.UIDevice
import class UIKit.UIScreen

extension UIDevice {
    
    enum Model {
        case iPhone4
        case iPhone5
        case iPhone6
        case iPhone6Plus
        case iPad
        case unknown  // iPhone 7 etc.
    }
    
    class func modelFromSize() -> Model {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .iPad
        }
        let sz = UIScreen.main.bounds.size
        switch (sz.width, sz.height) {
        case (320, 480): return .iPhone4
        case (320, 568): return .iPhone5
        case (375, 667): return .iPhone6
        case (414, 736): return .iPhone6Plus
        default:
            return .unknown
        }
    }
}
