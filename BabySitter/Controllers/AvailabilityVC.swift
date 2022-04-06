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
    
    //MARK:- Class Variable
    var data: SitterModel!
    
    //MARK:- Custom Method
    
    func setUpView(){
        self.applyStyle()
        
        self.startDateCalendar.delegate = self
        self.startDateCalendar.dataSource = self
        
        self.calendarSetup()
    }
    
    func applyStyle(){
        
    }
    
    func calendarSetup(){
        self.startDateCalendar.appearance.headerTitleColor = .black
        self.startDateCalendar.headerHeight = 45
        
        self.startDateCalendar.appearance.titleTodayColor = .black
        
        self.startDateCalendar.placeholderType = .none
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
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.day = 30

        let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate) ?? Date()
        
        return futureDate
    }
}
