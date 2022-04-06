//
//  UserModel.swift
//  BabySitter
//
//  Created by 2022M3 on 27/03/22.
//

import Foundation



class UserModel {
    
    var name:String
    var phone:String
    var email:String
    var password:String
    var isSitter:Bool
    var address: String
    var docId: String
    var rating: String
    
    init(docId:String, name:String, email:String, phone:String, password:String, address: String, isSitter:Bool,rating: String) {
        self.docId = docId
        self.name = name
        self.address = address
        self.isSitter = isSitter
        self.password = password
        self.phone = phone
        self.email = email
        self.rating = rating
    }

}
