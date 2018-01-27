//
//  SelectLocationViewController.swift
//  Benefactor
//
//  Created by MacBook Pro on 3/8/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit

public typealias SelectionBlock = (_ object:Int) -> Void

class SelectLocationViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    //MARK:- UI 
    @IBOutlet weak var tblView: UITableView!
    //MARK:- Data
    var arrayOfSelections:[String]!
    var block:SelectionBlock?
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        let leftBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(SelectLocationViewController.cancelClicked))
        leftBarButton.tintColor = .white
        self.navigationItem.leftBarButtonItem = leftBarButton
        let rightBarButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(SelectLocationViewController.doneClicked))
        rightBarButton.tintColor = .white
        self.navigationItem.rightBarButtonItem = rightBarButton
        self.navigationItem.rightBarButtonItem?.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK:- Mehtods
    func doneClicked()
    {
        let index = tblView.indexPathForSelectedRow!.row
        block?(index)
        self.backButtonClicked()
    }
    func cancelClicked()
    {
        self.backButtonClicked()
    }
    //MARK:- TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfSelections.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = arrayOfSelections[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
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
