//
//  UIView+Border.swift
//  Benefactor
//
//  Created by MacBook Pro on 12/31/16.
//  Copyright © 2016 Old Warriors. All rights reserved.
//

import UIKit

extension UIView {

    func addCorneredBorder(color:UIColor,radius:CGFloat)
    {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = radius
    }
    func addShadow()
    {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 3
    }
    func circleView()
    {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true

    }
    func circleView(width:CGFloat)
    {
        self.layer.cornerRadius = width / 2
        self.clipsToBounds = true
        
    }

    func circleViewBorders()
    {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 2
        self.clipsToBounds = true
        
    }
    func circleViewBorders(width:CGFloat)
    {
        self.layer.cornerRadius = width / 2
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 2
        self.clipsToBounds = true
        
    }

}

extension UIView {
    func applyGradient(colours: [UIColor]) -> Void {
        self.applyGradient(colours: colours, locations: nil)
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = UIScreen.main.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
}
