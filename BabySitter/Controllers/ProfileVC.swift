//
//  ProfileVC.swift
//  BabySitter
//
//  Created by 2021M05 on 20/03/22.
//

import UIKit

class ProfileVC: UIViewController {

    //MARK:- Outlet
    @IBOutlet weak var vwBack: UIView!
    
    @IBOutlet weak var imgProfile: UIImageView!
    
    @IBOutlet weak var lblTitle: GradientLabel!
    @IBOutlet weak var lblName: GradientLabel!
    @IBOutlet weak var lblEmail: GradientLabel!
    @IBOutlet weak var lblAddress: GradientLabel!
    @IBOutlet weak var lblPhoneNo: GradientLabel!
    @IBOutlet weak var lblLogout: GradientLabel!
    
    
    @IBOutlet weak var btnLogout: UIButton!
    
    //MARK:- Class Variable
    
    //MARK:- Custom Method
    
    func setUpView(){
        self.applyStyle()
    }
    
    func applyStyle(){
        self.imgProfile.layer.cornerRadius = 14
        self.btnLogout.layer.cornerRadius = 15
        
        self.vwBack.roundCorners([.topLeft,.topRight], radius: 55)
        
        let gradientColor = [
            UIColor().hexStringToUIColor(hex: "#6043F5").cgColor,
            UIColor().hexStringToUIColor(hex: "#836EF1").cgColor
        ]
        
        self.lblTitle.gradientColors = gradientColor
        self.lblName.gradientColors = gradientColor
        self.lblEmail.gradientColors = gradientColor
        self.lblAddress.gradientColors = gradientColor
        self.lblPhoneNo.gradientColors = gradientColor
        self.lblLogout.gradientColors = gradientColor
        
        
        if GFunction.user != nil {
            let user = GFunction.user
            self.lblName.text = user?.name
            self.lblAddress.text = user?.address
            self.lblEmail.text = user?.email
            self.lblPhoneNo.text = user?.phone
        }
    }
    
    @IBAction func logoutClick(_ sender : UIButton) {
        UIApplication.shared.setStart()
    }
    
    //MARK:- Action Method
    
    //MARK:- Delegates
    
    //MARK:- UILifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }

}
