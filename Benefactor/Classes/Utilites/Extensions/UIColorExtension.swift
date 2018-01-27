//
//  UIColorExtension.swift
//  HEXColor
//
//  Created by SHAWE on 6/13/14.
//  Copyright (c) 2014 P.D.Q. All rights reserved.
//

import UIKit
import DynamicColor


extension DynamicColor {
    public convenience init(rgba:String)
    {
        self.init(hexString:rgba)
    }
}
