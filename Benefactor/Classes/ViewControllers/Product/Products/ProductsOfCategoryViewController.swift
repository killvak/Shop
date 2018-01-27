//
//  ProductsOfCategoryViewController.swift
//  Benefactor
//
//  Created by MacBook Pro on 2/15/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit
import HMSegmentedControl
import MisterFusion
import SVPullToRefresh
import GoogleMobileAds

class ProductsOfCategoryViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    //MARK:- UI
    weak var segControl :HMSegmentedControl!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var addButtonBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var tableViewBottomSpace: NSLayoutConstraint!

    var bannerView: GADBannerView!
    
    //MARK:- Data
    var arrayOfCategories:[DTOCategory]!
    var selectedIndex:Int = 0
    var connectionHandler:ProductConnectionHandler!
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addBarButtons()
        tblView.estimatedRowHeight =  (UIDevice.modelFromSize() == .iPad) ? 410 : 210
        tblView.rowHeight = UITableViewAutomaticDimension
        tblView.register(UINib(nibName: "ProductsRegularTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.title = "Main"
        self.automaticallyAdjustsScrollViewInsets = false
        createSegmented()
        tblView.addInfiniteScrolling {
            self.loadMoreProducts()
        }
        
        initAdMobBannar()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadProducts()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    // MARK: - Methods
    func addBarButtons() {
        self.adjustMenuBarButton()
        let rightButton1 = self.searchBarButton()
//        let rightButton2 = self.addProductBarButton()
        let rightButton2 = UIBarButtonItem(image: UIImage(named:"add"), style: .plain, target: self, action: #selector(ProductsOfCategoryViewController.addButtonClicked))
        rightButton2.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItems = [rightButton1,rightButton2]
    }

    func createSegmented()
    {
        let arr = arrayOfCategories.map({" " + $0.category_name!.capitalized + " "})
        let segmentedControl = HMSegmentedControl(sectionTitles: arr)!
        segmentedControl.frame = CGRect(x: 0, y: 60, width: self.view.frame.width, height: 40)
        segmentedControl.autoresizingMask = [.flexibleRightMargin , .flexibleWidth]
        segmentedControl.selectionIndicatorLocation = .down
        segmentedControl.selectionStyle = .textWidthStripe
        segmentedControl.segmentWidthStyle = .dynamic
        segmentedControl.selectionIndicatorHeight = 6.0
        segmentedControl.selectionIndicatorColor = UIColor.white
        segmentedControl.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white,NSFontAttributeName:UIFont(name: FONT_NAME, size: 16)!]
        segmentedControl.selectedTitleTextAttributes = [NSForegroundColorAttributeName : UIColor.white,NSFontAttributeName:UIFont(name: FONT_NAME, size: 16)!]
        segmentedControl.addTarget(self, action: #selector(ProductsOfCategoryViewController.segementedValueChange(_:)), for: .valueChanged)
        _ = topView.addLayoutSubview(segmentedControl,
                                     andConstraints: [segmentedControl.right |==| topView.right,
                                                      segmentedControl.left |==| topView.left,
                                                      segmentedControl.bottom |==| topView.bottom |-| 10,
                                                      segmentedControl.top |==| topView.top])
        segmentedControl.backgroundColor = UIColor.clear
        segmentedControl.selectedSegmentIndex = selectedIndex
        segControl = segmentedControl
    }
    func loadProducts()
    {
        connectionHandler = ProductConnectionHandler()
        tblView.dataSource = self
        tblView.delegate = self
        tblView.reloadData()
        self.startLoading()
        connectionHandler.requestProducts(categoryID: arrayOfCategories[selectedIndex].category_ID!, lat: LocationHandler.latitude, lng: LocationHandler.longitude, completion: { (_) in
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

        connectionHandler.requestProducts(categoryID: arrayOfCategories[selectedIndex].category_ID!, lat: LocationHandler.latitude, lng: LocationHandler.longitude, completion: { (_) in
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
    func segementedValueChange(_ sender:HMSegmentedControl)
    {
        selectedIndex = sender.selectedSegmentIndex
        loadProducts()
    }
    @IBAction func addButtonClicked()
    {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddEditProductViewController") as! AddEditProductViewController
        vc.preSelectedCategryIndex = segControl.selectedSegmentIndex
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
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "product" {
            let arr = connectionHandler.arrayOfProducts!
            let vc = segue.destination as! DetailedProductViewController
            vc.product = arr[(tblView.indexPathForSelectedRow?.row)!]
        }
    }
}


extension ProductsOfCategoryViewController: GADBannerViewDelegate {

    func adViewDidReceiveAd(_ bannerView: GADBannerView) {

        bannerView.alpha = 0

        view.addSubview(bannerView)
        
        UIView.animate(withDuration: 0.4, animations: {
        
            bannerView.alpha = 1
            
            self.addButtonBottomSpace.constant = bannerView.frame.size.height
            self.tableViewBottomSpace.constant = bannerView.frame.size.height
            
            self.view.layoutIfNeeded()
        })
    }
}
