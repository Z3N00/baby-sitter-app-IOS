//
//  InboxVC.swift
//  BabySitter
//
//  Created by 2022M3 on 03/04/22.
//

import UIKit

class InboxVC: UIViewController {

    //MARK:- Outlet
    @IBOutlet weak var lblInBox: GradientLabel!
    @IBOutlet weak var vwMessage: UIView!
    @IBOutlet weak var vwNotifications: UIView!

    @IBOutlet weak var lblMessage: GradientLabel!
    @IBOutlet weak var lblNotification: GradientLabel!
    @IBOutlet weak var lblMessageLine: UILabel!
    @IBOutlet weak var lblNotificationLine: UILabel!
    
    @IBOutlet weak var tblChatList: SelfSizedTableView!
    @IBOutlet weak var tblNotificationList: SelfSizedTableView!
    
    //------------------------------------------------------
    
    //MARK:- Class Variables
    
    var typeIndex = 0
    var array = [NotificationModel]()
    var arrRecentChat : [Dictionary<String,Any>] = [Dictionary<String,Any>]()
    
    //------------------------------------------------------
    
    //MARK:- Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        self.tblChatList.delegate = self
        self.tblChatList.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupViewModelObserver()
        self.typeIndex = 0
        self.getData()
        self.getMesssages()
        self.tblNotificationList.isHidden = true
        self.setUpPage(lblMainLine: self.lblMessageLine,lblChildLine: self.lblNotificationLine,type:self.typeIndex)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    //------------------------------------------------------
    
    //MARK:- Memory Management Method
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        debugPrint("‼️‼️‼️ deinit : \(self) ‼️‼️‼️")
    }
    
    //------------------------------------------------------
    
    //MARK:- Custom Method
    
    /**
     Basic view setup of the screen.
     */
    private func setUpView() {
       
       
        self.lblMessage.gradientColors = [
            UIColor().hexStringToUIColor(hex: "#6043F5").cgColor,
            UIColor().hexStringToUIColor(hex: "#836EF1").cgColor
        ]
        
        self.lblInBox.gradientColors = [
            UIColor().hexStringToUIColor(hex: "#6043F5").cgColor,
            UIColor().hexStringToUIColor(hex: "#836EF1").cgColor
        ]
        
        self.lblNotification.gradientColors = [
            UIColor().hexStringToUIColor(hex: "#6043F5").cgColor,
            UIColor().hexStringToUIColor(hex: "#836EF1").cgColor
        ]
    
        self.tapGesture(view: vwNotifications, type: 1)
        self.tapGesture(view: vwMessage, type: 0)
        self.setUpPage(lblMainLine: self.lblMessageLine,lblChildLine: self.lblNotificationLine, type: self.typeIndex)

    }
    
    //Function for set UITapGesture
    private func tapGesture(view: UIView,type: Int){
        
        let tap = UITapGestureRecognizer()
        tap.addAction {
            self.tblNotificationList.isHidden = true
            self.tblChatList.isHidden = false
            self.setUpPage(lblMainLine: self.lblMessageLine,lblChildLine: self.lblNotificationLine, type: self.typeIndex)
            if type == 1 {
                self.setUpPage(lblMainLine: self.lblNotificationLine,lblChildLine: self.lblMessageLine, type: self.typeIndex)
                self.tblNotificationList.isHidden = false
                self.tblChatList.isHidden = true
            }
        }
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tap)
    }
    
    
    //Function for setUp Page
    func setUpPage(lblMainLine:UILabel,lblChildLine:UILabel,type: Int){
        lblMainLine.backGroundColor(color: UIColor().hexStringToUIColor(hex: "#868080"))
        lblChildLine.backGroundColor(color: .clear)
    }
    /**
     Setup all view model observer and handel data and erros.
     */
    private func setupViewModelObserver() {
       
    }
    
    
    
    
    //------------------------------------------------------
    
    //MARK:- Action Method
    
    //------------------------------------------------------

}



//MARK:- Extension for TableViewDelegate methods

extension InboxVC: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == self.tblNotificationList ? self.array.count : self.arrRecentChat.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tblNotificationList {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell") as! NotificationCell
            cell.configCell(data: array[indexPath.row])
            cell.imgLogo.tintColor =  UIColor().hexStringToUIColor(hex: "#6043F5")
            cell.selectionStyle = .none
            return cell
        }else{
            let data =  self.arrRecentChat[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListTVC") as! ChatListTVC
            let tap = UITapGestureRecognizer()
            tap.addAction {
                if let vc = UIStoryboard.main.instantiateViewController(withClass: ChatScreenVC.self) {
                    vc.arrRecentChatData = [data]
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            cell.lblName.text = GFunction.user.isSitter ? (data[bReceiverName] as? String)?.capitalized : (data[bSenderName] as? String)?.capitalized
            cell.lblMessage.text = data[bMessage] as? String
            cell.lblStatus.text = data[bLocation] as? String
            cell.vwMain.isUserInteractionEnabled = true
            cell.vwMain.addGestureRecognizer(tap)
            return cell
        }
    }
    
    func getData() {
        _ = AppDelegate.shared.db.collection(bNotifications).whereField(bEmail, isEqualTo: GFunction.user.email).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            self.array.removeAll()
            if snapshot.documents.count != 0 {
                for data in snapshot.documents {
                    let data1 = data.data()
                    if let message : String = data1[bMessage] as? String, let name: String = data1[bName] as? String, let email: String = data1[bEmail] as? String {
                        print("Data Count : \(self.array.count)")
                        self.array.append(NotificationModel(docId: data.documentID, email: email, message: message, name: name))
                    }
                }
                self.tblNotificationList.delegate = self
                self.tblNotificationList.dataSource = self
                self.tblNotificationList.reloadData()
            }
        }
    }
}


extension InboxVC {
    func eventListener(snapshot :QuerySnapshot)  {
        snapshot.documentChanges.forEach { diff in
            
            if (diff.type == .added) {
                
                if self.indexOfID(id:diff.document.documentID) == NSNotFound  {
                    var dictTemp : Dictionary<String,Any>  = diff.document.data()
                    dictTemp["DocumentID"] = diff.document.documentID
                    
                    self.arrRecentChat.append(dictTemp)
                    print("add city: ")
                }
                
                self.arrRecentChat = self.arrRecentChat.map({ (obj) -> Dictionary<String,Any> in
                    var data = obj
                    data["status"] = false
                    
                    return data
                })
                
               
                self.tblChatList.reloadData()
                
            }
            
            if (diff.type == .modified) {
                
                let index = self.indexOfID(id:diff.document.documentID)
                
                if index > self.arrRecentChat.count - 1 {
                    return
                }
                
                self.arrRecentChat.remove(at: index)
                
                var dictTemp : Dictionary<String,Any>  = diff.document.data()
                dictTemp["DocumentID"] = diff.document.documentID
                
                self.arrRecentChat.append(dictTemp)
                
                self.arrRecentChat = self.arrRecentChat.map({ (obj) -> Dictionary<String,Any> in
                    var data = obj
                    data["status"] = false
                    
                    return data
                })
                
               
                self.tblChatList.reloadData()
            }
        }
    }
    
    func indexOfID(id: String) -> Int {
        
        return self.arrRecentChat.firstIndex { (question) -> Bool in
            return question["DocumentID"] as! String == id
            
            } ?? NSNotFound
        
    }
    
    func getMesssages() {
        if GFunction.user.isSitter {
            AppDelegate.shared.db.collection(bRecentChat).whereField(bSenderID, isEqualTo: GFunction.user.email).order(by: bServerTime, descending: true).addSnapshotListener{ querySnapshot, error in
                
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }
                
                self.eventListener(snapshot:snapshot)
            }
        }else{
            AppDelegate.shared.db.collection(bRecentChat).whereField(bReceiverID, isEqualTo: GFunction.user.email).order(by: bServerTime, descending: true).addSnapshotListener{ querySnapshot, error in
                
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }
                
                self.eventListener(snapshot:snapshot)
            }
        }
        

    }
}

