//
//  OwnerProductsTableViewCell.swift
//  Benefactor
//
//  Created by MacBook Pro on 2/16/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit

class OwnerProductsTableViewCell: UITableViewCell {
    weak var ownerVC:MyProfileViewController?
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var deletedLabel: UILabel?
    @IBOutlet weak var editButton: UIButton?
    @IBOutlet weak var takenButton: UIButton?
    @IBOutlet weak var deleteButton: UIButton?
    @IBOutlet weak var aspectLayout: NSLayoutConstraint!
    //
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        holderView.addCorneredBorder(color: UIColor.clear, radius: 4)
        imgView.addCorneredBorder(color: UIColor.clear, radius: 4)
        holderView.addShadow()
        nameLabel.customizeFont()
        if let lbl = deletedLabel
        {
            lbl.customizeFont()
        }
        let arr = [editButton,takenButton,deleteButton]
        for btn in arr
        {
            if let button = btn
            {
                button.titleLabel?.customizeFont()
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func loadProduct(_ product:DTOProduct)
    {
        nameLabel.text = product.product_name
        print(nameLabel.text)
        if let arr = product.product_images
        {
            imgView.imageRegular(fromString: arr[0].image_urlString)
        }else
        {
            imgView.image = UIImage(named: "defaultImage")
        }

    }
    
    //
    func tagButtons(_ tag:Int)
    {
        if takenButton != nil
        {
            editButton!.tag = tag
            deleteButton!.tag = tag
            takenButton!.tag = tag

        }
    }
    @IBAction func editClicked(_ sender: UIButton) {
        if let vc = ownerVC
        {
            vc.editProduct(index: sender.tag)
        }
    }
    @IBAction func takenClicked(_ sender: UIButton) {
        if let vc = ownerVC
        {
            vc.takenProduct(index: sender.tag)
        }

    }
    @IBAction func deleteClicked(_ sender: UIButton) {
        if let vc = ownerVC
        {
            vc.deleteProduct(index: sender.tag)
        }

    }
    
}
