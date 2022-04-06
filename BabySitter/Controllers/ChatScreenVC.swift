//
//  ChatScreenVC.swift
//  BabySitter
//
//  Created by 2022M3 on 27/03/22.
//

import UIKit

class ChatScreenVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dictMsg.allKeys.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if !self.arrMsg.isEmpty {
            return  (dictMsg.value(forKey : arrSort[section]) as! NSArray).count
        }else {
            return 0
        }

class MessageModel{
    var msg: String!
    var userType: MessageUser!
    
    init(msg: String,userType: MessageUser){
        self.msg = msg
        self.userType = userType
    }
}

enum MessageUser{
    case sender
    case receiver
}

class ChatScreenVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.arrChat.count
        
        let array :  [Dictionary<String,Any>] = dictMsg.value(forKey:arrSort[indexPath.section] ) as! [Dictionary<String, Any>]
        let isSitter : Bool = array[indexPath.row][bIsSitter] as! Bool
        let date = (array[indexPath.row][bServerTime] as? Timestamp)?.dateValue() ?? Date()
        let data = array[indexPath.row]
        
        if self.isSitterData {
            if isSitter {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverCell") as! ReceiverCell
                cell.lblMessage.text = data[bMessage] as? String
                cell.selectionStyle = .none
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "SenderCell") as! SenderCell
                cell.lblMessage.text = data[bMessage] as? String
                cell.selectionStyle = .none
                return cell
            }
        }
        
        if isSitter {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SenderCell") as! SenderCell
            cell.lblMessage.text = data[bMessage] as? String
            cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverCell") as! ReceiverCell
            cell.lblMessage.text = data[bMessage] as? String
            cell.selectionStyle = .none
            return cell
        }
        let data = self.arrChat[indexPath.row]
        if data.userType == MessageUser.sender {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SenderCell") as! SenderCell
            cell.lblMessage.text = data.msg
            //cell.configCell(data: self.arraySideMenuItems[indexPath.row])
            cell.selectionStyle = .none
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverCell") as! ReceiverCell
        cell.lblMessage.text = data.msg
        //cell.configCell(data: self.arraySideMenuItems[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    

    
    @IBOutlet weak var tblChat: UITableView!
    @IBOutlet weak var vwText: UIView!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var lblName: UILabel!
    
    

    var refGetMsg : ListenerRegistration? = nil
    var arrMsg  : [Dictionary<String,Any>] = [Dictionary<String,Any>]()
    var arrRecentChatData : [Dictionary<String,Any>] = [Dictionary<String,Any>]()
    let dictMsg : NSMutableDictionary = NSMutableDictionary()
    var arrSort = [String]()
    var isSitterData: Bool = false
    
    
    func setUPChat() {
        
        if arrRecentChatData != nil {
            self.lblName.text = GFunction.user.isSitter ? (self.arrRecentChatData[0][bReceiverName] as? String)?.capitalized : (self.arrRecentChatData[0][bSenderName] as? String)?.capitalized
            self.getMesssages(chatId: self.arrRecentChatData[0][bChatID] as! String)
            self.imgProfile.cornerRadius(cornerRadius: 5.0)
        }
        
        if let isSitter = GFunction.user.isSitter as? Bool {
            self.isSitterData = isSitter
        }
    @IBOutlet weak var tvMsg: UITextView!
    @IBOutlet weak var btnSend: UIButton!
    
    
    
    var arrChat = [MessageModel]()
    
    
    func setUPChat() {
        self.arrChat.append(MessageModel(msg: "Hello", userType: .sender))
        self.arrChat.append(MessageModel(msg: "Hey Buddy", userType: .receiver))
        self.arrChat.append(MessageModel(msg: "How are you?", userType: .receiver))
        self.arrChat.append(MessageModel(msg: "Good", userType: .sender))
    }
    
    
            self.arrChat.append(MessageModel(msg: self.tvMsg.text,userType: .receiver))
        }
        self.tvMsg.text = "Write here.."
        self.tblChat.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUPChat()
        self.tblChat.delegate = self
        self.tblChat.dataSource = self
        self.vwText.layer.borderWidth = 1
        // Do any additional setup after loading the view.
    }

}


class SenderCell: UITableViewCell {
    @IBOutlet weak var lblMessage: EdgeInsetLabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var vwCell: UIView!
    @IBOutlet weak var vwText: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.vwText.cornerRadius(cornerRadius: 10.0, clips: true).borderColor(color: UIColor.black.withAlphaComponent(0.07), borderWidth: 1.0)
    }
}

class ReceiverCell: UITableViewCell {
    @IBOutlet weak var lblMessage: EdgeInsetLabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var vwCell: UIView!
    @IBOutlet weak var vwText: UIView!

    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        vwText.cornerRadius(cornerRadius: 10.0, clips: true)
        self.lblMessage.backgroundColor = .clear
        
    }
}



extension ChatScreenVC {
    func sendMessage(msg:String, senderName:String, senderID: String, receiverName:String, receiverID: String, isSitter: Bool, chatID: String, location: String)  {
        
        var ref : DocumentReference? = nil
        
        ref = AppDelegate.shared.db.collection(bChat).addDocument(data:
                                                                    [ bMessage: msg,
                                                                      bChatID : chatID,
                                                                  bServerTime : FieldValue.serverTimestamp(),
                                                                   bSenderName: senderName,
                                                                    bIsSitter : isSitter,
                                                                 bReceiverName: receiverName,
                                                                     bSenderID: senderID,
                                                                   bReceiverID: receiverID,
                                                                     bLocation: location,
                                                                    ])
        {  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                AppDelegate.shared.db.collection(bRecentChat).document(chatID).setData(
                    [ bMessage: msg,
                      bChatID : chatID,
                  bServerTime : FieldValue.serverTimestamp(),
                   bSenderName: senderName,
                    bIsSitter : isSitter,
                 bReceiverName: receiverName,
                     bSenderID: senderID,
                   bReceiverID: receiverID,
                     bLocation: location,
                    ])
            }
        }
        self.getMesssages(chatId: chatID)
    }
    
    func getMesssages(chatId:String)  {
        
        refGetMsg =  AppDelegate.shared.db.collection(bChat).whereField(bChatID, isEqualTo: chatId).order(by: bServerTime, descending: false).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            snapshot.documentChanges.forEach { diff in
                
                if (diff.type == .added) {
                    var dictTemp : Dictionary<String,Any>  = diff.document.data()
                    dictTemp["DocumentID"] = diff.document.documentID
                    
                    if self.indexOfID(id:diff.document.documentID) == NSNotFound {
                        
                        self.arrMsg.append(dictTemp)
                        print("add city: ")
                    }
                    
                }
                if (diff.type == .modified) {
                    //print("Modified city: \(diff.document.data())")
                }
                if (diff.type == .removed) {
                    print("Removed city: \(diff.document.data())")
                    //let index = self.indexOfID(id:diff.document.documentID)
                    if self.indexOfID(id:diff.document.documentID) != NSNotFound {
                        self.arrMsg.remove(at: self.indexOfID(id:diff.document.documentID))
                    }
                    
                }
            }
            
            // sort array and table reload
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"//"YYYY-MM-dd hh:mm a" // dont change this format
            
            self.dictMsg.removeAllObjects()
            _ = self.arrMsg.filter({ (dataObj: [String : Any]) -> Bool in
                
                let data = (dataObj[bServerTime] as? Timestamp)?.dateValue() ?? Date()
                let strDate = GFunction.shared.UTCToLocalShortDate(date: data)
                
                if (self.dictMsg.allKeys as! Array).contains(strDate) {
                    
                    var arrTemp : [Any] = self.dictMsg.value(forKey:strDate) as! [Any]
                    arrTemp.append(dataObj)
                    
                    self.dictMsg.setValue(arrTemp, forKey: strDate)
                } else {
                    self.dictMsg.setValue([dataObj], forKey:strDate )
                }
                
                return true
            })
            print(self.dictMsg)
            self.sortArray()
            
            self.tblChat.reloadData()
            self.scrollToBottom()
        }
        
    }
    
    func indexOfID(id: String) -> Int {
        
        return self.arrMsg.index{ (question) -> Bool in
            return question["DocumentID"] as! String == id
            
        } ?? NSNotFound
        
    }
    
    func scrollToBottom(){
        let section = dictMsg.allKeys.count - 1
        if section != -1 {
            let row = (dictMsg.value(forKey : arrSort[section]) as! NSArray).count - 1
            //DispatchQueue.main.async {
            let indexPath = IndexPath(row: row, section: section)
            self.tblChat.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    //}
    
    func sortArray()  {
        
        let testArray = dictMsg.allKeys as! [String]
        var convertedArray: [Date] = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        for dat in testArray {
            let date = dateFormatter.date(from: dat)
            if let date = date {
                
                convertedArray.append(date)
            }
        }
        
        let  arrDate = convertedArray.sorted(by: { $0.compare($1) == .orderedAscending })
        
        var  arrConvertedString = [String]()
        for dat in arrDate {
            let date = dateFormatter.string(from:dat)
            arrConvertedString.append(date)
        }
        arrSort = arrConvertedString
    }
}
