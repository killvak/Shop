//
//  ProductsRegularTableViewCell.swift
//  Benefactor
//
//  Created by MacBook Pro on 2/15/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit

class ProductsRegularTableViewCell: UITableViewCell {
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var likeImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor(rgba:"#f3f3f3")
        self.selectionStyle = .none
        likeImageView.image = UIImage(named:"heart")
        holderView.addCorneredBorder(color: UIColor.clear, radius: 4)
        imgView.addCorneredBorder(color: UIColor.clear, radius: 4)
        holderView.addShadow()
        nameLabel.customizeFont()
        dateLabel.customizeFont()
        distanceLabel.customizeFont()
        likesLabel.customizeFont()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func loadProduct(_ product:DTOProduct)
    {
        
        nameLabel.text = product.product_name
        dateLabel.text = "Posted in " + product.product_dateStringShort
        distanceLabel.text = product.product_distance + DistanceHandler.sharedManager.sumUnits()
        likesLabel.text = "\(product.product_likesCount!)"
        if let arr = product.product_images
        {
            imgView.imageRegular(fromString: arr[0].image_urlString)
        }else
        {
            imgView.image = UIImage(named: "defaultImage")
        }
    }
}
