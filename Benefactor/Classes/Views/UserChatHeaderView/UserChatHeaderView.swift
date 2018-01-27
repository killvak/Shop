//
//  UserChatHeaderView.swift
//  Benefactor
//
//  Created by Ahmed Shawky on 8/15/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit
import MisterFusion

class UserChatHeaderView: UIView {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fromNib()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        fromNib()
    }
    convenience init() {
        self.init(frame: CGRect.zero)
    }

    @discardableResult   // 1
    func fromNib<T : UIView>() -> T? {   // 2
        guard let view = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?[0] as? T else {    // 3
            // xib not loaded, or it's top view is of the wrong type
            return nil
        }
        _ = self.addLayoutSubview(view, andConstraints:
            view.top |+| 0,view.right |-| 0, view.left |+| 0,view.bottom |-| 0
        )
        return view   // 7
    }
    func loadUser(_ user:DTOUser)
    {
//            cityLabel.text = user.user_cityName
        let name = user.displayName
        print("user.displayName " + name)
        userNameLabel.text = name
        let text = userNameLabel.text ?? "nil"
        print("userNameLabel.text " + text )

        if let image = user.user_image
        {
            imgView.imageProfile(fromString: image)
        }else
        {
            imgView.image = UIImage(named:"defaultImage")
        }

    }

}
