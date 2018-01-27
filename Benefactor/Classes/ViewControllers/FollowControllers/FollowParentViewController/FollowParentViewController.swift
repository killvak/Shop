//
//  FollowParentViewController.swift
//  Benefactor
//
//  Created by Ahmed Shawky on 7/22/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit
import MisterFusion

class FollowParentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    //MARK: UI
    weak var tableView :UITableView!
    //MARK: Data
    var connectionHandler:UserConnectionHandler = UserConnectionHandler()
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
        self.tableView.addInfiniteScrolling {
            self.loadMoreProducts()
        }
        self.adjustBackButton()
        //

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if connectionHandler.arrayOfUsers==nil {
            loadProducts()
        }
    }
    // MARK: - Methods
    func addBarButtons() {
        self.adjustMenuBarButton()
        let rightButton1 = self.searchBarButton()
        //        let rightButton2 = self.addProductBarButton()
        let rightButton2 = UIBarButtonItem(image: UIImage(named:"add"), style: .plain, target: self, action: #selector(FollowParentViewController.addButtonClicked))
        rightButton2.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItems = [rightButton1,rightButton2]
    }
    @IBAction func addButtonClicked()
    {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddEditProductViewController") as! AddEditProductViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }


    //MARK:- Services
    func loadProducts()
    {
    }
    func loadMoreProducts()
    {
    }
    //MARK:- TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let arr = connectionHandler.arrayOfUsers else {
            return 0
        }
        return arr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let arr = connectionHandler.arrayOfUsers!
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UserTableViewCell
        cell.loadItem(arr[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let arr = connectionHandler.arrayOfUsers!
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
        vc.userID = arr[indexPath.row].user_id
        self.navigationController?.pushViewController(vc, animated: true)
    }


}
