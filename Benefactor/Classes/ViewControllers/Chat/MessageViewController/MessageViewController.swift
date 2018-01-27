//
//  MessageViewController.swift
//  Benefactor
//
//  Created by Ahmed Shawky on 8/10/17.
//  Copyright © 2017 Old Warriors. All rights reserved.
//

import UIKit
import SlackTextViewController
import SVPullToRefresh
import MisterFusion

class MessageViewController: SLKTextViewController {
    var user:DTOUser!
    var connectionHandler = ChatConnectionHandler()
    override var tableView: UITableView {
        get {
            return super.tableView!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.edgesForExtendedLayout = UIRectEdge()
        self.adjustBackButton()
        //
        self.view.backgroundColor = UIColor(rgba:"#F6F6F6")
        //
        self.tableView.separatorStyle = .none
        
        self.tableView.register(UINib(nibName: "ChatTableViewCell", bundle: nil), forCellReuseIdentifier: "cell1")
        self.tableView.register(UINib(nibName: "ChatTableViewCell_user", bundle: nil), forCellReuseIdentifier: "cell2")
        self.tableView.bounces = true
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.backgroundColor = UIColor.clear
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        tableView.addInfiniteScrolling {
            self.loadMoreData()
        }
        //
        self.leftButton.setTitle("send", for: .normal)
        self.leftButton.tintColor = UIColor.gray
        //
        let v = UIView()
        v.backgroundColor = UIColor(rgba: "#51509d")
        v.applyGradient(colours: [UIColor(rgba: "#51509d"), UIColor(rgba: "#2bb2ed")], locations: [0.0, 0.7])
        v.clipsToBounds = true
        _ = self.view.addLayoutSubview(v, andConstraints: v.top |+| 0,v.leading |+| 0,v.trailing |+| 0,v.height |==| 64)
        //
        let v2 = UserChatHeaderView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(MessageViewController.openUserProfile))
        v2.addGestureRecognizer(tap)
        _ = self.view.addLayoutSubview(v2, andConstraints: v2.top |==| v.bottom,v2.leading |+| 0,v2.trailing |+| 0,v2.height |==| 60)
        v2.loadUser(self.user)
        loadData()
        
    }
    //    override func viewWillAppear(_ animated: Bool) {
    ////        self.automaticallyAdjustsScrollViewInsets = false
    //        var edges = self.tableView.contentInset
    //        edges.top = edges.top + 66
    //        self.tableView.contentInset = edges
    //        self.tableView.scrollIndicatorInsets = edges
    //    }
    func loadData()
    {
        if connectionHandler.arrayOfData != nil
        {
            connectionHandler = ChatConnectionHandler()
        }
        self.startLoading()
        
        connectionHandler.getChatHistory(userID: user.user_id, completion: { (result) in
            self.tableView.reloadData()
            self.dismissLoading()
            
        }) { (message, _) in
            self.endLoadingError(message!)
            self.showErrorMsg(message!)
            
        }
        
    }
    func newNotificationMessage(text:String,sender:DTOUser)
    {
        if sender.user_id == self.user.user_id
        {
            let newMsg = DTOMessage(notificationMessage: text)
            connectionHandler.arrayOfData?.insert(newMsg, at: 0)
            self.tableView.reloadData()
        }
    }
    func openUserProfile()
    {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserProfileViewController") as! UserProfileViewController
        vc.userID = self.user.user_id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func loadMoreData()
    {
        if !(self.connectionHandler.hasMoreData)
        {
            self.tableView.showsInfiniteScrolling = false
            return
        }
        
        connectionHandler.getChatHistory(userID: user.user_id, completion: { (result) in
            self.tableView.reloadData()
            self.dismissLoading()
            self.tableView.infiniteScrollingView.stopAnimating()
            if !(self.connectionHandler.hasMoreData)
            {
                self.tableView.showsInfiniteScrolling = false
            }
        }) { (message, _) in
            self.endLoadingError(message!)
            self.showErrorMsg(message!)
        }
        
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 124
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = UIColor.clear
        return v
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let messages = connectionHandler.arrayOfData!
        let item = messages[indexPath.row]
        let isReceived = item.messageType == .receive
        let iden = (isReceived) ? "cell2" : "cell1"
        let cell = self.tableView.dequeueReusableCell(withIdentifier: iden) as! ChatTableViewCell
        cell.loadItem(message: item, user: (isReceived) ? self.user : DTOUser.currentUser()!)
        //        if isReceived
        //        {
        //            cell.textLabel?.text = "\(self.user.user_name!)\n\(item.messageText!)"
        //
        //        }else
        //        {
        //            let myUser = DTOUser.currentUser()!
        //            cell.textLabel?.text = "\(myUser.user_name!)\n\(item.messageText!)"
        //        }
        //        cell.textLabel?.text = "Bla\nBla\nBla\n"
        cell.textLabel?.numberOfLines = 0
        cell.backgroundColor = UIColor.clear
        cell.transform = self.tableView.transform
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return 100
        guard let messages = connectionHandler.arrayOfData else
        {
            return 0
        }
        return messages.count
    }
    override func ignoreTextInputbarAdjustment() -> Bool {
        return super.ignoreTextInputbarAdjustment()
    }
    
    override func forceTextInputbarAdjustment(for responder: UIResponder!) -> Bool {
        
        if #available(iOS 8.0, *) {
            guard let _ = responder as? UIAlertController else {
                // On iOS 9, returning YES helps keeping the input view visible when the keyboard if presented from another app when using multi-tasking on iPad.
                return UIDevice.current.userInterfaceIdiom == .pad
            }
            return true
        }
        else {
            return UIDevice.current.userInterfaceIdiom == .pad
        }
    }
    
    // Notifies the view controller that the keyboard changed status.
    override func didChangeKeyboardStatus(_ status: SLKKeyboardStatus) {
        switch status {
        case .willShow:
            print("Will Show")
        case .didShow:
            print("Did Show")
        case .willHide:
            print("Will Hide")
        case .didHide:
            print("Did Hide")
        }
    }
    
    // Notifies the view controller that the text will update.
    override func textWillUpdate() {
        super.textWillUpdate()
    }
    
    // Notifies the view controller that the text did update.
    override func textDidUpdate(_ animated: Bool) {
        super.textDidUpdate(animated)
    }
    
    // Notifies the view controller when the left button's action has been triggered, manually.
    override func didPressLeftButton(_ sender: Any!) {
        super.didPressLeftButton(sender)
        self.dismissKeyboard(true)
        self.performSegue(withIdentifier: "Push", sender: nil)
    }
    override func didPressRightButton(_ sender: Any?) {
        self.sendMessage(self.textView.text)
        super.didPressRightButton(sender)
        self.textView.resignFirstResponder()
        
        
    }
    func sendMessage(_ message:String)
    {
        self.startLoading()
        connectionHandler.sendMessage(userID: self.user.user_id, message: self.textView.text, completion: { (_) in
            self.tableView.reloadData()
            self.dismissLoading()
        }) { (message, _) in
            self.dismissLoading()
            
        }
        
    }
    
    
    
    
}

