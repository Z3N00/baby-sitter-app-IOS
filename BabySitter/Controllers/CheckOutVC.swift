//
//  CheckOutVC.swift
//  BabySitter
//
//  Created by 2021M05 on 20/03/22.
//

import UIKit
class CheckOutVCTableViewCell: UITableViewCell {
    //MARK:- CellOutlet
    @IBOutlet weak var vwBackView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imgAdd: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.vwBackView.layer.cornerRadius = 5
    }
    
    func configCell(data: ServiceModel) {
        self.lblTitle.text = data.name.description
        self.lblPrice.text = "$ \(data.price.description)"
        self.imgAdd.isHighlighted = data.isSelected
    }
}

class CheckOutVC: UIViewController {
    
    //MARK:- Outlet
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var btnAddMoreService: UIButton!
    @IBOutlet weak var btnProceed: UIButton!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    @IBOutlet weak var lblSubtotal: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    
    //MARK:- Class Variable
    var selectedArray : [ServiceModel]!
    var unSelectedArray: [ServiceModel]!
    var array = [ServiceModel]()
    var data: SitterModel!
    
    //MARK:- Custom Method
    
    func setUpView(){
        self.applyStyle()
        
        self.tblView.delegate   = self
        self.tblView.dataSource = self
        
        self.getSelectModel()
        self.getUnSelectModel()
    }
    
    func getSelectModel() {
        self.selectedArray =  self.array.filter(({$0.isSelected}))
    }
    
    func getUnSelectModel() {
        self.unSelectedArray = self.array.filter(({!$0.isSelected}))
    }
    
    func applyStyle(){
        self.btnAddMoreService.backgroundColor = UIColor().hexStringToUIColor(hex: "#693EFF")
        self.btnAddMoreService.layer.cornerRadius = 15.0
        
        self.btnProceed.backgroundColor = UIColor().hexStringToUIColor(hex: "#693EFF")
        self.btnProceed.layer.cornerRadius = 8
    }
    
    func getCount(array: [ServiceModel]) -> Int {
        let data = self.array.filter(({$0.isSelected == true}))
        return data.count
    }
    
    func getPrice(array: [ServiceModel]) -> Double {
        var price = 0.0
        self.array.forEach { data in
            if data.isSelected {
                price = price + Double(data.price)!
            }
        }
        
        return price
    }
    
    func getTitle(array: [ServiceModel]) -> [String] {
        var arrDemo = [String]()
        self.array .forEach { data in
            if data.isSelected {
                arrDemo.append(data.name)
            }
        }
        return arrDemo
    }
    
    //MARK:- Action Method
    @IBAction func btnCheckoutTapped(_ sender: Any) {
        self.addBooking(serviceList: self.getTitle(array: self.selectedArray))
    }
    
    
    //MARK:- Delegates
    
    //MARK:- UILifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
}

extension CheckOutVC: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.selectedArray.count
        } else {
            return self.unSelectedArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckOutVCTableViewCell") as! CheckOutVCTableViewCell
        if indexPath.section == 0 {
            cell.configCell(data: self.selectedArray[indexPath.row])
        } else {
            cell.configCell(data: self.unSelectedArray[indexPath.row])
        }
        cell.selectionStyle = .none
        
        let tap  = UITapGestureRecognizer()
        tap.addAction {
            if indexPath.section == 1 {
                self.unSelectedArray[indexPath.row].isSelected.toggle()
                self.selectedArray.append(self.unSelectedArray[indexPath.row])
                self.unSelectedArray.remove(at: indexPath.row)
            } else {
                self.selectedArray[indexPath.row].isSelected.toggle()
                self.unSelectedArray.append(self.selectedArray[indexPath.row])
                self.selectedArray.remove(at: indexPath.row)
            }

            tableView.reloadData()
        }
        if indexPath.section == 1 {
            self.lblCount.text = "\(self.getCount(array: self.selectedArray))"
            self.lblPrice.text = "$ \(self.getPrice(array: self.selectedArray) + 5.15)"
            
            self.lblSubtotal.text = "$ \(self.getPrice(array: self.selectedArray))"
            
            self.lblTotal.text = "$ \(self.getPrice(array: self.selectedArray) + 5.15)"
        } else {
            self.lblCount.text = "\(self.getCount(array: self.selectedArray))"
            self.lblPrice.text = "$ \(self.getPrice(array: self.selectedArray))"
            self.lblSubtotal.text = "$ \(self.getPrice(array: self.selectedArray))"
            self.lblTotal.text = "$ \(self.getPrice(array: self.selectedArray) + 5.15)"
        }
        cell.imgAdd.isUserInteractionEnabled = true
        cell.imgAdd.addGestureRecognizer(tap)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Added Item" : " "
    }
    
    func getData() {
        _ = AppDelegate.shared.db.collection(bService).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            self.array.removeAll()
            if snapshot.documents.count != 0 {
                for data in snapshot.documents {
                    let data1 = data.data()
                    if let name : String = data1[bServiceName] as? String, let price: String = data1[bServicePrice] as? String {
                        print("Data Count : \(self.array.count)")
                        self.array.append(ServiceModel(name: name, price: price))
                    }
                }
                self.tblView.delegate = self
                self.tblView.dataSource = self
                self.tblView.reloadData()
            }
        }
    }
    
    func addBooking(serviceList: [String]) {
        var ref : DocumentReference? = nil
        let price = self.getPrice(array: self.selectedArray) + 5.15
       
        ref = AppDelegate.shared.db.collection(bBooking).addDocument(data:
            [
                bEmail: GFunction.user.email.description,
                bName: GFunction.user.name.description,
                bServiceList: serviceList,
                bSitterId: self.data.email.description,
                bStatus: bPending.description,
                bTotalAmount: price.description
            ])
        {  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                self.addNotification(message: "Your Baby service request has been sent to \(self.data.name)", email: GFunction.user.email, name: GFunction.user.name)
                self.addNotification(message: "You got baby service request from to \(GFunction.user.name)", email: self.data.email, name: self.data.name)
                let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "ConfirmBookingPopup") as! ConfirmBookingPopup
                self.navigationController?.modalPresentationStyle = .fullScreen
                self.navigationController?.present(vc, animated: true)
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
                let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "ConfirmBookingPopup") as! ConfirmBookingPopup
                self.navigationController?.modalPresentationStyle = .fullScreen
                self.navigationController?.present(vc, animated: true)
            }
        }
    }
}
