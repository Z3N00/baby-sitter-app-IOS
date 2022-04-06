//
//  AddItemVC.swift
//  BabySitter
//
//  Created by 2021M05 on 20/03/22.
//

import UIKit

class ServiceModel {
    var name: String
    var price:  String
    var isSelected: Bool
    
    init(name:String, price:String) {
        self.name = name
        self.price = price
        self.isSelected = false
    }
}

class AddItemTableViewCell: UITableViewCell {
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

class AddItemVC: UIViewController {

    //MARK:- Outlet
    @IBOutlet weak var vwMainback: UIView!
    @IBOutlet weak var imgProfileImage: UIImageView!
    @IBOutlet weak var lblName: GradientLabel!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var btnProceed: UIButton!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    //MARK:- Class Variable
    var array = [ServiceModel]()
    var data: SitterModel!
    
    //MARK:- Custom Method
    
    func setUpView(){
        self.applyStyle()
        self.getData()
//        self.tblView.delegate = self
//        self.tblView.dataSource = self
    }
    
    func applyStyle(){
        self.imgProfileImage.layer.cornerRadius = 20
        self.vwMainback.roundCorners(.topLeft, radius: 55)
        let gradientColorOne = UIColor().hexStringToUIColor(hex: "#6043F5")
        let gradientColorTwo = UIColor().hexStringToUIColor(hex: "#836EF1")
        self.lblName.gradientColors = [gradientColorOne.cgColor,gradientColorTwo.cgColor]
        
        self.btnProceed.backgroundColor = UIColor().hexStringToUIColor(hex: "#693EFF")
        self.btnProceed.layer.cornerRadius = 8
    }
    
    func getCount() -> Int {
        let data = self.array.filter(({$0.isSelected == true}))
        return data.count
    }
    
    func getPrice() -> Double {
        var price = 0.0
        self.array.forEach { data in
            if data.isSelected {
                price = price + Double(data.price)!
            }
        }
        
        return price
    }
    
    func getSelectModel() -> [ServiceModel] {
        return self.array.filter(({$0.isSelected}))
    }
    
    //MARK:- Action Method
    @IBAction func btnProccedTapped(_ sender: Any) {
        if self.getCount() == 0 {
            Alert.shared.showSnackBar("Please select atleast one service")
        }else{
            if let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "CheckOutVC") as? CheckOutVC {
                vc.array = self.array
                vc.data = self.data
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    
    //MARK:- Delegates
    
    //MARK:- UILifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }

}

extension AddItemVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddItemTableViewCell") as! AddItemTableViewCell
        cell.configCell(data: self.array[indexPath.row])
        let tap  = UITapGestureRecognizer()
        tap.addAction {
            self.array[indexPath.row].isSelected.toggle()
            self.tblView.reloadData()
            self.lblCount.text = "\(self.getCount())"
            self.lblPrice.text = "$ \(self.getPrice())"
        }
        cell.imgAdd.isUserInteractionEnabled = true
        cell.imgAdd.addGestureRecognizer(tap)
        cell.selectionStyle = .none
        return cell
    }
    
    
    @objc func selectService(_ sender: UIButton){
        
    }
    
    
    func setData(){
        var array = [ServiceModel]()
        
        array.append(contentsOf: [ServiceModel(name: "Baby Bath", price: "12.70"),
                     ServiceModel(name: "Full Day Care", price: "18.00"),
                      ServiceModel(name: "Preparing Baby Food", price: "18.00"),
                      ServiceModel(name: "Half Day  Baby Care", price: "12.00"),
                                 ServiceModel(name: "Baby cloth Laundry", price: "15.00")])
        
        
        for data in array {
            self.uploadData(data: data)
        }
    }
    
    func uploadData(data: ServiceModel) {
        var ref : DocumentReference? = nil
        
        ref = AppDelegate.shared.db.collection(bService).addDocument(data:
                                                                        [ bServiceName : data.name.description,
                                                                          bServicePrice: data.price.description,
                                                                        ]
        )
        {  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
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
                
                self.lblCount.text = "\(self.getCount())"
                self.lblPrice.text = "$ \(self.getPrice())"
            }
        }
    }
}
