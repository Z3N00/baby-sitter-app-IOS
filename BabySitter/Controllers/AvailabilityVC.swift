//
//  AvailabilityVC.swift
//  BabySitter
//
//  Created by 2021M05 on 22/03/22.
//

import UIKit
import FSCalendar

class AvailabilityVC: UIViewController {

    //MARK:- Outlet
    @IBOutlet weak var startDateCalendar: FSCalendar!
    
    @IBOutlet weak var endDateCalendar: FSCalendar!
    
    //MARK:- Class Variable
    var data: SitterModel!
    
    //MARK:- Custom Method
    
    func setUpView(){
        self.applyStyle()
        
        self.startDateCalendar.delegate = self
        self.startDateCalendar.dataSource = self
        
        self.endDateCalendar.delegate = self
        self.endDateCalendar.dataSource = self
    }
    
    func applyStyle(){
        
    }
    
    //MARK:- Action Method
    @IBAction func btnProccedTapped(_ sender: Any) {
        if let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "AddItemVC") as? AddItemVC {
            vc.data = self.data
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    //MARK:- Delegates
    
    //MARK:- UILifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }

}

extension AvailabilityVC: FSCalendarDelegate,FSCalendarDataSource {
    
}
