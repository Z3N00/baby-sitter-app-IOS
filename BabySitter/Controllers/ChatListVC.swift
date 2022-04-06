//
//  ChatListVC.swift
//  BabySitter
//
//  Created by 2021M05 on 31/03/22.
//

import UIKit

class ChatListTVC: UITableViewCell {
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: GradientLabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var vwMain: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.applyStyle()
    }
    
    func applyStyle() {
        self.imgProfile.layer.cornerRadius = 14.0
        
        self.lblName.gradientColors = [UIColor().hexStringToUIColor(hex: "#6043F5").cgColor,UIColor().hexStringToUIColor(hex: "#836EF1").cgColor]
        self.lblName.font = UIFont.customFont(ofType: .medium, withSize: 18)
        
        self.lblStatus.font = UIFont.customFont(ofType: .regular, withSize: 18)
        self.lblStatus.textColor = UIColor().hexStringToUIColor(hex: "#A4A4AC")
        
        self.lblMessage.font = UIFont.customFont(ofType: .regular, withSize: 18)
        self.lblMessage.textColor = UIColor().hexStringToUIColor(hex: "#A4A4AC")
    }
}

class ChatListVC: UIViewController {

    //MARK:- Outlet
    @IBOutlet weak var tblView: UITableView!
    
    //MARK:- Class Variable
    
    //MARK:- Custom Method
    
    func setUpView(){
        self.applyStyle()
        
        self.tblView.delegate = self
        self.tblView.dataSource = self
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

extension ChatListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListTVC") as! ChatListTVC
        cell.selectionStyle = .none
        return cell
    }
    
    
}
