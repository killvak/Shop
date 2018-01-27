//
//  TakenItemViewController.swift
//  Benefactor
//
//  Created by Ahmed Shawky on 7/28/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit

class TakenItemViewController: RequestTakeItemViewController {
    //MARK:-Outlets
    @IBOutlet weak var availableLabel: UILabel!
    //MARK:-vars
    var user:DTOUser!
    var product:DTOProduct!
    //MARK:-lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUI()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK:-Mehtods
    override func adjustOutlets() {
        super.adjustOutlets()
        availableLabel.customizeFont()
    }
    func loadUI()
    {
//        let user = notification.notification_sender!
        if let image = user.user_image
        {
            userImageView.imageProfile(fromString: image)
        }else
        {
            userImageView.image = UIImage(named:"defaultImage")
        }
        userLabel.text = user.displayName
        //
//        let product = notification.notification_product!
        if let arr = product.product_images
        {
            itemImageView.imageRegular(fromString: arr[0].image_urlString)
        }else
        {
            itemImageView.image = UIImage(named: "defaultImage")
        }
        itemLabel.text = product.product_name
    }
}
