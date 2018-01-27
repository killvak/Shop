//
//  UIView+Border.swift
//  Benefactor
//
//  Created by MacBook Pro on 12/31/16.
//  Copyright © 2016 Old Warriors. All rights reserved.
//

import UIKit
import UITextView_Placeholder
let FONT_NAME = "Montserrat-Regular"
let BOLD_FONT_NAME = "Montserrat-Bold"
let EXTRA_FONT_NAME = "Poppins-Regular"
extension UILabel {
    func customizeFont()
    {
        let fontSize = (UIDevice.modelFromSize() == .iPhone4) ? self.font.pointSize - 4 : self.font.pointSize
        self.font = UIFont(name: FONT_NAME, size: fontSize)
    }
    func customizeBoldFont()
    {
        let fontSize = (UIDevice.modelFromSize() == .iPhone4) ? self.font.pointSize - 4 : self.font.pointSize

        self.font = UIFont(name: BOLD_FONT_NAME, size: fontSize)
    }
    func customizezExtraFont()
    {
        let fontSize = (UIDevice.modelFromSize() == .iPhone4) ? self.font.pointSize - 4 : self.font.pointSize
        self.font = UIFont(name: EXTRA_FONT_NAME, size: fontSize)
    }

}

extension UITextField {
    func customizeFont()
    {
        self.font = UIFont(name: FONT_NAME, size: (self.font?.pointSize)!)
        
    }
    func customizePlaceHolder(_ color:UIColor)
    {
        if let txt1  = self.placeholder
        {
            let attributed = NSAttributedString(string: txt1, attributes: [NSForegroundColorAttributeName : color,NSFontAttributeName:self.font!])
            self.attributedPlaceholder = attributed
            
        }
        
    }
}
extension UITextView {
    func customizeFont()
    {
        self.font = UIFont(name: FONT_NAME, size: (self.font?.pointSize)!)
        
    }
    func customizePlaceHolder(_ color:UIColor)
    {
        if let txt1  = self.placeholder
        {
            let attributed = NSAttributedString(string: txt1, attributes: [NSForegroundColorAttributeName : color,NSFontAttributeName:self.font!])
            self.attributedPlaceholder = attributed
            
        }
        
    }
}


