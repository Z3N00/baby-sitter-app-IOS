//
//  LoginVC.swift


import UIKit

class LoginVC: UIViewController {

    //MARK:- Outlet
    @IBOutlet weak var lblWelcome: UILabel!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var vwBottomGradient: Gradient!
    @IBOutlet weak var btnLogin: BlueThemeButton!
    @IBOutlet weak var bntForgotPassword: UIButton!
    @IBOutlet weak var lblSignUp: UILabel!
    
    
    
    //MARK:- Class Variable
    var flag: Bool = true
    var isSitter: Bool!
    
    //MARK:- Custom Method
    
    func validation() -> String {
        if self.txtEmail.text?.trim() == "" {
            return "Please enter email"
        }else if self.txtPassword.text?.trim() == "" {
            return "Please enter password"
        }else if (self.txtPassword.text?.trim().count)! < 8 {
            return "Please enter 8 character for password"
        }
        return ""
    }
    
    func setUpView(){
        self.applyStyle()
        
        self.lblSignUp.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer()
        tap.addAction {
            if let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "SignUpVC") as? SignUpVC {
                vc.isSitter = self.isSitter
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        self.lblSignUp.addGestureRecognizer(tap)
    }
    
    func applyStyle(){
        self.lblWelcome.font = UIFont.customFont(ofType: .bold, withSize: 16.0)
        self.lblWelcome.textColor = UIColor().hexStringToUIColor(hex: "#9D9998")
        vwBottomGradient.roundCorners([.topLeft], radius: 45.0)
        self.txtPassword.isSecureTextEntry = true
    }
    
    //MARK:- Action Method
    @IBAction func btnLoginClick(_ sender: UIButton) {
        self.flag = false
        let error = self.validation()
        if error == "" {
            self.loginUser(email: self.txtEmail.text ?? "", password: self.txtPassword.text ?? "")
        }else{
            Alert.shared.showSnackBar(error)
        }
    }
    
    
    @IBAction func btnForgotClick(_ sender: UIButton) {
        if let vc = UIStoryboard.main.instantiateViewController(withClass: ForgotPasswordVC.self) {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    //MARK:- Delegates
    
    //MARK:- UILifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        self.txtEmail.text = "test@grr.la"
        self.txtPassword.text = "Test@1234"
    }

}

//MARK:- Extension for Login Function
extension LoginVC {
    
    
    func loginUser(email:String,password:String) {
        
        _ = AppDelegate.shared.db.collection(bUser).whereField(bEmail, isEqualTo: email).whereField(bPassword, isEqualTo: password).addSnapshotListener{ querySnapshot, error in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            if snapshot.documents.count != 0 {
                let data1 = snapshot.documents[0].data()
                let docId = snapshot.documents[0].documentID
                if let address : String = data1[bAddress] as? String, let name: String = data1[bName] as? String, let phone: String = data1[bPhone] as? String, let email: String = data1[bEmail] as? String, let isSitter: Bool = data1[bIsSitter] as? Bool, let password: String = data1[bPassword] as? String, let rating: String = data1[bRating] as? String{
                    GFunction.user = UserModel(docId: docId, name: name, email: email, phone: phone, password: password, address: address, isSitter: isSitter,rating: rating)
                }
                GFunction.shared.firebaseRegister(data: email)
                GFunction.user.isSitter ? UIApplication.shared.setSitter() : UIApplication.shared.setHome()
                
            }else{
                if !self.flag {
                    Alert.shared.showSnackBar("Please check your credentials !!!")
                    self.flag = true
                }
            }
        }
        
    }
}
