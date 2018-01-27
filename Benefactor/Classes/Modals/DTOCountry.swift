//
//  DTOCountry.swift
//  Benefactor
//
//  Created by MacBook Pro on 3/8/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit
import SwiftyJSON

class DTOCountry: NSObject {
    var country_name:String!
    var country_ID:Int!
    init(_ json:JSON) {
        super.init()
        country_ID = json["id"].intValue
        country_name = json["name"].stringValue
    }
    class func collection(data:JSON) -> [DTOCountry]
    {
        let arr = data.arrayValue
        var result = [DTOCountry]()
        for dic in arr
        {
            result.append(DTOCountry(dic))
        }
        return result
    }}
