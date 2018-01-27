//
//  CustomPresentedNavigationController.swift
//  Benefactor
//
//  Created by MacBook Pro on 4/1/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit

class CustomPresentedNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.applyGradient(colours: [UIColor(rgba: "#51509d"), UIColor(rgba: "#2bb2ed")], locations: [0.0, 0.7])
        adjustNavigationBar()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func adjustNavigationBar()
    {
        let titleFontSize : CGFloat = (UIDevice.modelFromSize() == .iPad) ? 22 : 18
        let nav = self
//        nav.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        nav.navigationBar.shadowImage = UIImage()
        nav.navigationBar.isTranslucent = true
        nav.navigationBar.backgroundColor = UIColor.white
        nav.view.backgroundColor = UIColor.white
        nav.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(rgba:"#6AC2AA"),NSFontAttributeName:UIFont(name: FONT_NAME, size: titleFontSize)!]
        
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
