//
//  HomeVC.swift
//  BabySitter
//
//  Created by 2021M05 on 19/03/22.
//

import UIKit

class SitterModel {
    var name: String
    var imgProfile: String
    var rating: String
    var Address: String
    var description: String
    var docID: String
    var email: String

    
    init(docID:String,name: String, imgProfile: String, rating: String,address:String, description: String,email:String) {
        self.name = name
        self.imgProfile = imgProfile
        self.rating = rating
        self.Address = address
        self.description = description
        self.docID = docID
        self.email = email
    }
}

class HomeVCTVC: UITableViewCell {
    //MARK:- CellOutlet
    @IBOutlet weak var vwBackView: UIView!
    @IBOutlet weak var imgProfileImage: UIImageView!
    
    @IBOutlet weak var lblName: GradientLabel!
    @IBOutlet weak var lblRating: UILabel!
    
    @IBOutlet weak var btnViewProfile: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyStyle()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.btnViewProfile.layer.cornerRadius = self.btnViewProfile.frame.height/2
    }
    
    func applyStyle() {
        self.vwBackView.layer.cornerRadius = 20
        self.imgProfileImage.layer.cornerRadius = 20
        
        self.lblName.gradientColors = [
            UIColor().hexStringToUIColor(hex: "#6043F5").cgColor,
            UIColor().hexStringToUIColor(hex: "#836EF1").cgColor
        ]
        self.lblName.font = UIFont.customFont(ofType: .bold, withSize: 18)
        
        self.btnViewProfile.backgroundColor = UIColor().hexStringToUIColor(hex: "#6043F5")
    }
    
    func configCell(caseData: SitterModel) {
        self.lblName.text = caseData.name
        self.imgProfileImage.image = UIImage(named: caseData.imgProfile)
        self.lblRating.text = caseData.rating
    }
}

class HomeVC: UIViewController {

    //MARK:- Outlet
    @IBOutlet weak var vwMainback: UIView!
    @IBOutlet weak var lblTitle: GradientLabel!
    @IBOutlet weak var tblView: UITableView!
    
    //MARK:- Class Variable
    var arraySitters: [SitterModel] = []
    
    //MARK:- Custom Method
    
    func setUpView(){
        self.applyStyle()
        
//        self.tblView.delegate = self
//        self.tblView.dataSource = self
        
//        self.arraySitters = self.getSittersData()
        
    }
    
    func applyStyle(){
        self.vwMainback.roundCorners([.topLeft,.topRight], radius: 55)
        
        let gradientColorOne = UIColor().hexStringToUIColor(hex: "#6043F5")
        let gradientColorTwo = UIColor().hexStringToUIColor(hex: "#836EF1")
        self.lblTitle.gradientColors = [gradientColorOne.cgColor,gradientColorTwo.cgColor]
        self.lblTitle.font = UIFont.customFont(ofType: .bold, withSize: 22)
    }
    
    //MARK:- Action Method
    
    //MARK:- Delegates
    
    //MARK:- UILifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getData()
    }
}

extension HomeVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arraySitters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeVCTVC") as! HomeVCTVC
        cell.configCell(caseData: arraySitters[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "ViewProfileVC") as? ViewProfileVC {
            if let navigationController = self.parent?.navigationController as? UINavigationController {
                vc.data = self.arraySitters[indexPath.row]
                navigationController.pushViewController(vc, animated: true)
            }
        }
    }
    
}

extension HomeVC {
   /* func getSittersData() -> [SitterModel] {
        let array = [
            SitterModel(name: "Nikita Johns", imgProfile: "img_User1", rating: "4.8",address: "Montreal, Quebec Canada",description: "Light housework is performed. Engages children in enjoyable activities. Keeps the living and play places of youngsters clean. As needed, assists with schoolwork and tutoring. Feeding, diapering, and clothing infants are all part of the job."),
            SitterModel(name: "Starlet Watson", imgProfile: "img_User2", rating: "4.7",address: "Montreal, Quebec Canada",description: "Light housework is performed. Engages children in enjoyable activities. Keeps the living and play places of youngsters clean. As needed, assists with schoolwork and tutoring. Feeding, diapering, and clothing infants are all part of the job."),
            SitterModel(name: "Starlet Nikita", imgProfile: "img_User3", rating: "4.6",address: "Montreal, Quebec Canada",description: "Light housework is performed. Engages children in enjoyable activities. Keeps the living and play places of youngsters clean. As needed, assists with schoolwork and tutoring. Feeding, diapering, and clothing infants are all part of the job."),
            SitterModel(name: "Nikita Johns", imgProfile: "img_User1", rating: "4.8",address: "Montreal, Quebec Canada",description: "Light housework is performed. Engages children in enjoyable activities. Keeps the living and play places of youngsters clean. As needed, assists with schoolwork and tutoring. Feeding, diapering, and clothing infants are all part of the job."),
            SitterModel(name: "Starlet Watson", imgProfile: "img_User2", rating: "4.7",address: "Montreal, Quebec Canada",description: "Light housework is performed. Engages children in enjoyable activities. Keeps the living and play places of youngsters clean. As needed, assists with schoolwork and tutoring. Feeding, diapering, and clothing infants are all part of the job."),
            SitterModel(name: "Starlet Nikita", imgProfile: "img_User3", rating: "4.6",address: "Montreal, Quebec Canada",description: "Light housework is performed. Engages children in enjoyable activities. Keeps the living and play places of youngsters clean. As needed, assists with schoolwork and tutoring. Feeding, diapering, and clothing infants are all part of the job."),
        ]
        
        
//        for data in array{
//            self.uploadData(data: data)
//        }
        
        return array
    }*/
    
    
    
    func uploadData(data: SitterModel) {
        var ref : DocumentReference? = nil
        
        ref = AppDelegate.shared.db.collection(bSitterList).addDocument(data:
                                                                        [ bName : data.name.description,
                                                                             bDescription: data.description.description,
                                                                                bRating: data.rating.description,
                                                                                  bAddress : data.Address.description,
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
        _ = AppDelegate.shared.db.collection(bUser).whereField(bIsSitter, isEqualTo: true).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            self.arraySitters.removeAll()
            if snapshot.documents.count != 0 {
                for data in snapshot.documents {
                    let data1 = data.data()
                    if let name : String = data1[bName] as? String, let rating: String = data1[bRating] as? String, let address: String = data1[bAddress] as? String, let description : String = data1[bDescription] as? String,let email : String = data1[bEmail] as? String {
                        print("Data Count : \(self.arraySitters.count)")
                        self.arraySitters.append(SitterModel(docID: data.documentID.description, name: name, imgProfile: "img_User1", rating: rating, address: address, description: description, email: email))
                    }
                }
                self.tblView.delegate = self
                self.tblView.dataSource = self
                self.tblView.reloadData()
            }
        }
    }
}
