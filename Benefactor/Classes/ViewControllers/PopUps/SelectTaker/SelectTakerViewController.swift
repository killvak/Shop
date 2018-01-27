//
//  SelectTakerViewController.swift
//  Benefactor
//
//  Created by Ahmed Shawky on 7/22/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit

class SelectTakerViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    //MARK:- vars
    //MARK: Outlets
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var holderView: UIView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var usersTableView: UITableView!
    @IBOutlet weak var skipButton: UIButton!
    //MARK: Data
    weak var ownerVC:MyProfileViewController!
    var arrayOfUsers:[DTOUser]!
    var product:DTOProduct!
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustOutlets()
        loadProductUI()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //MARK:- Methods
    func adjustOutlets()
    {
        itemImageView.circleView(width: 70)
        holderView.addCorneredBorder(color: UIColor.clear, radius: 10)
        skipButton.addCorneredBorder(color: UIColor.clear, radius: 10)
        itemTitleLabel.customizeFont()
        headerLabel.customizeFont()
        skipButton.titleLabel?.customizeFont()
    }
    func loadProductUI()
    {
        itemTitleLabel.text = product.product_name
        if let arr = product.product_images
        {
            itemImageView.imageRegular(fromString: arr[0].image_urlString)
        }else
        {
            itemImageView.image = UIImage(named: "defaultImage")
        }
    }
    func sendTakenToOwner(_ user_id:Int)
    {
        self.ownerVC.markItemTaken(itemID: self.product.product_id, userID: user_id)
        dismiss(animated: true, completion: nil)
    }
    //MARK:- Actions
    @IBAction func skipClicked() {
        sendTakenToOwner(-1)
    }
    //MARK:- TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfUsers.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TakerTableViewCell
        let item = arrayOfUsers[indexPath.row]
        cell.loadItem(item)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = arrayOfUsers[indexPath.row]
        sendTakenToOwner(user.user_id)
    }

}
