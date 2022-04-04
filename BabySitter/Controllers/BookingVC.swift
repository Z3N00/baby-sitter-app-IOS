//
//  BookingVC.swift
//  BabySitter
//
//  Created by 2022M3 on 30/03/22.
//

import UIKit

class BookingTVC: UITableViewCell {
    
    //  @IBOutlet weak var colView: UICollectionView!
    
    @IBOutlet weak var lblName: GradientLabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let gradientColorOne = UIColor().hexStringToUIColor(hex: "#6043F5")
        let gradientColorTwo = UIColor().hexStringToUIColor(hex: "#836EF1")
        self.lblName.gradientColors = [gradientColorOne.cgColor,gradientColorTwo.cgColor]
    }
    
    
    func configData(data: BookingModel) {
        self.lblName.text = data.name.description
        self.lblStatus.text = data.status.description
        
        if data.status == bPending {
            self.lblStatus.textColor = UIColor.orange
        }else if data.status == bConfirm {
            self.lblStatus.textColor = UIColor.green
        }else if data.status == bReject {
            self.lblStatus.textColor = UIColor.red
        }
    }
}


class BookingVC: UIViewController {

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

extension BookingVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookingTVC") as! BookingTVC
        cell.configData(data: self.array[indexPath.row])
        return cell
    }
    
    
    func getData() {
        _ = AppDelegate.shared.db.collection(bBooking).whereField(bSitterId, isEqualTo: /*GFunction.user.email*/"rutu@grr.la").addSnapshotListener{ querySnapshot, error in
            
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
}
