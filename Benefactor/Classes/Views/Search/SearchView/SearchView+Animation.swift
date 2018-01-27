//
//  SearchView+Animation.swift
//  Benefactor
//
//  Created by MacBook Pro on 3/18/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit

extension SearchView
{
    func configureForAnimation()
    {
        heightForSearch.constant = 0
        heightForDistance.constant = 0
        topOfSegementedHolder.constant = -heightForSegemented.constant
        tblView.isHidden = true
        self.isUserInteractionEnabled = false
        holderOfSegmented.isHidden = true
        resultBackgroundView.alpha = 0
        widthOfCancelLayout.constant = 0
    }
    func startTheAnimation()
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.heightForSearch.constant = 64
            self.animateLayouts {
                self.showDistance()
            }
            UIView.animate(withDuration: 0.6,
                           animations:{self.resultBackgroundView.alpha = 0.4})
        }
    }
    func closeTheView()
    {
        endAnimation {
            self.ownerVC.searchWillClose()
            self.removeFromSuperview()
        }
    }
    func showResult()
    {
        self.isUserInteractionEnabled = false
        topOfSegementedHolder.constant = 0
        heightForDistance.constant = 0
        widthOfCancelLayout.constant = 26
        tblView.alpha = 0
        self.showTable()

        holderOfSegmented.isUserInteractionEnabled = false
        holderOfSegmented.isHidden = false
        holderOfSegmented.alpha = 0
        
        self.animateLayouts {
            self.isUserInteractionEnabled = true
            self.holderOfSegmented.isUserInteractionEnabled = true
            self.orderData()
        }
        UIView.animate(withDuration: 0.6,
                       animations:
            {
                self.tblView.alpha = 1
                self.holderOfSegmented.alpha = 1
        })

        
    }
    func showDistance()
    {
        heightForDistance.constant = 164
        topOfSegementedHolder.constant = -heightForSegemented.constant
        holderOfSegmented.isUserInteractionEnabled = false
        holderOfSegmented.isHidden = true
        widthOfCancelLayout.constant = 0
        UIView.animate(withDuration: 0.6, animations: {
            self.tblView.alpha = 0
            self.holderOfSegmented.alpha = 0
        })
        
        self.animateLayouts {
            self.isUserInteractionEnabled = true
            self.hideTable()
        }
        
    }
    //MARK: - Helper
    fileprivate  func animateLayouts(complete:(@escaping () -> Void))
    {
        UIView.animate(withDuration: 0.6, animations: {
            self.layoutIfNeeded()
            
        }) { (done) in
            if done
            {
                complete()
            }
        }
    }
    fileprivate func endAnimation(complete:(@escaping () -> Void))
    {
        if tblView.isHidden == false {
            UIView.animate(withDuration: 0.4,
                           animations:{
                            self.tblView.alpha = 0
            })
        }
        self.closeAnimation(complete: complete)
        
    }
    fileprivate func closeAnimation(complete:(@escaping () -> Void))
    {
        heightForSearch.constant = 0
        heightForDistance.constant = 0
        topOfSegementedHolder.constant = -heightForSegemented.constant
        self.isUserInteractionEnabled = false
        holderOfSegmented.isHidden = true
        UIView.animate(withDuration: 0.5,
                       animations:{self.resultBackgroundView.alpha = 0})
        
        self.animateLayouts {
            complete()
        }
    }


}
