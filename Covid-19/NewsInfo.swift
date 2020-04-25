//
//  NewsInfo.swift
//  Covid-19
//
//  Created by Connor on 3/23/20.
//  Copyright © 2020 Connor Sullivan. All rights reserved.
//  powered by NewsAPI.org
//

import Foundation
import UIKit

class NewsInfo {
    
    let sources = Sources()
    let selectSources = SelectSourcesViewController()
    
    private struct Result: Codable {
        var articles: [Article]
    }
    
    private struct Article: Codable {
        var source: SourceInfo
        var title: String?
        var description: String?
        var url: String?
        var urlToImage: String?
    }
    
    private struct SourceInfo: Codable {
        //var id: String
        var name: String?
    }
    
    
    var newsArticles: [NewsArticle] = []
    var imageArray: [UIImage] = []
    
    func loadImagesIntoArray() { // Recently, all of the urlToImage responses have been null. Waiting to hear back from their support to see if they made that a premium feature.
        
        for i in 0..<newsArticles.count {
            
            var photo = UIImage()
            
            guard newsArticles[i].urlToImage.count > 0 else {
                photo = UIImage(systemName: "person.crop.circle.badge.xmark")!
                imageArray.append(photo)
                continue
            }
            
//            guard !newsArticles[i].urlToImage.contains("null") else {
//                photo = UIImage(systemName: "person.crop.circle.badge.xmark")!
//                imageArray.append(photo)
//                continue
//            }
            
            guard let url = URL(string: newsArticles[i].urlToImage) else {
                photo = UIImage(systemName: "person.crop.circle.badge.xmark")!
                imageArray.append(photo)
                continue
            }
            
            
            do {
                let data = try Data(contentsOf: url)
                photo = UIImage(data: data)!
            } catch {
                print("***Photo Error \(error)")
            }
            imageArray.append(photo)
        }
        
    }
    
    
    
    func getData(sourceList: String, completed: @escaping () -> ()) {
        
        let url = "https://newsapi.org/v2/everything?q=(%22covid-19%22OR%22coronavirus%22)&language=en\(sourceList)&pageSize=40&apiKey=\(APIkeys.newsAPI)"
        
        //Create URL
        guard let urlString = URL(string: url) else {
            print("ERROR: Couldnt Not Create a URL from \(url)")
            completed()
            return
        }
        
        //Create Session
        let session = URLSession.shared
        
        // Get data with .dataTask Method
        let task = session.dataTask(with: urlString) { (data, response, error) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            }
            do{
                let result = try JSONDecoder().decode(Result.self, from: data!)
                for i in 0..<result.articles.count {
                    let source = result.articles[i].source.name ?? "unavailable"
                    let title = result.articles[i].title ?? "unavailable"
                    let description = result.articles[i].description ?? "unavailable"
                    let url = result.articles[i].url ?? ""
                    let urlToImage = result.articles[i].urlToImage ?? ""
                    self.newsArticles.append(NewsArticle(source: source, title: title, description: description, url: url, urlToImage: urlToImage))
                }
                self.loadImagesIntoArray()
                for item in self.newsArticles {
                    print(item.source)
                }
            }
            catch {
                print("***JSON ERROR:\(error.localizedDescription)")
                print(error)
            }
            completed()
        }
        task.resume()
    }
}
