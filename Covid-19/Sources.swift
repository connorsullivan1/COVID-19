//
//  Source.swift
//  Covid-19
//
//  Created by Connor on 4/19/20.
//  Copyright © 2020 Connor Sullivan. All rights reserved.
//

import Foundation

class Sources {
    
    private struct Result: Codable {
        var status: String
        var sources: [Sources]
    }
    
    struct Sources: Codable {
        var name: String
        var id: String
    }
    
    var sources: [Sources] = []
    
    var sourcesURL = "https://newsapi.org/v2/sources?country=us&apiKey=159380ac43504fd08a3747ab51b98bf1"
    
    func getData(completed: @escaping () -> ()) {
        let urlString = sourcesURL
        //Create URL
        guard let url = URL(string: urlString) else {
            print("ERROR: Couldnt Not Create a URL from \(urlString)")
            completed()
            return
        }
        
        //Create Session
        let session = URLSession.shared
        
        // Get data with .dataTask Method
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
            }
            do{
                let result = try JSONDecoder().decode(Result.self, from: data!)
                self.sources = result.sources
            }
            catch {
                print("JSON ERROR:\(error.localizedDescription)")
            }
            completed()
        }
        task.resume()
    }
}

