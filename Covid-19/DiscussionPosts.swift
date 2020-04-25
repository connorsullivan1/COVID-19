//
//  DiscussionPosts.swift
//  Covid-19
//
//  Created by Connor on 4/21/20.
//  Copyright © 2020 Connor Sullivan. All rights reserved.
//

import Foundation
import Firebase

class DiscussionPosts {
    var postArray: [DiscussionPost] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ())  {
        db.collection("discussion").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("*** ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.postArray = []
            // there are querySnapshot!.documents.count documents in teh spots snapshot
            for document in querySnapshot!.documents {
                // You'll have to be sure you've created an initializer in the singular class (Spot, below) that acepts a dictionary.
                let post = DiscussionPost(dictionary: document.data())
                post.documentID = document.documentID
                self.postArray.append(post)
            }
            completed()
        }
    }
}
