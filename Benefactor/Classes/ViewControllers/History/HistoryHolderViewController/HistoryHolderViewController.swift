//
//  HistoryHolderViewController.swift
//  Benefactor
//
//  Created by MacBook Pro on 4/29/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit
import HMSegmentedControl
import MisterFusion

class HistoryHolderViewController: UIViewController {
    //MARK:- UI
    @IBOutlet weak var topView: UIView!
    weak var segControl :HMSegmentedControl!
    weak var pageController : UIPageViewController!
    //VC
    var givenVC : GivenProductsViewController!
    var takenVC : TakenProductsViewController!
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "History"
        addBarButtons()
        createSegmented()
        createPageController()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    // MARK: - Actions
    func segementedValueChange(_ sender:HMSegmentedControl)
    {
        switch segControl.selectedSegmentIndex {
        case 0:
            pageController.setViewControllers([givenVC], direction: .reverse, animated: true, completion: nil)
        case 1:
            pageController.setViewControllers([takenVC], direction: .forward, animated: true, completion: nil)
        default: break
        }
    }
    // MARK: - Methods
    func addBarButtons() {
        self.adjustMenuBarButton()
        let rightButton1 = self.searchBarButton()
        //        let rightButton2 = self.addProductBarButton()
        let rightButton2 = UIBarButtonItem(image: UIImage(named:"add"), style: .plain, target: self, action: #selector(HistoryHolderViewController.addButtonClicked))
        rightButton2.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItems = [rightButton1,rightButton2]
    }
    @IBAction func addButtonClicked()
    {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddEditProductViewController") as! AddEditProductViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    func createSegmented()
    {
        let arr = ["Given","Taken"]
        let segmentedControl = HMSegmentedControl(sectionTitles: arr)!
        segmentedControl.frame = CGRect(x: 0, y: 60, width: self.view.frame.width, height: 40)
        segmentedControl.autoresizingMask = [.flexibleRightMargin , .flexibleWidth]
        segmentedControl.selectionIndicatorLocation = .down
        segmentedControl.selectionStyle = .fullWidthStripe
        segmentedControl.segmentWidthStyle = .fixed
        segmentedControl.selectionIndicatorHeight = 1
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
        segControl = segmentedControl
    }
    func createPageController()
    {
        //
        givenVC = GivenProductsViewController()
        takenVC = TakenProductsViewController()
        //
        let pageVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageVC.setViewControllers([givenVC], direction: .forward, animated: false, completion: nil)
        self.addChildViewController(pageVC)
        let viewToAdd = pageVC.view!
        _ = self.view.addLayoutSubview(viewToAdd, andConstraints: [viewToAdd.right |+| 0 ,viewToAdd.left |+| 0 ,viewToAdd.top |==| topView!.bottom ,viewToAdd.bottom |+| 0])
        pageVC.didMove(toParentViewController: self)
        //
        pageController = pageVC;
        //
        for testView in pageVC.view.subviews
        {
            if testView.isKind(of: UIScrollView.self) {
                let scroll = testView as! UIScrollView
                scroll.isScrollEnabled = false
            }
            
        }
        
    }

}
