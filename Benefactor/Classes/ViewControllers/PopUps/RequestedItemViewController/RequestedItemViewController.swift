//
//  RequestedItemViewController.swift
//  Benefactor
//
//  Created by Ahmed Shawky on 7/27/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit

class RequestedItemViewController: RequestTakeItemViewController {
    //MARK:-vars
    var ownerVC:NotificationsViewController!
//    weak var notification:DTONotification!
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
        if let arr = product.product_images , arr.count>0
        {
            itemImageView.imageRegular(fromString: arr[0].image_urlString)
        }else
        {
            itemImageView.image = UIImage(named: "defaultImage")
        }
        itemLabel.text = product.product_name
    }
    //MARK:-Actions
    override func actionClicked() {
//        let user = notification.notification_sender!
//        let product = notification.notification_product!
        self.ownerVC.acceptRequest(self.user)
        super.actionClicked()
    }

}
