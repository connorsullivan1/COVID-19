//
//  USStats.swift
//  Covid-19
//
//  Created by Connor on 4/20/20.
//  Copyright © 2020 Connor Sullivan. All rights reserved.
//

import Foundation


struct StateCases: Codable {
    var Province: String
    var City: String
    var Lat: String
    var Lon: String
    var Confirmed: Int
    var Deaths: Int
    var Recovered: Int
    var Active: Int
    var Date: String
}

class USStats {
    
    var results: [StateCases] = []
    
    var statesDicitonary: [String: StateCases] = [:]
    
    var states = ["Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"]
    
    var url = "https://api.covid19api.com/live/country/united-states"
    
    func getData(completed: @escaping () -> ()) {
        let urlString = url
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
                let returned = try JSONDecoder().decode([StateCases].self, from: data!)
                self.results = returned
                for state in self.states {
                    for item in self.results {
                        if item.Province == state {
                            self.statesDicitonary[state] = item
                        }
                    }
                }
            }
            catch {
                print("JSON ERROR:\(error.localizedDescription)")
                print(error)
            }
            completed()
        }
        task.resume()
    }
}


