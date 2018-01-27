//
//  NumbersProfileInnerView.swift
//  Benefactor
//
//  Created by MacBook Pro on 2/16/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit

class NumbersProfileInnerView: UIView {

    @IBOutlet weak var whistCountLabel: UILabel!
    @IBOutlet weak var wishLabel: UILabel!
    @IBOutlet weak var givenCountLabel: UILabel!
    @IBOutlet weak var givenLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followerLabels: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    func loadUser(user:DTOUser)
    {
        whistCountLabel.text = "\(user.user_whishCount!)"
        givenCountLabel.text = "\(user.user_givenCount!)"
        followersCountLabel.text = "\(user.user_takenCount!)"
    }

    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
