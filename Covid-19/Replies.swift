//
//  Replies.swift
//  Covid-19
//
//  Created by Connor on 4/19/20.
//  Copyright © 2020 John Gallaugher. All rights reserved.
//

import Foundation
import Firebase

class Replies{
    var replyArray: [Reply] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(post: DiscussionPost, completed: @escaping () -> ()) {
        guard post.documentID != "" else {
            return
        }
        db.collection("discussion").document(post.documentID).collection("replies").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                return completed()
            }
            self.replyArray = []
            
            for document in querySnapshot!.documents {
                let reply = Reply(dictionary: document.data())
                reply.documentID = document.documentID
                self.replyArray.append(reply)
            }
            completed()
        }
    }
}
