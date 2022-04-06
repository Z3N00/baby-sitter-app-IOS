//
//  NootificationModel.swift


import Foundation
class NotificationModel {
    var docID: String
    var email: String
    var message: String
    var name: String
    
    
    init(docId:String, email:String, message:String, name:String) {
        self.docID = docId
        self.email = email
        self.message = message
        self.name = name
    }
}
