//
//  SignInVC.swift

import UIKit

class SignInVC: UIViewController {
    
    //MARK:- Outlet
    @IBOutlet weak var vwTopGradient: Gradient!
    @IBOutlet weak var vwBottomGradient: Gradient!
    
    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var btnGoogle: UIButton!
    @IBOutlet weak var btnFacebook: UIButton!
    
    @IBOutlet weak var lblLogin: UILabel!
    
    //MARK:- Class Variable
    var appleData: AppleLoginModel!
    var isSitter: Bool!
    private let appleLoginManager: AppleLoginManager = AppleLoginManager()
    
    //MARK:- Custom Method
    
    func setUpView(){
        self.applyStyle()
        
        self.lblLogin.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer()
        tap.addAction {
            if let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC {
                vc.isSitter = self.isSitter
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        self.lblLogin.addGestureRecognizer(tap)
    }
    
    func applyStyle(){
        vwTopGradient.roundCorners([.bottomRight], radius: 35.0)
        vwBottomGradient.roundCorners([.topLeft], radius: 35.0)
        
        self.btnEmail.layer.cornerRadius = 16.0
        self.btnGoogle.layer.cornerRadius = 16.0
        self.btnFacebook.layer.cornerRadius = 16.0
    }
    
    //MARK:- Action Method
    
    @IBAction func btnSignUpWithEmailTapped(_ sender: UIButton) {
        if let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "SignUpVC") as? SignUpVC {
            vc.isSitter = self.isSitter
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func btnAppleClick(_ sender: UIButton) {
        self.appleLoginManager.performAppleLogin()
    }
    
    //MARK:- Delegates
    
    //MARK:- UILifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
}




//MARK:- Apple Login
extension SignInVC: AppleLoginDelegate {
    func appleLoginData(data: AppleLoginModel) {
        
        print("Social Id==>", data.socialId ?? "")
        print("First Name==>", data.firstName ?? "")
        print("Last Name==>", data.lastName ?? "")
        print("Email==>", data.email ?? "")
        print("Login type==>", data.loginType ?? "")
    
        
        if let vc = UIStoryboard.main.instantiateViewController(withClass: SignUpVC.self) {
//            vc.isApple = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
