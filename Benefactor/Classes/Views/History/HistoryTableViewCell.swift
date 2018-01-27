//
//  HistoryTableViewCell.swift
//  Benefactor
//
//  Created by MacBook Pro on 4/29/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    //MARK:Outlet
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    //MARK:Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        imgView.addCorneredBorder(color: UIColor.clear, radius: 4)
        titleLabel.customizeFont()
        dateLabel.customizeFont()
        titleLabel.customizeFont()
        likeLabel.customizeFont()
    }
    func loadProduct(_ product:DTOProduct)
    {
        titleLabel.text = product.product_name
        dateLabel.text = "Posted in " + product.product_dateStringShort
        categoryLabel.text = product.product_categoryName
        likeLabel.text = "\(product.product_likesCount!)"
        if let arr = product.product_images
        {
            imgView.imageRegular(fromString: arr[0].image_urlString)
        }else
        {
            imgView.image = UIImage(named: "defaultImage")
        }
    }

}
