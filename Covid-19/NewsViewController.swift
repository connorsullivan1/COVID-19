//
//  ViewController.swift
//  Covid-19
//
//  Created by Connor on 4/15/20.
//  Copyright © 2020 Connor Sullivan. All rights reserved.
//

import UIKit
import SafariServices
import SkeletonView

class NewsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var contentView: UIView!
    
    var newsInfo = NewsInfo()
    var sources = Sources()
    
    var sourceList = "&sources="
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        loadData {
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        newsInfo.getData(sourceList: sourceList) {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.isHidden = false
            }
        }
    }
    
    func loadData(completed: @escaping () -> ()) {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("sources").appendingPathExtension("json")

        guard let data = try? Data(contentsOf: documentURL) else {return}
        let jsonDecoder = JSONDecoder()
        do {
            sourceList = try jsonDecoder.decode(String.self, from: data)
        } catch {
            print("error couldn't load data \(error.localizedDescription)")
        }
        completed()
    }
    
    @IBAction func unwindFromSelectSources(segue: UIStoryboardSegue){
        let source = segue.source as! SelectSourcesViewController
        sourceList = source.sourceList
        newsInfo.newsArticles = []
        newsInfo.imageArray = []
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignOut" {
            let destination = segue.destination as! InfoViewController
            destination.signOut()
        }
    }
}


extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsInfo.newsArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsTableViewCell
        cell.publisherLabel.text = newsInfo.newsArticles[indexPath.row].source
        cell.titleLabel.text = newsInfo.newsArticles[indexPath.row].title
        cell.descriptionLabel.text = newsInfo.newsArticles[indexPath.row].description
        if newsInfo.imageArray[indexPath.row].pngData() == UIImage(systemName: "person.crop.circle.badge.xmark")?.pngData() {
            cell.photoImageView.isHidden = true
        } else { cell.photoImageView.image = newsInfo.imageArray[indexPath.row] }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urlString = self.newsInfo.newsArticles[indexPath.row].url
        if let url = URL(string: urlString) {
            let configuration = SFSafariViewController.Configuration()
            configuration.entersReaderIfAvailable = false
            let article = SFSafariViewController(url: url, configuration: configuration)
            present(article, animated: true, completion: nil)
        }
        
    }
}

