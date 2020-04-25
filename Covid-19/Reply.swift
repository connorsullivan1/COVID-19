//
//  Reply.swift
//  Covid-19
//
//  Created by Connor on 4/21/20.
//  Copyright © 2020 Connor Sullivan. All rights reserved.
//
import Foundation
import Firebase

class Reply {
    var text: String
    var userID: String
    var date: Date
    var documentID: String
        
    var dictionary: [String: Any] {
        let timeIntervalDate = date.timeIntervalSince1970
        return ["text":text,"userID":userID,"date":timeIntervalDate, "documentID": documentID, ]
    }
    
    init(text: String, userID: String, date: Date, documentID: String) {
        self.text = text
        self.userID = userID
        self.date = date
        self.documentID = documentID
    }
    
    convenience init (dictionary: [String: Any]) {
        let text = dictionary["text"] as! String? ?? ""
        let userID = dictionary["userID"] as! String? ?? "unknown user"
        let timeIntervalDate = dictionary["date"] as! TimeInterval? ?? TimeInterval()
        let date = Date(timeIntervalSince1970: timeIntervalDate)
        self.init(text: text, userID: userID, date: date, documentID: "")
    }
    
    convenience init() {
        let currentUserID = Auth.auth().currentUser?.email ?? "unknown user"
        self.init(text: "", userID: currentUserID, date: Date(), documentID: "")
    }
    

    
    func saveData(post: DiscussionPost, completed: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        let dataToSave = self.dictionary
        if self.documentID != "" {
            let ref = db.collection("discussion").document(post.documentID).collection("replies").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("***ERROR: updating document\(error.localizedDescription) in spot \(post.documentID)")
                    completed(false)
                } else {
                    print("Document updated \(ref.documentID)")
                    completed(true)
                }
                
            }
            
        } else {
            var ref: DocumentReference? = nil
            ref = db.collection("discussion").document(post.documentID).collection("replies").addDocument(data: dataToSave) { error in
                if let error = error {
                    print("Error creating document \(error.localizedDescription)")
                    completed(false)
                } else {
                    print("Document created\(ref?.documentID ?? "unknown")")
                    completed(true)
                }
                
            }
        }
    }
    
}
