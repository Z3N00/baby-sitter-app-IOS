//
//  ConfirmBookingPopup.swift
//  BabySitter
//
//  Created by 2021M05 on 20/03/22.
//

import UIKit

class ConfirmBookingPopup: UIViewController {

    //MARK:- Outlet
    @IBOutlet weak var vwBack: UIView!
    
    //MARK:- Class Variable
    var timer : Timer!
    var count = 5
    //MARK:- Custom Method
    
    func setUpView(){
        self.view.isOpaque = true
        self.view.backgroundColor = UIColor.white.withAlphaComponent(CGFloat(0.3))
        self.applyStyle()
    }
    
    func applyStyle(){
        self.vwBack.layer.cornerRadius = 17
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timeString), userInfo: nil, repeats: true)
    }
    
    
    @objc func timeString() {
        self.count -= 1
        
        if self.count == 0 {
            UIApplication.shared.setHome()
        }
    }
    
    
    //MARK:- Action Method
    
    //MARK:- Delegates
    
    //MARK:- UILifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }
}
