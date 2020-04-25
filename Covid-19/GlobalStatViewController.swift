//
//  GlobalStatViewController.swift
//  Covid-19
//
//  Created by Connor on 4/20/20.
//  Copyright © 2020 Connor Sullivan. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseUI
import GoogleSignIn

class GlobalStatViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    var globalStats = GlobalStats()
    var authUI: FUIAuth!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        authUI = FUIAuth.defaultAuthUI()
        
        
        globalStats.getData {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        mapView.setCenter(CLLocationCoordinate2D(latitude: 42.348760, longitude: -71.154600), animated: true)
        mapView.setVisibleMapRect(.world, animated: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if authUI.auth?.currentUser == nil {
            print("not signed in!!!")
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCountryDetail" {
            let destination = segue.destination as! CountryViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.country = globalStats.countryStats[selectedIndexPath.row]
        } else {
            let destination = segue.destination as! InfoViewController
            destination.signOut()
        }
    }
}

extension GlobalStatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return globalStats.countryStats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = globalStats.countryStats[indexPath.row].Country
        return cell
    }
}

