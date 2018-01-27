//
//  FollowingsViewController.swift
//  Benefactor
//
//  Created by Ahmed Shawky on 7/22/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit

class FollowingsViewController: FollowParentViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Followers"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func loadProducts()
    {
        self.startLoading()
        connectionHandler.getFollowings(completion: { (result) in
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
        connectionHandler.getFollowings(completion: { (result) in
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
