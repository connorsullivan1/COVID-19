//
//  DiscussionPost.swift
//  Covid-19
//
//  Created by Connor on 4/20/20.
//  Copyright © 2020 Connor Sullivan. All rights reserved.
//

import Foundation
import Firebase

class DiscussionPost {
    var title: String
    var post: String
    var score: Int
    var date: Date
    var postingUserID: String
    var documentID: String
    
    var dictionary: [String: Any] {
        let timeIntervalDate = date.timeIntervalSince1970
        return ["title": title, "post": post, "score": score, "date": timeIntervalDate, "postingUserID": postingUserID, "documentID": documentID]
    }
    
    init(title: String, post: String, score: Int, date: Date, postingUserID: String, documentID: String) {
        self.title = title
        self.post = post
        self.score = score
        self.date = date
        self.postingUserID = postingUserID
        self.documentID = documentID
    }
    
    convenience init(dictionary: [String: Any]) {
        let title = dictionary["title"] as! String? ?? ""
        let post = dictionary["post"] as! String? ?? ""
        let score = dictionary["score"] as! Int? ?? 0
        let timeIntervalDate = dictionary["date"] as! TimeInterval? ?? TimeInterval()
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        let documentID = dictionary["documentID"] as! String? ?? ""
        let date = Date(timeIntervalSince1970: timeIntervalDate)
        
        self.init(title: title, post: post, score: score, date: date, postingUserID: postingUserID, documentID: documentID)
    }
    
    convenience init() {
        self.init(title: "", post: "", score: 0, date: Date(), postingUserID: "", documentID: "")
    }
    
    func saveData(completion: @escaping (Bool) -> ())  {
        let db = Firestore.firestore()
        // Grab the user ID
        guard let postingUserID = (Auth.auth().currentUser?.uid) else {
            print("*** ERROR: Could not save data because we don't have a valid postingUserID")
            return completion(false)
        }
        self.postingUserID = postingUserID
        // Create the dictionary representing data we want to save
        let dataToSave: [String: Any] = self.dictionary
        // if we HAVE saved a record, we'll have an ID
        if self.documentID != "" {
            let ref = db.collection("discussion").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("ERROR: updating document \(error.localizedDescription)")
                    completion(false)
                } else { // It worked!
                    completion(true)
                }
            }
        } else { // Otherwise create a new document via .addDocument
            var ref: DocumentReference? = nil // Firestore will creat a new ID for us
            ref = db.collection("discussion").addDocument(data: dataToSave) { (error) in
                if let error = error {
                    print("ERROR: adding document \(error.localizedDescription)")
                    completion(false)
                } else { // It worked! Save the documentID in Review's documentID property
                    self.documentID = ref!.documentID
                    completion(true)
                }
            }
        }
    }
}
