//
//  DTOCategory.swift
//  Benefactor
//
//  Created by MacBook Pro on 1/4/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit
import SwiftyJSON

class DTOCategory: NSObject {
    var category_name:String?
    var category_ID:NSNumber?
    var category_image:String?
    init(_ json:JSON) {
        category_name = json["title"].string
        category_ID = json["id"].number
        category_image = json["logo"].string
    }
    class func collection(data:JSON) -> [DTOCategory]
    {
        let arr = (data.array)!
        var result = [DTOCategory]()
        for dic in arr
        {
            result.append(DTOCategory(dic))
        }
        return result
    }
    override var description: String{
        return "name is \(String(describing: self.category_name))"
    }

}
