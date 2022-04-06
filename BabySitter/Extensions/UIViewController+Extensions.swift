//
//  UIViewController+Extensions.swift


import UIKit
import SafariServices
import AVKit

extension UIViewController {
    ///Life Cycle.
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.modalPresentationStyle = .overFullScreen
    }
    
    ///Return status bar height.
    public var statusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            // Fallback on earlier versions
            return UIApplication.shared.statusBarFrame.size.height +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
        }
    }
    
    ///Return top bar height : Navigation bar height + status bar height
    var topbarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
        } else {
            // Fallback on earlier versions
            return UIApplication.shared.statusBarFrame.size.height +
                (self.navigationController?.navigationBar.frame.height ?? 0.0)
        }
    }
    
    ///Return storyboard identifier
    class var storyboardID : String {
        return "\(self)"
    }
    
    /**
     To get storyboard view controller instantiate
     
     - Parameter appStoryboard: Pass storyboard
     - Returns: View controller
     
     */
    static func instantiate(fromAppStoryboard appStoryboard: UIStoryboard) -> Self {
        return appStoryboard.viewController(viewControllerClass: self)
    }
    
    /**
     To pop / back view controller
     
     - Parameter sender: AnyObject
     */
    
    @IBAction func popViewController(sender : AnyObject) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /**
     To dismiss view controller
     
     - Parameter sender: AnyObject
     */
    
    @IBAction func dismissViewController(sender : AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /**
     To back root  view controller
     
     - Parameter sender: AnyObject
     */
    @IBAction func popToRootViewController(sender : AnyObject) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension UIViewController: SFSafariViewControllerDelegate {
    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension UIView {

    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
         let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         self.layer.mask = mask
    }

}
