//
//  ChatListViewController.swift
//  Benefactor
//
//  Created by Ahmed Shawky on 8/10/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit
import MisterFusion
import TBEmptyDataSet

class ChatListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    //MARK: UI
    weak var tableView :UITableView!
    //MARK: Data
    var arrayOfUsers:[DTOUser]?
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Chat"

        self.automaticallyAdjustsScrollViewInsets = false
        self.view.applyGradient(colours: [UIColor(rgba: "#51509d"), UIColor(rgba: "#2bb2ed")], locations: [0.0, 0.7])
        //
        let tbl = UITableView()
        tbl.delegate = self
        tbl.dataSource = self
        _ = self.view.addLayoutSubview(tbl, andConstraints: tbl.top |+| 64,tbl.leading |+| 0,tbl.trailing |+| 0,tbl.bottom |+| 0)
        tableView = tbl
        //
        self.tableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.tableView.rowHeight = 60
        self.tableView.separatorStyle = .none
        self.addBarButtons()
        self.view.backgroundColor = .clear
        self.view.applyGradient(colours: [UIColor(rgba: "#51509d"), UIColor(rgba: "#2bb2ed")], locations: [0.0, 0.7])
        //
        tableView.emptyDataSetDataSource = self
        tableView.emptyDataSetDelegate = self
        //
        tableView.allowsSelectionDuringEditing = false


    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if arrayOfUsers==nil {
            loadUsers()
        }
    }
    // MARK: - Methods
    func addBarButtons() {
        self.adjustMenuBarButton()
        let rightButton1 = self.searchBarButton()
        let rightButton2 = self.addProductBarButton()
        self.navigationItem.rightBarButtonItems = [rightButton1,rightButton2]
    }
    
    //MARK:- Services
    func loadUsers()
    {
        self.startLoading()
        ChatConnectionHandler().getChatUsers(completion: { (results) in
            self.dismissLoading()
            let arr = results as! [DTOUser]
            self.arrayOfUsers = arr
            self.tableView.reloadData()
        }) { (message, _) in
            self.endLoadingError(message!)
            self.showErrorMsg(message!)
        }
    }
    func deleteUser(_ user:DTOUser)
    {
        self.startLoading()
        ChatConnectionHandler().deleteChat(userID: user.user_id, completion: { (result) in
            self.dismissLoading()
            let index = self.arrayOfUsers!.index(of: user)!
            self.arrayOfUsers!.remove(at: index)
            self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: UITableViewRowAnimation.top)
        }) { (message, _) in
            if let msg = message
            {
                self.showErrorMsg(msg)
            }
            self.dismissLoading()
        }
    }
    //MARK:- TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let arr = arrayOfUsers else {
            return 0
        }
        return arr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let arr = arrayOfUsers!
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UserTableViewCell
        cell.loadItem(arr[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let arr = arrayOfUsers!
        let vc = MessageViewController()
        vc.user = arr[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            let arr = arrayOfUsers!
            let user = arr[indexPath.row]
            self.deleteUser(user)
        }
    }
    
    
}
extension ChatListViewController: TBEmptyDataSetDataSource, TBEmptyDataSetDelegate {
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
        let description = "No Active Chats"
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
        if arrayOfUsers == nil {
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activityIndicator.startAnimating()
            return activityIndicator
        }
        return nil
    }
    
    // MARK: - TBEmptyDataSet delegate
    func emptyDataSetShouldDisplay(in scrollView: UIScrollView) -> Bool {
        guard let arr = arrayOfUsers else {
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


