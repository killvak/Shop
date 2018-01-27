//
//  MyProfileViewController.swift
//  Benefactor
//
//  Created by MacBook Pro on 2/15/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit
import Presentr

class MyProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    //MARK: - UI
    @IBOutlet weak var tblView: UITableView!
    //MARK:- Data
    var userID:Int = (DTOUser.currentUser()?.user_id)!
    var connectionHandler:ProductConnectionHandler!
    var user:DTOUser?
    var isFirstAppear = true
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.applyGradient(colours: [UIColor(rgba: "#51509d"), UIColor(rgba: "#2bb2ed")], locations: [0.0, 0.7])
        self.automaticallyAdjustsScrollViewInsets = false
        addBarButtons()
//        UserConnectionHandler().getFollowers(completion: { (result) in
//            
//        }) { (message, _) in
//            
//        }
//        ChatConnectionHandler().getChatUsers(completion: { (result) in
//            
//                    }) { (message, _) in
//            
//                    }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadUser()
    }
    // MARK: - Methods
    func adjustTable()
    {
        tblView.estimatedRowHeight = 232
        tblView.rowHeight = UITableViewAutomaticDimension
        //
        let header = tableHeader()
        var frame = header.frame
        frame.size.width = SCREEN_WIDTH
        let aspect:CGFloat = (UIDevice.modelFromSize() == .iPad) ? (340 / 814) : (340 / 414)
        frame.size.height = SCREEN_WIDTH * aspect
        header.frame = frame
        print(frame)
        tblView.tableHeaderView = header
        tblView.addInfiniteScrolling {
            self.loadMoreProducts()
        }
    }
    private func loadUser()
    {
        if isFirstAppear {
            self.startLoading()
            isFirstAppear = false
        }
        let success:SucessBlock = { (result) in
            self.user = result as? DTOUser
            self.adjustTable()
            self.loadExtra()
        }
        let failed:FailureBlock =  { (message, _) in
            self.endLoadingError(message!)
            self.showErrorMsg(message!)
        }
        
        if userID == DTOUser.currentUser()!.user_id
        {
            UserConnectionHandler().getCurrentUser(completion: success, failed: failed)
        
        }else
        {
            UserConnectionHandler().getUser(userID, completion: success, failed: failed)
        
        }
//        UserConnectionHandler().getUser(userID, completion: { (result) in
//            self.user = result as? DTOUser
//            self.adjustTable()
//            self.loadExtra()
//        }) failed
    }
    func loadExtra()
    {
        self.loadProducts()
    }
    private func loadProducts()
    {
        connectionHandler = ProductConnectionHandler()
        let loc = currentCordinates()
        connectionHandler.requestProducts(ownerID: userID, lat: loc.0, lng:loc.1, completion: { (_) in
            self.tblView.reloadData()
            self.dismissLoading()
            
        }) { (message, _) in
            self.endLoadingError(message!)
            self.showErrorMsg(message!)
        }
    }
    private func loadMoreProducts()
    {
        if !(self.connectionHandler?.hasMoreData)!
        {
            self.tblView.showsInfiniteScrolling = false
            return
        }

        connectionHandler.requestProducts(ownerID: userID, lat: nil, lng: nil, completion: { (_) in
            self.tblView.reloadData()
            self.dismissLoading()
            self.tblView.infiniteScrollingView.stopAnimating()
            if !(self.connectionHandler?.hasMoreData)!
            {
                self.tblView.showsInfiniteScrolling = false
            }
        }) { (message, _) in
            self.endLoadingError(message!)
            self.showErrorMsg(message!)
        }
        
    }
    func markItemTaken(itemID:Int,userID:Int)
    {
        startLoading()
        ProductConnectionHandler().markItemTaken(productID: itemID, userID: userID, completion: { (_) in
            self.loadProducts()
        }) { (msg3, _) in
            if let message = msg3
            {
                self.showErrorMsg(message)
            }
            self.endLoadingError(nil)
        }

    }
    // MARK: - Actions
    func deleteProduct(index:Int)
    {
        startLoading()
        let item = connectionHandler.arrayOfProducts![index]
        ProductConnectionHandler().deleteProduct(productID: item.product_id, completion: { (_) in
            item.product_status = .deleted
            self.tblView.reloadData()
            self.dismissLoading()
            }) { (msg3, _) in
                if let message = msg3
                {
                    self.showErrorMsg(message)
                }
                self.endLoadingError(nil)
        }
    }
    func takenProduct(index:Int)
    {
        self.startLoading()
        ChatConnectionHandler().getChatUsers(completion: { (results) in
            self.dismissLoading()
            let arr = results as! [DTOUser]
            let item = self.connectionHandler.arrayOfProducts![index]
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectTakerViewController") as! SelectTakerViewController
            vc.ownerVC = self
            vc.arrayOfUsers = arr
            vc.product = item
            let presenter: Presentr = {
                let width = ModalSize.fluid(percentage: 0.8)
                let height = ModalSize.fluid(percentage: 0.7)
                let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: (SCREEN_WIDTH * 0.1), y: (SCREEN_HEIGHT * 0.15)))
                let customType = PresentationType.custom(width: width, height: height, center: center)
                
                let presenter = Presentr(presentationType: customType)
                presenter.transitionType = TransitionType.coverVerticalFromTop
                presenter.dismissOnSwipe = true
                return presenter
            }()
            self.customPresentViewController(presenter, viewController: vc, animated: true, completion: nil)
            }) { (message, _) in
                self.endLoadingError(message!)
                self.showErrorMsg(message!)
        }
        
    }
    func editProduct(index:Int)
    {
        let item = connectionHandler.arrayOfProducts![index]

        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddEditProductViewController") as! AddEditProductViewController
        vc.itemToEdit = item
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func followingsClicked()
    {
        let vc = FollowersViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func followersClicked()
    {
        let vc = FollowingsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if connectionHandler == nil
        {
            return 0
            
        }
        if let arr = connectionHandler.arrayOfProducts
        {
            return arr.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cell(table: tableView, indexPath: indexPath)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let arr = connectionHandler.arrayOfProducts!
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailedProductViewController") as! DetailedProductViewController
        vc.product = arr[(tblView.indexPathForSelectedRow?.row)!]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "product" {
            let arr = connectionHandler.arrayOfProducts!
            let vc = segue.destination as! DetailedProductViewController
            vc.product = arr[(tblView.indexPathForSelectedRow?.row)!]
        }
    }
    //MARK: - To Be Overrided
    func currentCordinates() -> (Double?,Double?)
    {
        return (lat:nil,lng:nil)
    }
    func addBarButtons() {
        self.adjustMenuBarButton()
        self.navigationItem.rightBarButtonItem = addProductBarButton()
    }
    func tableHeader() -> UIView
    {
        let header = (Bundle.main.loadNibNamed("MyProfileHeaderView", owner: self, options: nil)?[0] as? MyProfileHeaderView)!
        header.loadUser(user: user!)
        //
        let followingViews = [header.followingLabel!,header.followingCountLabel!]
        for v in followingViews
        {
            let tap = UITapGestureRecognizer(target: self, action: #selector(MyProfileViewController.followingsClicked))
            v.isUserInteractionEnabled = true
            v.addGestureRecognizer(tap)
        }
        //
        let followerViews = [header.followersLabel!,header.followersCountLabel!]
        for v in followerViews
        {
            let tap = UITapGestureRecognizer(target: self, action: #selector(MyProfileViewController.followersClicked))
            v.isUserInteractionEnabled = true
            v.addGestureRecognizer(tap)
        }
        //
        return header
    }
    func cell(table:UITableView,indexPath:IndexPath) -> UITableViewCell
    {
        let arr = connectionHandler.arrayOfProducts!
        let item = arr[indexPath.row]
        var identifier :String
        if item.product_status == .deleted {
                identifier = "cell2"
        }else
        {
            identifier = "cell"
        }
        let cell = table.dequeueReusableCell(withIdentifier: identifier) as! OwnerProductsTableViewCell
        cell.loadProduct(item)
        cell.tagButtons(indexPath.row)
        cell.ownerVC = self
        return cell
    }
 
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
