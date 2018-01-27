//
//  UITextField+RightArrow.swhit
//  Benefactor
//
//  Created by MacBook Pro on 4/1/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit

extension UITextField
{
    func createRightArrow()
    {
        let textField = self
        if NSLocale.characterDirection(forLanguage: NSLocale.preferredLanguages[0]) == .rightToLeft
        {
            textField.leftView = smallCancelToAdd(textField.frame.size.height)
            textField.leftViewMode = UITextFieldViewMode.always
        }else
        {
            textField.rightView = smallCancelToAdd(textField.frame.size.height)
            textField.rightViewMode = UITextFieldViewMode.always
        }
    }
    fileprivate func smallCancelToAdd(_ height:CGFloat) ->UIView
    {
        let vvv = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 5, y: 5, width: vvv.frame.height - 10, height: vvv.frame.height - 10)
    
        //        btn.circleView()
        //        btn.backgroundColor = UIColor(rgba:"#B1B0CE")
        btn.setImage(UIImage(named: "arrow_down"), for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        vvv.addSubview(btn)
        vvv.isUserInteractionEnabled = false
        return  vvv
    }

}
