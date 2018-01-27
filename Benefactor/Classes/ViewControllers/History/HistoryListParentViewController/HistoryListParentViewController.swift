//
//  HistoryListParentViewController.swift
//  Benefactor
//
//  Created by MacBook Pro on 4/29/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit
import TBEmptyDataSet

class HistoryListParentViewController: UITableViewController {
    //Data
    let connectionHandler = HistoryConnectionHandler()
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.rowHeight = 123
        tableView.separatorStyle = .none
        tableView.addInfiniteScrolling {
            self.loadMoreProducts()
        }
        //
        tableView.emptyDataSetDataSource = self
        tableView.emptyDataSetDelegate = self

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if connectionHandler.arrayOfProducts==nil {
            loadProducts()
        }
    }
    //MARK:- Services
    func loadProducts()
    {
    }
    func loadMoreProducts()
    {
    }
    //MARK:- TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let arr = connectionHandler.arrayOfProducts else {
            return 0
        }
        return arr.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let arr = connectionHandler.arrayOfProducts!
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! HistoryTableViewCell
        cell.loadProduct(arr[indexPath.row])
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let arr = connectionHandler.arrayOfProducts!
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailedProductViewController") as! DetailedProductViewController
        vc.product = arr[(self.tableView.indexPathForSelectedRow?.row)!]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension HistoryListParentViewController: TBEmptyDataSetDataSource, TBEmptyDataSetDelegate {
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
        let description = "No Products"
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
        if connectionHandler.arrayOfProducts == nil {
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activityIndicator.startAnimating()
            return activityIndicator
        }
        return nil
    }
    
    // MARK: - TBEmptyDataSet delegate

    func emptyDataSetShouldDisplay(in scrollView: UIScrollView) -> Bool {
        guard let arr = connectionHandler.arrayOfProducts else {
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

