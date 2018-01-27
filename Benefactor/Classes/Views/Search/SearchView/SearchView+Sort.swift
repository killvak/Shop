//
//  SearchView+Segmented.swift
//  Benefactor
//
//  Created by MacBook Pro on 3/18/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit

extension SearchView
{
    func orderData()
    {
        let currentIndex = self.segControl.selectedSegmentIndex
        if currentIndex == 0 {
            orderNewest()
        }else
        {
            orderCloset()
        }
    }
    fileprivate func orderNewest()
    {
        guard let arr = connectionHandler.arrayOfProducts else {
            return
        }
        connectionHandler.arrayOfProducts = arr.sorted { $0.product_id > $1.product_id }
        tblView.reloadData()
    
    }
    fileprivate func orderCloset()
    {
        guard let arr = connectionHandler.arrayOfProducts else {
            return
        }
        connectionHandler.arrayOfProducts = arr.sorted { Float($0.product_distance)! <= Float($1.product_distance)! }
        tblView.reloadData()

    }
}
