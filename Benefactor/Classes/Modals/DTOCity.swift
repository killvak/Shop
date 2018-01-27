//
//  DTOCity.swift
//  Benefactor
//
//  Created by MacBook Pro on 3/8/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit
import SwiftyJSON

class DTOCity: NSObject {
    var city_name:String!
    var city_ID:Int!
    init(_ json:JSON) {
        super.init()
        city_ID = json["id"].intValue
        city_name = json["name"].stringValue
    }
    class func collection(data:JSON) -> [DTOCity]
    {
        let arr = data.arrayValue
        var result = [DTOCity]()
        for dic in arr
        {
            result.append(DTOCity(dic))
        }
        return result
    }

}
