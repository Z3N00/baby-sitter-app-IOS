//
//  ViewController.swift
//  BabySitter
//

import UIKit

class SplashVC: UIViewController {
    
    //MARK:- Outlet
    
    @IBOutlet weak var imgBabySitter: UIImageView!
    @IBOutlet weak var imgParent: UIImageView!
    
    
    //MARK:- Class Variable
    
    //MARK:- Custom Method
    
    func setUpView(){
        self.applyStyle()
    }
    
    func applyStyle(){
        
        self.imgParent.isUserInteractionEnabled = true
        self.imgBabySitter.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer()
        tap.addAction {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: SignInVC.self) {
                vc.isSitter = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        let tap1 = UITapGestureRecognizer()
        tap1.addAction {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: SignInVC.self) {
                vc.isSitter = false
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        self.imgBabySitter.addGestureRecognizer(tap)
        self.imgParent.addGestureRecognizer(tap1)
    }
    
    //MARK:- Action Method
    
    //MARK:- Delegates
    
    //MARK:- UILifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
}


@IBDesignable
public class Gradient: UIView {
    @IBInspectable var startColor:   UIColor = .black { didSet { updateColors() }}
    @IBInspectable var endColor:     UIColor = .white { didSet { updateColors() }}
    @IBInspectable var startLocation: Double =   0.05 { didSet { updateLocations() }}
    @IBInspectable var endLocation:   Double =   0.95 { didSet { updateLocations() }}
    @IBInspectable var horizontalMode:  Bool =  false { didSet { updatePoints() }}
    @IBInspectable var diagonalMode:    Bool =  false { didSet { updatePoints() }}
    
    override public class var layerClass: AnyClass { CAGradientLayer.self }
    
    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }
    
    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? .init(x: 1, y: 0) : .init(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 0, y: 1) : .init(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? .init(x: 0, y: 0) : .init(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 1, y: 1) : .init(x: 0.5, y: 1)
        }
    }
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updatePoints()
        updateLocations()
        updateColors()
    }
    
}

