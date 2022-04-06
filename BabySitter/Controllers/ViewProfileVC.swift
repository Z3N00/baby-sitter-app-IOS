//
//  ViewProfileVC.swift
//  BabySitter
//
//  Created by 2021M05 on 19/03/22.
//

import UIKit
class ViewProfileTableViewCell: UITableViewCell {
    //MARK:- CellOutlets
    @IBOutlet weak var imgProfileImage: UIImageView!
    @IBOutlet weak var lblName: GradientLabel!
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
}

class ViewProfileVC: UIViewController {

    //MARK:- Outlet
    @IBOutlet weak var vwMainback: UIView!
    @IBOutlet weak var imgProfileImage: UIImageView!
    @IBOutlet weak var lblName: GradientLabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var btnCheckAvailability: UIButton!
    
    //MARK:- Class Variable
    var data: SitterModel!
    
    
    //MARK:- Custom Method
    
    func setUpView(){
        self.applyStyle()
        self.tblView.delegate = self
        self.tblView.dataSource = self
        if data != nil {
            self.lblName.text = data.name.description
            self.lblRating.text = data.rating.description
            self.lblAddress.text = data.Address.description
            self.lblDescription.text = data.description.description
        }
    }
    
    func applyStyle(){
        self.imgProfileImage.layer.cornerRadius = 20
        self.vwMainback.roundCorners(.topLeft, radius: 55)
        let gradientColorOne = UIColor().hexStringToUIColor(hex: "#6043F5")
        let gradientColorTwo = UIColor().hexStringToUIColor(hex: "#836EF1")
        self.lblName.gradientColors = [gradientColorOne.cgColor,gradientColorTwo.cgColor]
        
        self.btnCheckAvailability.backgroundColor = UIColor().hexStringToUIColor(hex: "#693EFF")
        self.btnCheckAvailability.layer.cornerRadius = 8
    }
    
    //MARK:- Action Method
    @IBAction func btnViewAllTapped(_ sender: Any) {
        let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "ReviewsVC") as! ReviewsVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnCheckAvailabilityTapped(_ sender: Any) {
        if let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "AvailabilityVC") as? AvailabilityVC {
            vc.data = self.data
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    //MARK:- Delegates
    
    //MARK:- UILifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.navigationController?.navigationBar.isHidden = true
    }

}

extension ViewProfileVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewProfileTableViewCell") as! ViewProfileTableViewCell
        return cell
    }
}
