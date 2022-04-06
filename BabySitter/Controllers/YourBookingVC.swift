//
//  YourBookingVC.swift
//  BabySitter
//
//  Created by 2021M05 on 29/03/22.
//

import UIKit


class BookingModel {
    var email: String
    var name: String
    var serviceList: [String]
    var status: String
    var amount: String
    var sitterID: String
    var docID: String
    
    
    init(docId:String, email:String, name:String, serviceList: [String], status: String, amount:String, sitterId: String) {
        self.docID = docId
        self.email = email
        self.name = name
        self.serviceList = serviceList
        self.status = status
        self.amount = amount
        self.sitterID = sitterId
    }
}

class YourBookingCVC: UICollectionViewCell {
    
}

class YourBookingTVC: UITableViewCell {
    
    //  @IBOutlet weak var colView: UICollectionView!
    
    @IBOutlet weak var imgDelete: UIImageView!
    @IBOutlet weak var imgAccept: UIImageView!
    @IBOutlet weak var lblName: GradientLabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let gradientColorOne = UIColor().hexStringToUIColor(hex: "#6043F5")
        let gradientColorTwo = UIColor().hexStringToUIColor(hex: "#836EF1")
        self.lblName.gradientColors = [gradientColorOne.cgColor,gradientColorTwo.cgColor]
    }
    
    
    func configData(data: BookingModel) {
        self.lblName.text = data.name.description
        if data.status != bPending {
            self.imgAccept.isHidden = true
            self.imgDelete.isHidden = true
        }
    }
}

class YourBookingVC: UIViewController {
    
    //MARK:- Outlet
    @IBOutlet weak var tblView: UITableView!
    
    //MARK:- Class Variable
    var array = [BookingModel]()
    
    //MARK:- Custom Method
    
    func setUpView(){
        self.applyStyle()
        self.getData()
//        self.tblView.delegate = self
//        self.tblView.dataSource = self
    }
    
    func applyStyle(){
    }
    
    //MARK:- Action Method
    
    //MARK:- Delegates
    
    //MARK:- UILifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
}

extension YourBookingVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YourBookingTVC") as! YourBookingTVC
        cell.configData(data: self.array[indexPath.row])
        
        let tap = UITapGestureRecognizer()
        tap.addAction {
            self.updateData(data: self.array[indexPath.row],status: bConfirm)
        }
        cell.imgAccept.isUserInteractionEnabled = true
        cell.imgAccept.addGestureRecognizer(tap)
        
        let tap1 = UITapGestureRecognizer()
        tap1.addAction {
            self.updateData(data: self.array[indexPath.row],status: bReject)
        }
        cell.imgDelete.isUserInteractionEnabled = true
        cell.imgDelete.addGestureRecognizer(tap1)
        
        return cell
    }
    
    
    func getData() {
        _ = AppDelegate.shared.db.collection(bBooking).whereField(bSitterId, isEqualTo: GFunction.user.email).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            self.array.removeAll()
            if snapshot.documents.count != 0 {
                for data in snapshot.documents {
                    let data1 = data.data()
                    if let serviceList : [String] = data1[bServiceList] as? [String], let name: String = data1[bName] as? String, let email: String = data1[bEmail] as? String,let status: String = data1[bStatus] as? String,let amount: String = data1[bTotalAmount] as? String,let sitterID: String = data1[bSitterId] as? String {
                        print("Data Count : \(self.array.count)")
                        self.array.append(BookingModel(docId: data.documentID.description, email: email, name: name, serviceList: serviceList, status: status, amount: amount, sitterId: sitterID))
                    }
                }
                self.tblView.delegate = self
                self.tblView.dataSource = self
                self.tblView.reloadData()
            }else{
                Alert.shared.showAlert(message: "No Data Found !!!", completion: nil)
            }
        }
    }
    
    
    func updateData(data: BookingModel,status: String) {
        let ref = AppDelegate.shared.db.collection(bBooking).document(data.docID)
        ref.updateData([
            bStatus : status
        ]){ err in
            if let err = err {
                print("Error updating document: \(err)")
                self.navigationController?.popViewController(animated: true)
            } else {
                print("Document successfully updated")
                if status == bConfirm {
                    self.addNotification(message: "Your request has been confirmed by \(GFunction.user.name)", email: data.email, name: data.name)
                    self.sendMessage(msg: "Your request has been accepted.", senderName: GFunction.user.name, senderID: data.sitterID, receiverName: data.name, receiverID: data.email, isSitter: true, chatID: "\(data.sitterID)#\(data.email)", location: GFunction.user.address)
                }else{
                    self.addNotification(message: "Your request has been rejected by \(GFunction.user.name)", email: data.email, name: data.name)
                }
               
            }
        }
    }
    
    func addNotification(message: String,email:String,name:String) {
        var ref : DocumentReference? = nil
        ref = AppDelegate.shared.db.collection(bNotifications).addDocument(data:
            [
                bEmail: email.description,
                bName: name.description,
                bMessage: message
            ])
        {  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                Alert.shared.showSnackBar("Your request status has been updated successfully !!!")
                sleep(2)
                self.getData()
            }
        }
    }
    
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
    }
}





