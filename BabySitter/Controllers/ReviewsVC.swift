//
//  ReviewsVC.swift
//  BabySitter
//
//  Created by 2021M05 on 19/03/22.
//

import UIKit

class ReviewModel {
    var review: String
    var name: String
    var docId: String
    
    init(review:String, name:String, docId:String){
        self.name = name
        self.review = review
        self.docId = docId
    }
    
}
class ReviewsTableViewCell: UITableViewCell {
    //MARK:- CellOutlets
    @IBOutlet weak var imgProfileImage: UIImageView!
    @IBOutlet weak var lblName: GradientLabel!
    @IBOutlet weak var lblReview: UILabel!
    @IBOutlet weak var vwBackView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyStyle()
    }
    
    func applyStyle() {
        self.lblName.gradientColors = [
            UIColor().hexStringToUIColor(hex: "#6043F5").cgColor,
            UIColor().hexStringToUIColor(hex: "#836EF1").cgColor
        ]
        
        self.vwBackView.layer.cornerRadius = 38.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imgProfileImage.layer.cornerRadius = 24.5
    }
    
    func configCell(data: ReviewModel) {
        self.lblName.text = data.name.description
        self.lblReview.text = data.review.description
    }
}

class ReviewsVC: UIViewController {

    //MARK:- Outlet
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var tblView: UITableView!
    
    //MARK:- Class Variable
    var array = [ReviewModel]()
    
    //MARK:- Custom Method
    
    func setUpView(){
        self.applyStyle()
        self.getData()
//        self.tblView.delegate = self
//        self.tblView.dataSource = self
    }
    
    func applyStyle(){
        self.imgProfile.layer.cornerRadius = 20
    }
    
    //MARK:- Action Method
    
    //MARK:- Delegates
    
    //MARK:- UILifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }

}

extension ReviewsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewsTableViewCell") as! ReviewsTableViewCell
        cell.configCell(data: self.array[indexPath.row])
        return cell
    }
    
   /* func setData() {
        var array = [ReviewModel]()

        array.append(ReviewModel(review: "He has watched my two children twice a week for the entire summer, and they were a joy to work ....", name: "Nikita Johns"))
        array.append(ReviewModel(review: "He has watched my two children (ages 4 and 7) twice a week for the entire summer, and they were a joy to work with. {Babysitter name} consistently arrived at our home on time, ready to engage with our kids, with a smile on.", name: "Phill Wilson"))
        array.append(ReviewModel(review: "He has watched my two children (ages 4 and 7) twice a week for the entire summer, and they were a joy to work ....", name: "Smith Johns"))
        array.append(ReviewModel(review: "He has watched my two children (ages 4 and 7) twice a week for the entire summer, and they were a joy to work with. {Babysitter name} consistently arrived at our home on time, ready to engage with our kids, with a smile on.", name: "Shweta"))
        array.append(ReviewModel(review: "He has watched my two children twice a week for the entire summer, and they were a joy to work ....", name: "Smithi"))
        array.append(ReviewModel(review: "He has watched my two children (ages 4 and 7) twice a week for the entire summer, and they were a joy to work with. {Babysitter name} consistently arrived at our home on time, ready to engage with our kids, with a smile on.", name: "Smith Johns"))
        array.append(ReviewModel(review: "He has watched my two children (ages 4 and 7) twice a week for the entire summer, and they were a joy to work ....", name: "Starlet Watson"))
        array.append(ReviewModel(review: "He has watched my two children (ages 4 and 7) twice a week for the entire summer, and they were a joy to work with. {Babysitter name} consistently arrived at our home on time, ready to engage with our kids, with a smile on.", name: "Dani"))
        array.append(ReviewModel(review: "He has watched my two children twice a week for the entire summer, and they were a joy to work ....", name: "Starlet Nikita"))

        for data in array {
            self.uploadData(data: data)
        }
    }*/
    
    func uploadData(data: ReviewModel){
        var ref : DocumentReference? = nil
        
        ref = AppDelegate.shared.db.collection(bReview).addDocument(data:
                                                                        [ bReviewName : data.name.description,
                                                                          bReviewMsg: data.review.description,
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
        _ = AppDelegate.shared.db.collection(bReview).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            self.array.removeAll()
            if snapshot.documents.count != 0 {
                for data in snapshot.documents {
                    let data1 = data.data()
                    if let name : String = data1[bReviewName] as? String, let review: String = data1[bReviewMsg] as? String {
                        print("Data Count : \(self.array.count)")
                        self.array.append(ReviewModel(review: review, name: name, docId: data.documentID.description))
                    }
                }
                self.tblView.delegate = self
                self.tblView.dataSource = self
                self.tblView.reloadData()
            }
        }
    }
}
