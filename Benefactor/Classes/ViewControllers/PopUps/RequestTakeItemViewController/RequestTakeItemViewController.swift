//
//  ReuqestTakeItemViewController.swift
//  Benefactor
//
//  Created by Ahmed Shawky on 7/27/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit

class RequestTakeItemViewController: UIViewController {
    //MARK:-Outlets
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var actionButton: UIButton!
    //MARK:-lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustOutlets()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK:-Methods
    func adjustOutlets()
    {
        let lbls = [userLabel!,actionLabel!,itemLabel!,actionButton.titleLabel!]
        for label in lbls {
            label.customizeFont()
        }
        userImageView.circleViewBorders(width: 80)
        holderView.addCorneredBorder(color: UIColor.clear, radius: 10)
        actionButton.addCorneredBorder(color: UIColor.clear, radius: 10)
    }
    //MARK:-Actions
    @IBAction func actionClicked() {
        dismiss(animated: true, completion: nil)
    }
}
