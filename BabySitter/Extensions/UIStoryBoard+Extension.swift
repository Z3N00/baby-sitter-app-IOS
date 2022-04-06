//
//  UIStoryBoard+Extension.swift


import Foundation
import UIKit

extension UIStoryboard {
    
    //App bundle
    private static var bundle: Bundle {
        return Bundle.main
    }
    
    /**
     Main storyboard
     */
    static var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: bundle)
    }
    
    
    /**
     Instantiate View Controller from selected storyboard
     - Returns: View Controller
     - Parameter name: Instantiate View Controller Name
     */
    func instantiateViewController<T: UIViewController>(withClass name: T.Type) -> T? {
        return instantiateViewController(withIdentifier: String(describing: name)) as? T
    }
    
    func viewController<T : UIViewController>(viewControllerClass : T.Type, function : String = #function, line : Int = #line, file : String = #file) -> T {
        
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        
        guard let scene = self.instantiateViewController(withIdentifier: storyboardID) as? T else {
            
            fatalError("ViewController with identifier \(storyboardID), not found in \(self) Storyboard.\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
        }
        
        return scene
    }
}
