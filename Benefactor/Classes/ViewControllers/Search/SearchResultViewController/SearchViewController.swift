//
//  SearchView.swift
//  Benefactor
//
//  Created by MacBook Pro on 3/15/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit
import HMSegmentedControl
import MisterFusion
import SVPullToRefresh

class SearchView: UIView,UITableViewDataSource,UITableViewDelegate {
    //MARK:- UI
    weak var segControl :HMSegmentedControl!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var holderOfSegmented: UIView!
    @IBOutlet weak var holderOfSearch: UIView!
    @IBOutlet weak var holderOfDistance: UIView!
    @IBOutlet weak var heightForSearch: NSLayoutConstraint!
    @IBOutlet weak var heightForDistance: NSLayoutConstraint!
    @IBOutlet weak var heightForSegemented: NSLayoutConstraint!
    @IBOutlet weak var topOfSegementedHolder: NSLayoutConstraint!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var distanceValueLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    var isFirstAppear = true
    //MARK:- Data
    var selectedIndex:Int = 0
    var connectionHandler:SearchConnectionHandler!
    weak var ownerVC:SlideNavigationController!
    //MARK:- LifeCycle
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        tblView.estimatedRowHeight =  (UIDevice.modelFromSize() == .iPad) ? 410 : 210
        tblView.rowHeight = UITableViewAutomaticDimension
        //        self.title = "Main"
        //        self.automaticallyAdjustsScrollViewInsets = false
        createSegmented()
        holderOfSearch.applyGradient(colours: [UIColor(rgba: "#51509d"), UIColor(rgba: "#2bb2ed")], locations: [0.0, 0.1])
//        tblView.addInfiniteScrolling {
//                        self.loadMoreProducts()
//        }
        //
        configureForAnimation()
        startTheAnimation()

    }
    deinit
    {
    
    }
    func configureForAnimation()
    {
        heightForSearch.constant = 0
        heightForDistance.constant = 0
        topOfSegementedHolder.constant = -heightForSegemented.constant
        self.isUserInteractionEnabled = false
    }
    @IBAction func sliderChanged(_ sender: UISlider) {
        let value = sender.value * 50
        distanceValueLabel.text = String(value)
    }
    func startTheAnimation()
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.heightForSearch.constant = 64
            self.animateLayouts {
                self.showDistance()
            }
        }
    }
    func showResult()
    {
    }
    func showDistance()
    {
        heightForDistance.constant = 120
        topOfSegementedHolder.constant = -heightForSegemented.constant
        holderOfSegmented.isUserInteractionEnabled = false
        self.animateLayouts {
            self.isUserInteractionEnabled = true
        }

    }
    func animateLayouts(complete:(@escaping () -> Void))
    {
        UIView.animate(withDuration: 0.3, animations: {
            self.layoutIfNeeded()
            
        }) { (done) in
            if done
            {
                complete()
            }
        }
    }
    // MARK: - Methods
    func createSegmented()
    {
        let arr = ["Distance","Latest"];
        let segmentedControl = HMSegmentedControl(sectionTitles: arr)!
        segmentedControl.frame = CGRect(x: 0, y: 60, width: self.frame.width, height: 40)
        segmentedControl.autoresizingMask = [.flexibleRightMargin , .flexibleWidth]
        segmentedControl.selectionIndicatorLocation = .down
        segmentedControl.selectionStyle = .fullWidthStripe
        segmentedControl.segmentWidthStyle = .fixed
        segmentedControl.selectionIndicatorHeight = 6.0
        segmentedControl.selectionIndicatorColor = UIColor.white
        segmentedControl.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white,NSFontAttributeName:UIFont(name: FONT_NAME, size: 19)!]
        segmentedControl.selectedTitleTextAttributes = [NSForegroundColorAttributeName : UIColor.white,NSFontAttributeName:UIFont(name: FONT_NAME, size: 19)!]
        segmentedControl.addTarget(self, action: #selector(SearchView.segementedValueChange(_:)), for: .valueChanged)
        _ = holderOfSegmented.addLayoutSubview(segmentedControl,
                                     andConstraints: [segmentedControl.right |==| holderOfSegmented.right,
                                                      segmentedControl.left |==| holderOfSegmented.left,
                                                      segmentedControl.bottom |==| holderOfSegmented.bottom |-| 10,
                                                      segmentedControl.top |==| holderOfSegmented.top])
        segmentedControl.backgroundColor = UIColor.clear
        segmentedControl.selectedSegmentIndex = selectedIndex
        segControl = segmentedControl
    }
    func loadProducts()
    {
        connectionHandler = SearchConnectionHandler()
        tblView.dataSource = self
        tblView.delegate = self
        tblView.reloadData()
        ownerVC.startLoading()
        connectionHandler.searchProducts(text: "t", distance: 100, lat: 30.050586, lng: 31.318688, completion: { (_) in
            self.tblView.reloadData()
            self.ownerVC.dismissLoading()
        }) { (message, _) in
            self.ownerVC.endLoadingError(message!)
            self.ownerVC.showErrorMsg(message!)
        }
    }
    func loadMoreProducts()
    {
        if !(self.connectionHandler?.hasMoreData)!
        {
            self.tblView.showsInfiniteScrolling = false
            return
        }
        
        connectionHandler.searchProducts(text: "t", distance: 100, lat: 30.050586, lng: 31.318688, completion: { (_) in
            self.tblView.reloadData()
            self.ownerVC.dismissLoading()
            self.tblView.infiniteScrollingView.stopAnimating()
            if !(self.connectionHandler?.hasMoreData)!
            {
                self.tblView.showsInfiniteScrolling = false
            }
        }) { (message, _) in
            self.ownerVC.endLoadingError(message!)
            self.ownerVC.showErrorMsg(message!)
        }
        
    }
    // MARK: - Actions
    func segementedValueChange(_ sender:HMSegmentedControl)
    {
        selectedIndex = sender.selectedSegmentIndex
//        loadProducts()
    }
//    @IBAction func addButtonClicked()
//    {
//        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddEditProductViewController") as! AddEditProductViewController
//        vc.preSelectedCategryIndex = segControl.selectedSegmentIndex
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
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
    // MARK: - Navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "product" {
//            let arr = connectionHandler.arrayOfProducts!
//            let vc = segue.destination as! DetailedProductViewController
//            vc.product = arr[(tblView.indexPathForSelectedRow?.row)!]
//        }
//    }
    
}
