//
//  SearchView+Slide.swift
//  Benefactor
//
//  Created by MacBook Pro on 3/18/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit
import HMSegmentedControl

extension SearchView:UITextFieldDelegate
{
    func segementedValueChange(_ sender:HMSegmentedControl)
    {
//        selectedIndex = sender.selectedSegmentIndex
        //        loadProducts()
        orderData()
    }
    @IBAction func sliderChanged(_ sender: UISlider) {
        let value = Int(sender.value)
        distanceValueLabel.text = String(value)
    }
    @IBAction func searchActionClicked()
    {
        guard let searchTxt = txtField.text else {
            return
        }
        if searchTxt.replacingOccurrences(of: " ", with: "").isEmpty {
            return
        }
        loadProducts()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if tblView.isHidden == false
        {
            self.showDistance()
        }
    }
    @IBAction func cancelClicked(_ sender: AnyObject) {
        closeTheView()
    }
    @IBAction func clearClicked(_ sender: AnyObject) {
        self.txtField.text = ""
        if tblView.isHidden == false
        {
            self.showDistance()
        }

    }

    

}
