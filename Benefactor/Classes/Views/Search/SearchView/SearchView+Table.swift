//
//  SearchView+Table.swift
//  Benefactor
//
//  Created by MacBook Pro on 3/18/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit

extension SearchView:UITableViewDataSource,UITableViewDelegate
{
    func showTable()
    {
        self.tblView.isHidden = false
    }
    func hideTable()
    {
        self.tblView.isHidden = true
        
    }
    func configureTable()
    {
        tblView.addInfiniteScrolling {
            self.loadMoreProducts()
        }
        self.tblView.register(UINib(nibName: "ProductSearchTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        tblView.estimatedRowHeight =  141
        tblView.rowHeight = UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let arr = connectionHandler.arrayOfProducts
        {
            return arr.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let arr = connectionHandler.arrayOfProducts!
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ProductSearchTableViewCell
        cell.loadProduct(arr[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let arr = connectionHandler.arrayOfProducts!
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailedProductViewController") as! DetailedProductViewController
        vc.product = arr[(tblView.indexPathForSelectedRow?.row)!]
        let nav = CustomPresentedNavigationController(rootViewController: vc)
        self.ownerVC.present(nav, animated: true, completion: nil)
    }
}
