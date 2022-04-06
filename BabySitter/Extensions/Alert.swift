//
//  Alert.swift


import Foundation
import UIKit

class Alert {
    
    /// Shared instance
    static let shared = Alert()
    
    private let snackbar: TTGSnackbar = TTGSnackbar()
    
    ///Init
    private init() {
        
    }
    
}

// MARK: Snackbar
extension Alert {

    /// Show snack bar alert message
    ///
    /// - Parameters:
    ///   - message: Message for alert
    ///   - backGroundColor: Backgroud color for alert box
    ///   - duration: Alert display duration
    ///   - animation: Snack bar animation type
    func showSnackBar(_ message : String, isError: Bool = false, duration : TTGSnackbarDuration = .middle, animation : TTGSnackbarAnimationType = .slideFromTopBackToTop) {
        snackbar.message = message
        snackbar.duration = duration
        snackbar.contentInset = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)

        snackbar.leftMargin = 20
        snackbar.rightMargin = 20
        snackbar.bottomMargin = 20

        snackbar.messageTextColor = UIColor.white
        snackbar.messageTextFont = UIFont.customFont(ofType: .medium, withSize: 14.0)

        snackbar.backgroundColor = UIColor().hexStringToUIColor(hex: "#6043F5")

        snackbar.onTapBlock = { snackbar in
            snackbar.dismiss()
        }

        snackbar.onSwipeBlock = { (snackbar, direction) in

            if direction == .right {
                snackbar.animationType = .slideFromLeftToRight
            } else if direction == .left {
                snackbar.animationType = .slideFromRightToLeft
            } else if direction == .up {
                snackbar.animationType = .slideFromTopBackToTop
            } else if direction == .down {
                snackbar.animationType = .slideFromTopBackToTop
            }

            snackbar.dismiss()
        }

        snackbar.layer.cornerRadius = 10.0

        snackbar.animationDuration = 0.5

        snackbar.animationType = animation
        snackbar.show()
    }
}

// MARK: UIAlertController
extension Alert {
    
    /// Show normal ok - cancel alert with action
    ///
    /// - Parameters:
    ///   - title: Alert title
    ///   - actionOkTitle: Ok action button title
    ///   - actionCancelTitle: Cancel action button title
    ///   - message: Alert message
    ///   - completion: Action completion return true if action is ok else false for cancel
    func showAlert(_ title : String = "CarRental"/* Bundle.appName() */, actionOkTitle : String = "Ok" , actionCancelTitle : String = "" , message : String, completion: ((Bool) -> ())? ) {
        
        let alert : UIAlertController = UIAlertController(title: "", message: message , preferredStyle: .alert)
        
        let actionOk : UIAlertAction = UIAlertAction(title: actionOkTitle, style: .destructive) { (action) in
            if completion != nil {
                completion!(true)
            }
        }
        alert.addAction(actionOk)
        
        if actionCancelTitle != "" {
            let actionCancel : UIAlertAction = UIAlertAction(title: actionCancelTitle, style: .cancel) { (action) in }
            alert.addAction(actionCancel)
        }
        
        alert.view.tintColor = UIColor.black
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
    /// Show alert for multiple button action
    ///
    /// - Parameters:
    ///   - title: Alert title
    ///   - message: Alert message
    ///   - actionTitles: Array of button action title
    ///   - actions: Array of UIAlertAction actions
    func showAlert(title: String = "CarRental", message: String, actionTitles:[String], actions:[((UIAlertAction) -> Void)]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: .default, handler: actions[index])
            alert.addAction(action)
        }
        alert.view.tintColor = UIColor.black
        UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
    }
    
    func showingHud() {
        // self.startAnimating(type: .circleStrokeSpin, color: UIColor.black, backgroundColor: UIColor.black.withAlphaComponent(0.25))
    }
    
    //FIXME:-
    func hidingHud() {
        //self.stopAnimating()
    }
}
