//
//  DiscussionPostViewController.swift
//  Covid-19
//
//  Created by Connor on 4/21/20.
//  Copyright © 2020 Connor Sullivan. All rights reserved.
//

import UIKit

class DiscussionPostViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UITextView!
    @IBOutlet weak var tableView: UITableView!
    
    
    var post: DiscussionPost!
    var replies: Replies!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        replies = Replies()
        
        
        if post == nil {
            post = DiscussionPost()
        }
        
        titleLabel.text = post.title
        contentLabel.text = post.post
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        replies.loadData(post: post) {
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ReplySegue" {
            let destination = segue.destination as! ReplyViewController
            destination.post = post
        } else {
            let destination = segue.destination as! InfoViewController
            destination.signOut()
        }
    }
}

extension DiscussionPostViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return replies.replyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = replies.replyArray[indexPath.row].text
        cell.detailTextLabel?.text = "Posted by: \(replies.replyArray[indexPath.row].userID)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
