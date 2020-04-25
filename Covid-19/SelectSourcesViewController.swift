//
//  SelectSourcesViewController.swift
//  Covid-19
//
//  Created by Connor on 4/20/20.
//  Copyright © 2020 Connor Sullivan. All rights reserved.
//

import UIKit

class SelectSourcesViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var sources = Sources()
    var sourcesBool: [Bool] = []
    var sourceList: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if sourceList == nil {
            sourceList = "&sources="
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sources.getData {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                for _ in 0..<self.sources.sources.count{
                    self.sourcesBool.append(false)
                }
            }
        }
    }
    
    func leaveViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        for i in 0..<sourcesBool.count {
            if sourcesBool[i] == true {
                sourceList.append("\(sources.sources[i].id),")
            }
        }
        sourceList.remove(at: sourceList.index(before: sourceList.endIndex))
        let destination = segue.destination as! NewsViewController
        destination.sourceList = sourceList
        saveData()
        
    }
    
    func saveData() {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("sources").appendingPathExtension("json")
        
        let jsonEncoder = JSONEncoder()
        let data = try? jsonEncoder.encode(sourceList)
        do {
            try data?.write(to:documentURL,options: .noFileProtection)
            
        } catch {
            print("error couldn't save data \(error.localizedDescription)")
        }
    }
    
}



extension SelectSourcesViewController: UITableViewDataSource, UITableViewDelegate, SourcesTableViewCellDelegate {
    
    func checkBoxToggle(sender: SourcesTableViewCell) {
        if let selectedIndexPath = tableView.indexPath(for: sender) {
            sourcesBool[selectedIndexPath.row] = !sourcesBool[selectedIndexPath.row]
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sources.sources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SourcesTableViewCell
        cell.delegate = self
        cell.sourceBool = sourcesBool[indexPath.row]
        cell.sourceLabel.text = sources.sources[indexPath.row].name
        return cell
        
    }
}
