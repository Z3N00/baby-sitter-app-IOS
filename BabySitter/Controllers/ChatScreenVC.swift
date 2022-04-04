//
//  ChatScreenVC.swift
//  BabySitter
//
//  Created by 2022M3 on 27/03/22.
//

import UIKit


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
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
    @IBOutlet weak var tvMsg: UITextView!
    @IBOutlet weak var btnSend: UIButton!
    
    
    
    var arrChat = [MessageModel]()
    
    
    func setUPChat() {
        self.arrChat.append(MessageModel(msg: "Hello", userType: .sender))
        self.arrChat.append(MessageModel(msg: "Hey Buddy", userType: .receiver))
        self.arrChat.append(MessageModel(msg: "How are you?", userType: .receiver))
        self.arrChat.append(MessageModel(msg: "Good", userType: .sender))
    }
    
    
    @IBAction func sendMessage(_ sender: UIButton) {
        if !(self.tvMsg.text.trim().isEmpty || self.tvMsg.text.trim() == "Write here..".trim()){
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
