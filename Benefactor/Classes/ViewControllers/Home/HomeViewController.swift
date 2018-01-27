//
//  HomeViewController.swift
//  Benefactor
//
//  Created by MacBook Pro on 12/31/16.
//  Copyright © 2016 Old Warriors. All rights reserved.
//

import UIKit
import SVPullToRefresh
import MisterFusion

class HomeViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    
    //MARK: Data Array
    var arrayOfCategories:[DTOCategory]?
   
    //MARK:- UI
    @IBOutlet weak var gridView: UICollectionView!
    weak var countLabel:UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        addBarButtons()
        self.addNeededObserver()
        
       
        self.title = "Category"
        self.automaticallyAdjustsScrollViewInsets = false
        
        UIApplication.shared.statusBarStyle = .default
        
        guard let flowLayout = gridView.collectionViewLayout as?
            UICollectionViewFlowLayout else {
            return
        }
        let width = (SCREEN_WIDTH / 3)
        flowLayout.itemSize = CGSize(width: width, height: width )
        //
        loadCategories()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationsConnectonHandler.getUnreadCount()
    }
    // MARK: - Methods
    func loadCategories() {
        
        startLoading()
        
        CategoryConnectionHandler.sharedInstance.requestCategories(completion: { (result) in

            self.arrayOfCategories = result as? [DTOCategory]
            if (self.arrayOfCategories?.count)! < 15
            {
                guard let flowLayout = self.gridView.collectionViewLayout as?
                    UICollectionViewFlowLayout else {
                        return
                }
                var aspect:CGFloat
                switch UIDevice.modelFromSize()
                {
                case .iPhone4:
                    aspect = 1
                case .iPhone5:
                    aspect = 1.18
                case .iPhone6:
                    aspect  = 1.2
                case .iPhone6Plus:
                    aspect = 1.225
                case .iPad:
                    aspect = 1
                case .unknown:
                    aspect = 1
                }
                let width = (SCREEN_WIDTH / 3)
                flowLayout.itemSize = CGSize(width: width, height: (width * aspect) )
            }
            self.gridView.reloadData()
            self.dismissLoading()
            
        }) { (msg,_) in
        
            if let message = msg
            {
                self.showErrorMsg(message)
            }
            
            self.endLoadingError(nil)
        }
    }
    
    func addBarButtons() {
        self.adjustMenuBarButton()
        let rightButton1 = self.searchBarButton()
        let rightButton2 = self.addProductBarButton()
        let rightButton3 = self.notificationButton()
        self.navigationItem.rightBarButtonItems = [rightButton3,rightButton1,rightButton2]
    }

    // MARK: - Actions
    // MARK: -  UICollectionViewDataSource protocol
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrayOfCategories?.count ?? 0
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath)as! HomeCollectionViewCell
        let element = arrayOfCategories![indexPath.row]
        cell.loadCategory(element, index: indexPath.row)
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "product"
        {
            let vc = segue.destination as! ProductsOfCategoryViewController
            vc.arrayOfCategories = arrayOfCategories!
            vc.selectedIndex = (gridView.indexPathsForSelectedItems?[0].row)!
        }
    }
}
extension HomeViewController
{
    //MARK:- Observer
    func addNeededObserver() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.changeNotificationsCount), name: NSNotification.Name(rawValue: NOTIFICATION_COUNT_CHANGE), object: nil)
    }
    func changeNotificationsCount() {
        let count = UIApplication.shared.applicationIconBadgeNumber
        if count == 0 {
            countLabel.isHidden = true
        }else
        {
            countLabel.isHidden = false
            countLabel.text = String(count)

        }
    }
    func notificationButton() -> UIBarButtonItem
    {
        let holder = UIView(frame:CGRect(x: 0, y: 0, width: 40, height: 40))
        let imgView = UIImageView(image: #imageLiteral(resourceName: "bell"))
        _ = holder.addLayoutSubview(imgView, andConstraints: [imgView.top |==| holder.top,
                                                          imgView.leading |==| holder.leading,
                                                          holder.width |==| imgView.width,
                                                          holder.height |==| imgView.height])
        //
        let lbl = UILabel()
        lbl.backgroundColor = .red
        lbl.font = UIFont.systemFont(ofSize: 9)
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.adjustsFontSizeToFitWidth = true
        lbl.text = "0"
        let width:CGFloat = 15
        lbl.circleView(width: width)
        _ = holder.addLayoutSubview(lbl, andConstraints: [lbl.top |==| holder.top ,
                                                          lbl.right |==| holder.right ,
                                                          lbl.width |==| width,
                                                          lbl.height |==| width])

        lbl.customizeFont()
        lbl.isHidden = true
        countLabel = lbl
        let tap = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.onNotication))
        holder.addGestureRecognizer(tap)
        let leftButton = UIBarButtonItem(customView: holder)
        leftButton.tintColor = UIColor.white
        
        return leftButton

    }
    func onNotication()
    {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotificationsViewController") as! NotificationsViewController
//        self.sideMenuController()?.setContentViewController(vc)
        self.navigationController?.setViewControllers([vc], animated: true)

    }
}
