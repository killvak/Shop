//
//  SearchView+Services.swift
//  Benefactor
//
//  Created by MacBook Pro on 3/18/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit

extension SearchView
{
    func loadProducts()
    {
        self.endEditing(true)
        connectionHandler = SearchConnectionHandler()
        tblView.dataSource = self
        tblView.delegate = self
        tblView.reloadData()
        ownerVC.startLoading()
        connectionHandler.searchProducts(text: txtField.text!, distance: Int(slider.value), lat: LocationHandler.latitude, lng: LocationHandler.longitude, completion: { (_) in
            self.showResult()
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
        
        connectionHandler.searchProducts(text: txtField.text!, distance: Int(slider.value), lat: LocationHandler.latitude, lng: LocationHandler.longitude, completion: { (_) in
            self.orderData()
//            self.tblView.reloadData()
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
}
