//
//  NotificationsViewController.swift
//  Benefactor
//
//  Created by MacBook Pro on 6/4/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit
import SVPullToRefresh
import Presentr
import TBEmptyDataSet

class NotificationsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    //Outlet
    @IBOutlet weak var tblView: UITableView!
    //Data
    var connectionHandler = NotificationsConnectonHandler()
    var selectedUser:DTOUser?
    var selectedProduct:DTOProduct?
    var selectedType:NotificationType?
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Notification"
        self.automaticallyAdjustsScrollViewInsets = false
        addBarButtons()
        //
        tblView.separatorStyle = .none
        tblView.addInfiniteScrolling {
            self.loadMoreData()
        }
        //
        tblView.emptyDataSetDataSource = self
        tblView.emptyDataSetDelegate = self

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if connectionHandler.arrayOfData==nil {
            loadData()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: - Methods
    func addBarButtons() {
        self.adjustMenuBarButton()
        let rightButton1 = self.searchBarButton()
        //        let rightButton2 = self.addProductBarButton()
        let rightButton2 = UIBarButtonItem(image: UIImage(named:"add"), style: .plain, target: self, action: #selector(NotificationsViewController.addButtonClicked))
        rightButton2.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItems = [rightButton1,rightButton2]
    }
    @IBAction func addButtonClicked()
    {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddEditProductViewController") as! AddEditProductViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func loadData()
    {
        connectionHandler = NotificationsConnectonHandler()
        tblView.reloadData()
        self.startLoading()
        connectionHandler.retrieveNotifications(completion: { (results) in
            self.dismissLoading()
            self.tblView.reloadData()
            self.displayPushNotificationIfNeeded()
        }) { (message, _) in
            self.dismissLoading()
            self.showErrorMsg(message!)
            self.displayPushNotificationIfNeeded()
        }
    }
    func displayPushNotificationIfNeeded()
    {
        guard let type = selectedType else
        {
            selectedUser = nil
            selectedProduct = nil
            return
        }
        switch type {
        case .request:
            openRequested(notifiyUser: selectedUser, notifyProduct: selectedProduct)
        case .response:
            openResponse(notifiyUser: selectedUser, notifyProduct: selectedProduct)
        case .chat:
            break
        case .none:
            break
        }
        selectedUser = nil
        selectedProduct = nil
        selectedType = nil

    }
    func loadMoreData()
    {
        if !(connectionHandler.hasMoreData)
        {
            self.tblView.showsInfiniteScrolling = false
            return
        }
        connectionHandler.retrieveNotifications(completion: { (results) in
            self.tblView.reloadData()
            self.dismissLoading()
            self.tblView.infiniteScrollingView.stopAnimating()
            if !(self.connectionHandler.hasMoreData)
            {
                self.tblView.showsInfiniteScrolling = false
            }
        }) { (message, _) in
            self.dismissLoading()
            self.showErrorMsg(message!)
        }
    }

    //MARK:  Response
    func openResponse(notifiyUser:DTOUser?,notifyProduct:DTOProduct?)
    {
        guard let sender = notifiyUser , let item = notifyProduct  else {
            return
        }
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TakenItemViewController") as! TakenItemViewController
        vc.user = sender
        vc.product = item
        let presenter: Presentr = {
            let width = ModalSize.fluid(percentage: 0.8)
            let height = ModalSize.fluid(percentage: 0.6)
            let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: (SCREEN_WIDTH * 0.1), y: (SCREEN_HEIGHT * 0.2)))
            let customType = PresentationType.custom(width: width, height: height, center: center)
            
            let presenter = Presentr(presentationType: customType)
            presenter.transitionType = TransitionType.coverVerticalFromTop
            presenter.dismissOnSwipe = true
            return presenter
        }()
        self.customPresentViewController(presenter, viewController: vc, animated: true, completion: nil)
        
    }
    //MARK:  Requested
    func openRequested(notifiyUser:DTOUser?,notifyProduct:DTOProduct?)
    {
        guard let sender = notifiyUser , let item = notifyProduct  else {
            return
        }
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RequestedItemViewController") as! RequestedItemViewController
        vc.user = sender
        vc.product = item
        vc.ownerVC = self
        let presenter: Presentr = {
            let width = ModalSize.fluid(percentage: 0.8)
            let height = ModalSize.fluid(percentage: 0.5)
            let center = ModalCenterPosition.customOrigin(origin: CGPoint(x: (SCREEN_WIDTH * 0.1), y: (SCREEN_HEIGHT * 0.25)))
            let customType = PresentationType.custom(width: width, height: height, center: center)
            
            let presenter = Presentr(presentationType: customType)
            presenter.transitionType = TransitionType.coverVerticalFromTop
            presenter.dismissOnSwipe = true
            return presenter
        }()
        self.customPresentViewController(presenter, viewController: vc, animated: true, completion: nil)

    }
    func acceptRequest(_ chatUser:DTOUser)
    {
        let vc = MessageViewController()
        vc.user = chatUser
        self.navigationController?.pushViewController(vc, animated: true)

    }
    // MARK: - Table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let arr = connectionHandler.arrayOfData
        {
            return arr.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NotificationTableViewCell
        let item = connectionHandler.arrayOfData![indexPath.row]
        cell.loadItem(item: item)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = connectionHandler.arrayOfData![indexPath.row]
        switch item.notification_type {
        case .request:
            openRequested(notifiyUser: item.notification_sender, notifyProduct: item.notification_product)
        case .response:
            openResponse(notifiyUser: item.notification_sender, notifyProduct: item.notification_product)
        case .chat:
            break
        case .none:
            break
        }
    }
    deinit {
        if DTOUser.currentUser() != nil
        {
            NotificationsConnectonHandler.getUnreadCount()
        }
    }
}
extension NotificationsViewController: TBEmptyDataSetDataSource, TBEmptyDataSetDelegate {
    // MARK: - TBEmptyDataSet data source
    func imageForEmptyDataSet(in scrollView: UIScrollView) -> UIImage? {
        return nil
    }
    
    func titleForEmptyDataSet(in scrollView: UIScrollView) -> NSAttributedString? {
        //        let title = "No Data"
        //        var attributes: [String: Any]?
        //            attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 24),
        //                          NSForegroundColorAttributeName: UIColor.gray]
        ////        }
        return nil
    }
    
    func descriptionForEmptyDataSet(in scrollView: UIScrollView) -> NSAttributedString? {
        let description = "No Notifications"
        var attributes: [String: Any]?
        //        if indexPath.row == 1 {
        //            attributes = [.font: UIFont.systemFont(ofSize: 17),
        //                          .foregroundColor: UIColor(red: 3 / 255, green: 169 / 255, blue: 244 / 255, alpha: 1)]
        //        } else if indexPath.row == 2 {
        attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 18),
                      NSForegroundColorAttributeName: UIColor.black]
        //        }
        return NSAttributedString(string: description, attributes: attributes)
    }
    
    func verticalOffsetForEmptyDataSet(in scrollView: UIScrollView) -> CGFloat {
        if let navigationBar = navigationController?.navigationBar {
            return -navigationBar.frame.height * 0.75
        }
        return 0
    }
    
    func verticalSpacesForEmptyDataSet(in scrollView: UIScrollView) -> [CGFloat] {
        return [25, 8]
    }
    
    func customViewForEmptyDataSet(in scrollView: UIScrollView) -> UIView? {
        if connectionHandler.arrayOfData == nil {
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activityIndicator.startAnimating()
            return activityIndicator
        }
        return nil
    }
    
    // MARK: - TBEmptyDataSet delegate
    func emptyDataSetShouldDisplay(in scrollView: UIScrollView) -> Bool {
        guard let arr = connectionHandler.arrayOfData else {
            return false
        }
        return arr.count == 0
    }
    
    func emptyDataSetTapEnabled(in scrollView: UIScrollView) -> Bool {
        return false
    }
    
    func emptyDataSetScrollEnabled(in scrollView: UIScrollView) -> Bool {
        return false
    }
    func emptyDataSetDidTapEmptyView(in scrollView: UIScrollView) {
        let alert = UIAlertController(title: nil, message: "Did Tap EmptyDataView!", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func emptyDataSetWillAppear(in scrollView: UIScrollView) {
        print("EmptyDataSet Will Appear!")
    }
    
    func emptyDataSetDidAppear(in scrollView: UIScrollView) {
        print("EmptyDataSet Did Appear!")
    }
    
    func emptyDataSetWillDisappear(in scrollView: UIScrollView) {
        print("EmptyDataSet Will Disappear!")
    }
    
    func emptyDataSetDidDisappear(in scrollView: UIScrollView) {
        print("EmptyDataSet Did Disappear!")
    }
}
