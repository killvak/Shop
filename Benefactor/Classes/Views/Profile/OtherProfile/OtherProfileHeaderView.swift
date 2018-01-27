//
//  ProfileHeaderView.swift
//  Benefactor
//
//  Created by MacBook Pro on 2/16/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit

class OtherProfileHeaderView: UIView {

    @IBOutlet weak var firstSlideView: ImageProfileInnerView!
    @IBOutlet weak var viewCountLabel: UILabel!
    @IBOutlet weak var viewLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    func loadUser(user:DTOUser)
    {
        self.followersCountLabel.text = "\(user.user_followersCount!)"
        self.followingCountLabel.text = "\(user.user_followingCount!)"
        self.viewCountLabel.text = "\(user.user_viewsCount!)"
        firstSlideView.loadUser(user: user)

    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
