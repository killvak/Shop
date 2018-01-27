//
//  HomeCollectionViewCell.swift
//  Benefactor
//
//  Created by MacBook Pro on 12/31/16.
//  Copyright © 2016 Old Warriors. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
  
    override func awakeFromNib() {
  
        super.awakeFromNib()
//        titleLabel.customizezExtraFont()
    }
    
    func loadCategory(_ category:DTOCategory,index:Int) {
        
        titleLabel.text = category.category_name
        if let image = category.category_image{
            imgView.imageRegular(fromString: image)
        }else{
            let newString = category.category_name?.lowercased().replacingOccurrences(of: " ", with: "_", options: .literal, range: nil)
            imgView.image = UIImage(named: newString!)

        }

//        let reminder = index % 3
        
//        switch reminder {
//        case 0:
//            contentView.backgroundColor = UIColor(rgba:"#2bb2ed")
//        case 1:
//            contentView.backgroundColor = UIColor(rgba:"#2b79ed")
//        case 2:
//            contentView.backgroundColor = UIColor(rgba:"#3a42e6")
//
//        default:
//            break
//        }
        
        let anotherReminder = (index ) % 6
      
        switch anotherReminder {
        
        case 0, 1, 2:
            holderView.backgroundColor = UIColor.clear

        default:
            holderView.backgroundColor = UIColor.clear //UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)

        }
        
        holderView.addInnerShadow(withRadius: 20, andAlpha: 0.05)
    }
}
