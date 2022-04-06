//
//  SignUpVC.swift

import UIKit

class SignUpVC: UIViewController {

    //MARK:- Outlet
    @IBOutlet weak var lblWelcome: UILabel!
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    
    @IBOutlet weak var btnSignUp: BlueThemeButton!
    @IBOutlet weak var lblSignIn: UILabel!
    
    
    //MARK:- Class Variable
    var flag: Bool = true
    var isSitter: Bool  = false
    
    //MARK:- Custom Method
    
    func validation() -> String {
        if self.txtName.text?.trim() == "" {
            return "Please enter name"
        }else if self.txtEmail.text?.trim() == "" {
            return "Please enter email"
        }else if self.txtPhone.text?.trim() == "" {
            return "Please enter phone number"
        }else if (self.txtEmail.text?.trim().count)! < 10 {
            return "Please enter 10 digit number"
        }else if self.txtAddress.text?.trim() == "" {
            return "Please enter address"
        }else if self.txtPassword.text?.trim() == "" {
            return "Please enter password"
        }else if (self.txtPassword.text?.trim().count)! < 8 {
            return "Please enter 8 character for password"
        }else if self.txtConfirmPassword.text?.trim() == "" {
            return "Please enter confirm password"
        }else if self.txtPassword.text?.trim() != self.txtConfirmPassword.text?.trim() {
            return "Password mismatched"
        }
        return ""
    }
    
    
    func setUpView(){
        self.applyStyle()
        
        self.lblSignIn.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer()
        tap.addAction {
            if let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        self.lblSignIn.addGestureRecognizer(tap)
    }
    
    func applyStyle(){
        self.lblWelcome.font = UIFont.customFont(ofType: .bold, withSize: 22.0)
        self.lblWelcome.textColor = UIColor().hexStringToUIColor(hex: "#9D9998")
    }
    
    //MARK:- Action Method
    
    @IBAction func btnSignUpClick(_ sender: UIButton) {
        self.flag = false
        let error = self.validation()
        if error == "" {
            self.getExistingUser(email: self.txtEmail.text!, phone: self.txtPhone.text!, name: self.txtName.text!, password: self.txtPassword.text!, isSitter: self.isSitter,address: self.txtAddress.text!)

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
extension SignUpVC {

    func createAccount(email: String, phone:String, name:String, password:String, isSitter:Bool,address: String) {
        var ref : DocumentReference? = nil
        var rating  =  isSitter ? Float.random(min: 1.0, max: 5.0).description : "0.0"
        ref = AppDelegate.shared.db.collection(bUser).addDocument(data:
            [
              bPhone: phone,
              bEmail: email,
              bName: name,
              bPassword : password,
              bIsSitter: isSitter,
              bAddress: address,
              bRating: rating,
              bDescription: isSitter ? DesData : ""
            ])
        {  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                Alert.shared.showSnackBar("Congratulations... Welcome to babyCare Family...")
                sleep(2)
                GFunction.shared.firebaseRegister(data: email)
                
                GFunction.user = UserModel(docId: (ref?.documentID.description)!, name: name, email: email, phone: phone, password: password, address: address, isSitter: isSitter,rating: rating)
                
                isSitter ? UIApplication.shared.setSitter() : UIApplication.shared.setHome()
                self.flag = true
            }
        }
    }

    func getExistingUser(email: String, phone:String, name:String, password:String,isSitter:Bool,address: String) {

        _ = AppDelegate.shared.db.collection(bUser).whereField(bEmail, isEqualTo: email).addSnapshotListener{ querySnapshot, error in

            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }

            if snapshot.documents.count == 0 {
                self.createAccount(email: email, phone:phone, name:name, password:password,isSitter:isSitter, address: address)
                self.flag = true
            }else{
                if !self.flag {
                    Alert.shared.showSnackBar("UserName is already exist !!!")
                    self.flag = true
                }
            }
        }
    }
}
