//
//  SearchView.swift
//  Benefactor
//
//  Created by MacBook Pro on 3/18/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit
import HMSegmentedControl
import SVPullToRefresh
class SearchView: UIView {
    //MARK:- UI
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var txtField: UITextField!
    weak var segControl :HMSegmentedControl!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var holderOfSegmented: UIView!
    @IBOutlet weak var holderOfSearch: UIView!
    @IBOutlet weak var holderOfDistance: UIView!
    @IBOutlet weak var heightForSearch: NSLayoutConstraint!
    @IBOutlet weak var heightForDistance: NSLayoutConstraint!
    @IBOutlet weak var heightForSegemented: NSLayoutConstraint!
    @IBOutlet weak var topOfSegementedHolder: NSLayoutConstraint!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var distanceValueLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var resultBackgroundView: UIView!
    @IBOutlet weak var widthOfCancelLayout: NSLayoutConstraint!
    //MARK:- Data
    var connectionHandler:SearchConnectionHandler!
    //MARK:- VC refference
    weak var ownerVC:SlideNavigationController!
    override func awakeFromNib() {
        super.awakeFromNib()
        adjustOutlets()
        configureForAnimation()
        startTheAnimation()
    }

}
