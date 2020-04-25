//
//  GlobalStats.swift
//  Covid-19
//
//  Created by Connor on 4/20/20.
//  Copyright © 2020 Connor Sullivan. All rights reserved.
//

import Foundation

struct Country: Codable {
    var Country: String
    var CountryCode: String
    var Slug: String
    var NewConfirmed: Int
    var TotalConfirmed: Int
    var NewDeaths: Int
    var NewRecovered: Int
    var TotalDeaths: Int
    var TotalRecovered: Int
    var Date: String
}

class GlobalStats {
    
    private struct Returned: Codable {
        var Global: Global
        var Countries: [Country]
    }
    
    private struct formattedGlobal {
        var Country: String
        var CountryCode: String
        var TotalConfirmed: Int
        var NewDeaths: Int
        var TotalDeaths: Int
        var NewRecovered: Int
        var TotalRecovered: Int
    }
    
    private struct Global: Codable {
        var NewConfirmed: Int
        var TotalConfirmed: Int
        var NewDeaths: Int
        var TotalDeaths: Int
        var NewRecovered: Int
        var TotalRecovered: Int
    }
    
    var countryStats: [Country] = []
    
    
    var url = "https://api.covid19api.com/summary"
    
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
                let returned = try JSONDecoder().decode(Returned.self, from: data!)
                
                self.countryStats = returned.Countries
                let global = Country(Country: "Global", CountryCode: "Global", Slug: "Global", NewConfirmed: returned.Global.NewConfirmed, TotalConfirmed: returned.Global.TotalConfirmed, NewDeaths: returned.Global.NewDeaths, NewRecovered: returned.Global.NewRecovered, TotalDeaths: returned.Global.TotalDeaths, TotalRecovered: returned.Global.TotalRecovered, Date: "\(Date())")
                self.countryStats.insert(global, at: 0)
                
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

