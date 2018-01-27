//
//  TakenProductsViewController.swift
//  Benefactor
//
//  Created by MacBook Pro on 4/29/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit


class TakenProductsViewController: HistoryListParentViewController {
    //MARK:- Services
    override func loadProducts()
    {
        self.startLoading()
        connectionHandler.getTakenProducts(completion: { (result) in
            self.tableView.reloadData()
            self.dismissLoading()
        }) { (message, _) in
            self.endLoadingError(message!)
            self.showErrorMsg(message!)
        }
    }
    override func loadMoreProducts()
    {
        if !(connectionHandler.hasMoreData)
        {
            self.tableView.showsInfiniteScrolling = false
            return
        }
        connectionHandler.getTakenProducts(completion: { (result) in
            self.tableView.reloadData()
            self.dismissLoading()
            self.tableView.infiniteScrollingView.stopAnimating()
            if !(self.connectionHandler.hasMoreData)
            {
                self.tableView.showsInfiniteScrolling = false
            }
        }) { (message, _) in
            self.endLoadingError(message!)
            self.showErrorMsg(message!)
        }
    }
}
