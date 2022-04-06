//
//  ForgotPasswordVC.swift


import UIKit

class ForgotPasswordVC: UIViewController {

    //MARK:- Outlet
    @IBOutlet weak var lblWelcome: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var vwBottomGradient: Gradient!
    @IBOutlet weak var btnLogin: BlueThemeButton!
    
    
    
    //MARK:- Class Variable
    var flag: Bool = true
    
    //MARK:- Custom Method
    
    func validation() -> String {
        if self.txtEmail.text?.trim() == "" {
            return "Please enter email"
        }else if self.txtPassword.text?.trim() == "" {
            return "Please enter password"
        }else if (self.txtPassword.text?.trim().count)! < 8 {
            return "Please enter 8 character for password"
        }else if (self.txtConfirmPassword.text?.trim() == "") {
            return "Please enter confirm password"
        }else if self.txtPassword.text?.trim() != self.txtConfirmPassword.text?.trim() {
            return "Password mismatched"
        }
        return ""
    }
    
    func setUpView(){
        self.applyStyle()
    }
    
    func applyStyle(){
        self.lblWelcome.font = UIFont.customFont(ofType: .bold, withSize: 16.0)
        self.lblWelcome.textColor = UIColor().hexStringToUIColor(hex: "#9D9998")
        vwBottomGradient.roundCorners([.topLeft], radius: 45.0)
    }
    
    //MARK:- Action Method
    @IBAction func btnForgotClick(_ sender: UIButton) {
        self.flag = false
        let error = self.validation()
        if error == "" {
            self.checkUser(email: self.txtEmail.text!, password: self.txtPassword.text!)
        }else{
            Alert.shared.showSnackBar(error)
        }
    }
    
    
    //MARK:- Delegates
    
    //MARK:- UILifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }

}

//MARK:- Extension for Login Function
extension ForgotPasswordVC {
    
    func checkUser(email:String,password:String) {
        
        _ = AppDelegate.shared.db.collection(bUser).whereField(bEmail, isEqualTo: email).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if snapshot.documents.count != 0 {
                let data = snapshot.documents[0]
                self.updatePAssword(docID: data.documentID, password: password)
                self.flag = false
            }else{
                if !self.flag {
                    Alert.shared.showSnackBar("Please enter valid email !!!")
                    self.flag = true
                }
            }
        }
    }
    
    func updatePAssword(docID: String,password:String) {
        let ref = AppDelegate.shared.db.collection(bUser).document(docID)
        ref.updateData([
            bPassword : password
        ]){ err in
            if let err = err {
                print("Error updating document: \(err)")
                self.navigationController?.popViewController(animated: true)
            } else {
                print("Document successfully updated")
                Alert.shared.showSnackBar("Your password has been updated successfully !!!")
                sleep(2)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

}
