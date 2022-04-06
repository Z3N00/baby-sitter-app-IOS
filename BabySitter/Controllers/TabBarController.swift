//
//  TabBarController.swift
//  BabySitter
//
//  Created by 2021M05 on 22/03/22.
//

import UIKit

class TabBarController: UITabBarController {

    //MARK:- Outlet
    
    //MARK:- Class Variable

    //MARK:- Custom Method
    
    func setUpView(){
        self.applyStyle()
    }
    
    func applyStyle(){
    }
    
    //MARK:- Action Method
    
    //MARK:- Delegates
    
    //MARK:- UILifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }

}
