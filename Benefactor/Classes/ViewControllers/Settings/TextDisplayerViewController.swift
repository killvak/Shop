//
//  TextDisplayerViewController.swift
//  Benefactor
//
//  Created by Ahmed Shawky on 9/28/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit
import MisterFusion

class TextDisplayerViewController: UIViewController {
    weak var webView:UIWebView!
    var fileName:String!
    override func loadView()
    {
        super.loadView()
        self.view.backgroundColor = .white
        //
        let v = UIView()
        v.backgroundColor = UIColor(rgba: "#51509d")
        v.applyGradient(colours: [UIColor(rgba: "#51509d"), UIColor(rgba: "#2bb2ed")], locations: [0.0, 0.7])
        v.clipsToBounds = true
        _ = self.view.addLayoutSubview(v, andConstraints: v.top |+| 0,v.leading |+| 0,v.trailing |+| 0,v.height |==| 64)
        //
        let web = UIWebView()
        web.backgroundColor = .white
        _ = self.view.addLayoutSubview(web, andConstraints: [web.top |+| 64,web.bottom |+| 0,web.left |+| 8,web.right |-| 8])
        webView = web
        //
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.adjustBackButton()
        let url = Bundle.main.url(forResource: fileName, withExtension: "html")
        webView.loadRequest(URLRequest(url: url!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
