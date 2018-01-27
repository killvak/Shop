//
//  UserFavoritesViewController.swift
//  Benefactor
//
//  Created by MacBook Pro on 3/10/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit
import SVPullToRefresh

class UserFavoritesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    //MARK:- UI
    @IBOutlet weak var tblView: UITableView!
    //MARK:- Data
    var connectionHandler:ProductConnectionHandler!
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addBarButtons()
        tblView.estimatedRowHeight =  (UIDevice.modelFromSize() == .iPad) ? 410 : 210
        tblView.rowHeight = UITableViewAutomaticDimension
        tblView.register(UINib(nibName: "ProductsRegularTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.title = "Favorites"
        self.automaticallyAdjustsScrollViewInsets = false
        tblView.addInfiniteScrolling {
            self.loadMoreProducts()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadProducts()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // MARK: - Methods
    func addBarButtons() {
        self.adjustMenuBarButton()
        let rightButton1 = self.searchBarButton()
        //        let rightButton2 = self.addProductBarButton()
        let rightButton2 = UIBarButtonItem(image: UIImage(named:"add"), style: .plain, target: self, action: #selector(UserFavoritesViewController.addButtonClicked))
        rightButton2.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItems = [rightButton1,rightButton2]
    }

    func loadProducts()
    {
        connectionHandler = ProductConnectionHandler()
        tblView.dataSource = self
        tblView.delegate = self
        tblView.reloadData()
        self.startLoading()
        connectionHandler.requestFavoriteProducts(ownerID: (DTOUser.currentUser()!.user_id)!, lat: LocationHandler.latitude, lng: LocationHandler.longitude, completion: { (_) in
            self.tblView.reloadData()
            self.dismissLoading()
        }) { (message, _) in
            self.endLoadingError(message!)
            self.showErrorMsg(message!)
        }
    }
    func loadMoreProducts()
    {
        if !(self.connectionHandler?.hasMoreData)!
        {
            self.tblView.showsInfiniteScrolling = false
            return
        }
        
        connectionHandler.requestFavoriteProducts(ownerID: (DTOUser.currentUser()!.user_id)!, lat: LocationHandler.latitude, lng: LocationHandler.longitude, completion: { (_) in
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
    // MARK: - Actions
    @IBAction func addButtonClicked()
    {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddEditProductViewController") as! AddEditProductViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let arr = connectionHandler.arrayOfProducts
        {
            return arr.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let arr = connectionHandler.arrayOfProducts!
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ProductsRegularTableViewCell
        cell.loadProduct(arr[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let arr = connectionHandler.arrayOfProducts!
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailedProductViewController") as! DetailedProductViewController
        vc.product = arr[(tblView.indexPathForSelectedRow?.row)!]
        self.navigationController?.pushViewController(vc, animated: true)
    }
//    // MARK: - Navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "product" {
//            let arr = connectionHandler.arrayOfProducts!
//            let vc = segue.destination as! DetailedProductViewController
//            vc.product = arr[(tblView.indexPathForSelectedRow?.row)!]
//        }
//    }

}
