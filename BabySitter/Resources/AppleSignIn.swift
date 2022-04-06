//
//  AppleSignIn.swift

import Foundation
import AuthenticationServices

struct AppleLoginModel {
    
    init() {
        
    }
    
    var socialId: String!
    var loginType: String!
    var firstName: String!
    var lastName: String!
    var email: String!
    var profileImage: String?
}

protocol AppleLoginDelegate: AnyObject {
    func appleLoginData(data: AppleLoginModel)
}

class AppleLoginManager: NSObject, ASAuthorizationControllerDelegate {
    weak var delegate: AppleLoginDelegate? = nil
    
    //init
    override init() {
        
    }
}

//MARK : Apple Login
extension AppleLoginManager {
    
    //MARK: Apple Login Methods
    /// Open apple login view
    @available(iOS 13.0, *)
    func performAppleLogin() {
        
        //request
        let appleIdProvider = ASAuthorizationAppleIDProvider()
        let authoriztionRequest = appleIdProvider.createRequest()
        authoriztionRequest.requestedScopes = [.fullName, .email]
        
        //Apple’s Keychain sign in // give the resukt of save id - password for this app
        let passwordProvider = ASAuthorizationPasswordProvider()
        let passwordRequest = passwordProvider.createRequest()

        //create authorization controller
        let authorizationController = ASAuthorizationController(authorizationRequests: [authoriztionRequest]) //[authoriztionRequest, passwordRequest]
        authorizationController.presentationContextProvider = self
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
}

//MARK : Apple Login Delegate
@available(iOS 13.0, *)
extension AppleLoginManager: ASAuthorizationControllerPresentationContextProviding {
    
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
//        return UIApplication.topViewController()!.view.window!
        return UIApplication.topViewController()!.view.window!
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        print(appleIDCredential.user, appleIDCredential.fullName as Any, appleIDCredential.email as Any)
        //self.isSocialLogin = true
        
        var dataObj: AppleLoginModel = AppleLoginModel()
        dataObj.socialId = appleIDCredential.user
        dataObj.loginType = "A"
        dataObj.firstName =  appleIDCredential.fullName?.givenName ?? ""//myUserDefault.string(forKey: kFirstName) ?? ""
        dataObj.lastName = appleIDCredential.fullName?.familyName ?? ""//myUserDefault.string(forKey: kLastName) ?? ""
        dataObj.email = appleIDCredential.email ?? ""//myUserDefault.string(forKey: kEmail) ?? ""
//        GFunction.shared.firebaseRegister(data: dataObj.email)
        delegate?.appleLoginData(data: dataObj)
        
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//        Alert.shared.showAlert(message: "Something went wrong", completion: nil)
    }
}
