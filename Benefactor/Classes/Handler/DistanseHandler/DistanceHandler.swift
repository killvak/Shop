//
//  DistanseHandler.swift
//  Benefactor
//
//  Created by Ahmed Shawky on 8/26/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit

class DistanceHandler: NSObject {
    var distance:Int!{
        didSet{
            UserDefaults.standard.set(NSNumber(integerLiteral: distance), forKey: "Distance")
            UserDefaults.standard.synchronize()
        }
    }
    var unit:String!{
        didSet{
            UserDefaults.standard.set(unit, forKey: "Unit")
            UserDefaults.standard.synchronize()
        }
    }
    static var sharedManager: DistanceHandler = {
        let manager = DistanceHandler()
        return manager
    }()
    private override init() {
        super.init()
        adjustData()
    }
    private func adjustData()
    {
        let defaults = UserDefaults.standard
        if let num  = defaults.object(forKey: "Distance") as? NSNumber
        {
            distance = num.intValue

        }else
        {
            distance =  50
        }
        unit = defaults.object(forKey: "Unit") as? String ?? firstUnit()
    }
    func firstUnit() -> String
    {
        return "Mile"
    }
    func secondUnit() -> String
    {
        return "Kilometer"
    }
    func sumUnits() -> String
    {
        return " " + unit.lowercased() + "s"
    }
    func isMile() -> Bool
    {
        return unit == firstUnit()
    }
    func distanceForServices()->Float
    {
        if DistanceHandler.sharedManager.isMile()
        {
            let meters = Float(self.distance) / (0.000621371192)
            return meters/1000
        }else
        {
            return Float(self.distance)
        }
    }

}
