//
//  DetailedProductViewController.swift
//  Benefactor
//
//  Created by MacBook Pro on 2/15/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit
import XLActionController
import SCLAlertView
import Agrume
import GoogleMobileAds

class DetailedProductViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    //MARK:- UI
    @IBOutlet weak var tblView:UITableView!
    @IBOutlet weak var intersetButton: UIButton!
    @IBOutlet weak var askButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var actionViewBottomSpace: NSLayoutConstraint!
    
    var bannerView: GADBannerView!

    //MARK:- Data
    var product:DTOProduct!
    var owner:DTOUser?
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        addBarButtons()
        self.title = product.product_name
        adjustOulets()
        tblView.estimatedRowHeight = 300
        tblView.rowHeight = UITableViewAutomaticDimension
        //
        
        initAdMobBannar()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
            loadOwner()
    }
    
    // MARK: - AdMob
    func initAdMobBannar() {
        
        let y = view.frame.size.height - CGSizeFromGADAdSize(kGADAdSizeSmartBannerPortrait).height
        
        bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait, origin: CGPoint(x: 0, y: y))
        
        bannerView.adUnitID = AdUnitID
        bannerView.rootViewController = self
        bannerView.delegate = self
        
        bannerView.load(GADRequest())
    }
    
    //MARK:- Methods
    func adjustOulets()
    {
        intersetButton.titleLabel?.customizeFont()
        askButton.titleLabel?.customizeFont()
        intersetButton.addCorneredBorder(color: UIColor.clear, radius: 23)
        askButton.addCorneredBorder(color:  UIColor.clear, radius: 23)
        
    }
    func addBarButtons() {
        self.adjustBackButton()
        let rightButton = UIBarButtonItem(image: UIImage(named:"3dots"), style: .plain, target: self, action: #selector(DetailedProductViewController.moreClicked))
        self.navigationItem.rightBarButtonItem = rightButton
        rightButton.tintColor = UIColor.white
        
    }
    func loadOwner()
    {
        if owner == nil{
            self.startLoading()
        }
        let userID = self.product.product_ownerID
        let success:SucessBlock = { (result) in
            self.owner = result as? DTOUser
                        self.dismissLoading()
                        self.tblView.reloadData()
                        self.likeButton.isSelected = self.product.product_isLiked
        }
        let failed:FailureBlock =  { (message, _) in
            self.endLoadingError(message!)
            self.showErrorMsg(message!)
        }
        

        UserConnectionHandler().getUser(userID, completion: success, failed: failed)

//        ProductConnectionHandler().requestdetails(product, completion: { (_) in
//            self.dismissLoading()
//            self.tblView.reloadData()
//            self.likeButton.isSelected = self.product.product_isLiked
//        }) { (message, _) in
//            self.endLoadingError(message!)
//            self.showErrorMsg(message!)
//        }
    }
    //MARK:- Actions
    func openFullScreen(index:Int)
    {
        guard let arr = product.product_images ,arr.count>0 else {
            return
        }
        var urls : [URL] = []
            for ss in arr
            {
                urls.append(URL(string: ss.image_urlString)!)
            }

        let agrume = Agrume(imageUrls: urls, startIndex: index, backgroundBlurStyle: UIBlurEffectStyle.dark, backgroundColor: nil)
        agrume.showFrom(self)
        
    }
    func moreClicked()
    {
        let actionController = CustomActionSheetActionController()
        let favoriteString = (self.product.product_isFavorited!) ? "remove from favorites" : "add favorites"
        actionController.addAction(Action(favoriteString, style: .default, handler: { action in
            if self.product.product_isFavorited == true
            {
                self.removeFavorite()
            }else
            {
                self.addFavorite()
            }
        }))
        actionController.addAction(Action("report item", style: .default, handler: { action in
            self.reportClicked()
        }))
        
        present(actionController, animated: true, completion: nil)
        
    }
    func reportClicked()
    {
        let appearance = SCLAlertView.SCLAppearance(
            kWindowWidth:SCREEN_WIDTH - 100,
            kWindowHeight:SCREEN_HEIGHT/2.5,
            showCloseButton: false
        )
        let alert = SCLAlertView(appearance: appearance)
        
        let txt = alert.addTextView()
        alert.addButton("Report") {
            self.confirmReport(reason: txt.text)
        }
        alert.addButton("Cancel") {}
        alert.showError("Report Item", subTitle: "Write your resaons")
        
    }
    @IBAction func intersetClicked() {
        if self.owner!.user_id == DTOUser.currentUser()?.user_id {
            self.showErrorMsg(MESSAGE_YOUR_PRODUCT)
            return
        }
        self.startLoading()
        ProductConnectionHandler().requestProduct(productID: self.product.product_id, ownerID: owner!.user_id, completion: { (_) in
            self.dismissLoading()
            }, failed: { (message, _) in
                self.endLoadingError(message!)
                self.showErrorMsg(message!)
        })

    }
    @IBAction func askClicked() {
        if self.owner!.user_id == DTOUser.currentUser()?.user_id {
            self.showErrorMsg(MESSAGE_YOUR_PRODUCT)
            return
        }
//        self.showErrorMsg(MESSAGE_NOT_IMPLEMENTED)
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MessageViewController") as! MessageViewController
//        vc.user =
        let appearance = SCLAlertView.SCLAppearance(
            kWindowWidth:SCREEN_WIDTH - 100,
            kWindowHeight:SCREEN_HEIGHT/2.5,
            showCloseButton: false
        )
        let alert = SCLAlertView(appearance: appearance)
        
        let txt = alert.addTextView()
        alert.addButton("OK") {
            self.sendAsk(ask: txt.text)
        }
        alert.addButton("Cancel") {}
        alert.showNotice("ASK", subTitle: "Enter your Question/Message")

        
    }
    func sendAsk(ask:String)
    {
        if ask == ""
        {
            self.showErrorMsg("Please Enter Message")
            return
        }
        self.startLoading()
        ChatConnectionHandler().sendMessage(userID: self.owner!.user_id, message: ask, completion: { (_) in
            self.dismissLoading()
        }) { (message, _) in
            self.endLoadingError(message!)
            self.showErrorMsg(message!)
        }
        
    }

    @IBAction func likeClicked() {
//        self.startLoading()
        if self.product.product_isLiked == false {
            ProductConnectionHandler().likeProduct(productID: self.product.product_id, completion: { (_) in
                self.dismissLoading()
                self.product.product_isLiked = true
                self.likeButton.isSelected = true
                self.product.product_likesCount = self.product.product_likesCount + 1
                self.tblView.reloadData()
                }, failed: { (message, _) in
                    self.endLoadingError(message!)
                    self.showErrorMsg(message!)
            })
        }else
        {
            ProductConnectionHandler().unlikeProduct(productID: self.product.product_id, completion: { (_) in
                self.dismissLoading()
                self.product.product_isLiked = false
                self.likeButton.isSelected = false
                self.product.product_likesCount = self.product.product_likesCount - 1
                self.tblView.reloadData()
                }, failed: { (message, _) in
                    self.endLoadingError(message!)
                    self.showErrorMsg(message!)
            })

        }
    }
    @IBAction func shareClicked() {
        var textToShare:String!
        if let details = self.product.product_description
        {
            textToShare = self.product.product_name   + "\n" + details

        }else
        {
            textToShare = self.product.product_name
        }
        var itemTOShare = [AnyObject]()
        itemTOShare.append(textToShare as AnyObject)
        itemTOShare.append(self.product.product_urlString as AnyObject)

        //activityViewController
        let activityViewController = UIActivityViewController(activityItems: itemTOShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    func addFavorite()
    {
        self.startLoading()
        ProductConnectionHandler().favoriteProduct(productID: self.product.product_id, completion: { (_) in
            self.dismissLoading()
            self.product.product_isFavorited = true
            }) { (message, _) in
                self.endLoadingError(message!)
                self.showErrorMsg(message!)
        }
    }
    func removeFavorite()
    {
        self.startLoading()
        ProductConnectionHandler().unfavoriteProduct(productID: self.product.product_id, completion: { (_) in
            self.dismissLoading()
            self.product.product_isFavorited = true
        }) { (message, _) in
            self.endLoadingError(message!)
            self.showErrorMsg(message!)
        }

    }
    func confirmReport(reason:String)
    {
        self.startLoading()
        ProductConnectionHandler().reportProduct(productID: self.product.product_id, reason: reason, completion: { (_) in
            self.dismissLoading()
        }) { (message, _) in
            self.endLoadingError(message!)
            self.showErrorMsg(message!)
        }
    
    }
    @IBAction func followUser(_ sender: AnyObject) {
        if self.owner!.user_isFollowed == true {
            doUnfollow()
        }else
        {
            doFollow()
        }
    }
    func doFollow()
    {
        self.startLoading()
        OtherUserConnectionHandler().followUser(userID: self.owner!.user_id, completion: { (_) in
            self.dismissLoading()
            self.owner!.user_isFollowed = true
            self.tblView.reloadData()
        }) { (message, _) in
            self.endLoadingError(message!)
            self.showErrorMsg(message!)
        }
    }
    func doUnfollow()
    {
        self.startLoading()
        OtherUserConnectionHandler().unfollowUser(userID: self.owner!.user_id, completion: { (_) in
            self.dismissLoading()
            self.owner!.user_isFollowed = false
            self.self.tblView.reloadData()
        }) { (message, _) in
            self.endLoadingError(message!)
            self.showErrorMsg(message!)
        }
    }
    //MARK:- tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if owner != nil {
            return 2
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row + 1
        let identifter = "cell\(index)"
        var cell :UITableViewCell
        if index == 1 {
            let cell1 = tableView.dequeueReusableCell(withIdentifier: identifter) as! detailedProductImageTableViewCell
            cell1.loadProduct(product)
            cell1.ownerVC = self
            cell = cell1
        }else
        {
            let cell2 = tableView.dequeueReusableCell(withIdentifier: identifter) as! detailedProductOwnerTableViewCell
            cell2.loadProduct(product,owner!)
            cell = cell2
        }
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "user" {
            let vc = segue.destination as! UserProfileViewController
            vc.userID = self.owner!.user_id
        }
    }
}

extension DetailedProductViewController: GADBannerViewDelegate {
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        
        bannerView.alpha = 0
        
        view.addSubview(bannerView)
        
        UIView.animate(withDuration: 0.4, animations: {
            
            bannerView.alpha = 1
            
            self.actionViewBottomSpace.constant = bannerView.frame.size.height
            self.view.layoutIfNeeded()
        })
    }
}
