//
//  USStatViewController.swift
//  Covid-19
//
//  Created by Connor on 4/20/20.
//  Copyright © 2020 Connor Sullivan. All rights reserved.
//

import UIKit

class USStatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var stats = USStats()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        stats.getData {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowStateDetail" {
            let destination = segue.destination as! StateStatViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.state = stats.statesDicitonary[stats.states[selectedIndexPath.row]]
        } else {
            let destination = segue.destination as! InfoViewController
            destination.signOut()
        }
    }
    
}

extension USStatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stats.statesDicitonary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = stats.statesDicitonary[stats.states[indexPath.row]]!.Province
        return cell
    }
    
    
}
