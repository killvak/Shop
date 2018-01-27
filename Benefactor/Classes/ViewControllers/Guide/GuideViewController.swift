//
//  GuideViewController.swift
//  Benefactor
//
//  Created by Ahmed Shawky on 9/12/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit

class GuideViewController: UIViewController {

    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    var currentIndex:Int!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        loadIndex(1)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onSkip() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let vc = appDelegate.window!.rootViewController as! RootViewController
        self.modalTransitionStyle = .coverVertical
        self.dismiss(animated: true, completion: nil)
        vc.openHomeScene()
    }
    
    @IBAction func onNext() {
        if currentIndex == 4
        {
            return
        }
        self.loadIndex(currentIndex + 1)
    }
    @IBAction func onPrevious() {
        if currentIndex == 0
        {
            return
        }
        self.loadIndex(currentIndex - 1)
    }
    
    func loadIndex(_ index:Int)
    {
        switch index {
        case 1:
            leftButton.isHidden = true
        case 2:
            leftButton.isHidden = false
        case 3:
            rightButton.isHidden = false
        case 4:
            rightButton.isHidden = true
        default:
            break
        }
        currentIndex = index
        imageView.image = UIImage(named:"\(index)")
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
