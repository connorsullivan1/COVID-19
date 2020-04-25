//
//  DiscussionForumViewController.swift
//  Covid-19
//
//  Created by Connor on 4/20/20.
//  Copyright © 2020 Connor Sullivan. All rights reserved.
//

import UIKit

class DiscussionForumViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var posts: DiscussionPosts!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        posts = DiscussionPosts()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        posts.loadData {
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPostSegue" {
            let destination = segue.destination as! DiscussionPostViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.post = posts.postArray[selectedIndexPath.row]
            print("***\(posts.postArray[selectedIndexPath.row].title)")
        }
        
        if segue.identifier == "SignOut" {
            let destination = segue.destination as! InfoViewController
            destination.signOut()
        }
    }
}

extension DiscussionForumViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = posts.postArray[indexPath.row].title
        return cell
    }
}
