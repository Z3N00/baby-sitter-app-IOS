//
//  NotificationVC.swift


import UIKit



class NotificationVC: UIViewController {

    
    
    @IBOutlet weak var tblNotificationList: UITableView!
    
    var array = [NotificationModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.getData()
//        self.tblNotificationList.delegate = self
//        self.tblNotificationList.dataSource = self
//
        // Do any additional setup after loading the view.
    }

}


extension NotificationVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell") as! NotificationCell
        cell.configCell(data: array[indexPath.row])
        cell.imgLogo.tintColor =  UIColor().hexStringToUIColor(hex: "#6043F5")
        cell.selectionStyle = .none
        return cell
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


class NotificationCell: UITableViewCell {
    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblNotification: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    
    func configCell(data: NotificationModel){
        self.lblNotification.text = data.message.description
        self.lblTime.text = " "
    }
    
}
