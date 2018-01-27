//
//  SearchView+UIMethods.swift
//  Benefactor
//
//  Created by MacBook Pro on 3/20/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit
import HMSegmentedControl
import MisterFusion

extension SearchView
{
    //MARK: - Public
    func adjustOutlets()
    {
        //
        dismissButton.layer.cornerRadius = 13
        dismissButton.clipsToBounds = true
        dismissButton.backgroundColor = UIColor(rgba:"#B1B0CE")
        dismissButton.setTitleColor(UIColor(rgba:"#51509D"), for: .normal)
        //
        distanceLabel.customizeFont()
        distanceValueLabel.customizeFont()
        actionButton.titleLabel?.customizeFont()
        txtField.customizeFont()
        txtField.customizePlaceHolder(UIColor(rgba:"#B1B0CE"))
        txtField.clearButtonMode = .never
        //
        adjustSearch()
        createSegmented()
        addTapGesture()
        configureTable()
    }
    //MARK: - Segmented
    fileprivate func createSegmented()
    {
        let arr = ["Newest","Closet"];
        let segmentedControl = HMSegmentedControl(sectionTitles: arr)!
        segmentedControl.frame = CGRect(x: 0, y: 60, width: self.frame.width, height: 40)
        segmentedControl.autoresizingMask = [.flexibleRightMargin , .flexibleWidth]
        segmentedControl.selectionIndicatorLocation = .down
        segmentedControl.selectionStyle = .fullWidthStripe
        segmentedControl.segmentWidthStyle = .fixed
        segmentedControl.selectionIndicatorHeight = 2.0
        segmentedControl.selectionIndicatorColor = UIColor.white
        segmentedControl.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white,NSFontAttributeName:UIFont(name: FONT_NAME, size: 19)!]
        segmentedControl.selectedTitleTextAttributes = [NSForegroundColorAttributeName : UIColor.white,NSFontAttributeName:UIFont(name: FONT_NAME, size: 19)!]
        segmentedControl.addTarget(self, action: #selector(SearchView.segementedValueChange(_:)), for: .valueChanged)
        _ = holderOfSegmented.addLayoutSubview(segmentedControl,
                                               andConstraints: [segmentedControl.right |==| holderOfSegmented.right,
                                                                segmentedControl.left |==| holderOfSegmented.left,
                                                                segmentedControl.bottom |==| holderOfSegmented.bottom |-| 10,
                                                                segmentedControl.top |==| holderOfSegmented.top])
        segmentedControl.backgroundColor = UIColor.clear
//        segmentedControl.selectedSegmentIndex = selectedIndex
        segControl = segmentedControl
    }
    //MARK: - Background
    fileprivate func addTapGesture()
    {
        let tap = UITapGestureRecognizer(target: self, action: #selector(SearchView.closeTheView))
        resultBackgroundView.addGestureRecognizer(tap)
        
    }
    //MARK: - TextField
    fileprivate func adjustSearch()
    {
        txtField.addCorneredBorder(color: UIColor.clear, radius: 15)
        createLeftViewForTextField(txtField, image: UIImage(named:"search")!)
        createRightViewForTextField(txtField)
    }
    fileprivate func createLeftViewForTextField(_ textField:UITextField,image:UIImage)
    {
        if NSLocale.characterDirection(forLanguage: NSLocale.preferredLanguages[0]) == .leftToRight
        {
            textField.leftView = smallViewToAdd(image,height: textField.frame.size.height)
            textField.leftViewMode = UITextFieldViewMode.always
        }else
        {
            textField.rightView = smallViewToAdd(image,height: textField.frame.size.height)
            textField.rightViewMode = UITextFieldViewMode.always
            
        }
    }
    fileprivate func createRightViewForTextField(_ textField:UITextField)
    {
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
        btn.circleView()
        btn.backgroundColor = UIColor(rgba:"#B1B0CE")
        btn.setImage(UIImage(named: "x"), for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.addTarget(self, action: #selector(SearchView.clearClicked(_:)), for: .touchUpInside)
        vvv.addSubview(btn)
        return  vvv
    }

    fileprivate func smallViewToAdd(_ image:UIImage,height:CGFloat) ->UIView
    {
        let vvv = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: height))
        let imgView = UIImageView(frame:CGRect(x: 0, y: 0, width: vvv.frame.width, height: vvv.frame.height))
        imgView.image = image
        imgView.contentMode = .center
        //        imgView.backgroundColor = UIColor.yellow
        vvv.addSubview(imgView)
        
        return  vvv
    }


}
