//
//  StateStatViewController.swift
//  Covid-19
//
//  Created by Connor on 4/21/20.
//  Copyright © 2020 Connor Sullivan. All rights reserved.
//

import UIKit
import MapKit


class StateStatViewController: UIViewController {
    
    var state: StateCases!
    let regionDistance: CLLocationDistance = 500000
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var confirmedCasesLabel: UILabel!
    @IBOutlet weak var deathsLabel: UILabel!
    @IBOutlet weak var recoveredLabel: UILabel!
    @IBOutlet weak var activeCasesLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if state == nil {
            state = StateCases(Province: "", City: "", Lat: "", Lon: "", Confirmed: 0, Deaths: 0, Recovered: 0, Active: 0, Date: "")
        }
        
        stateLabel.text = state.Province
        confirmedCasesLabel.text = "\(state.Confirmed)"
        deathsLabel.text = "\(state.Deaths)"
        recoveredLabel.text = "\(state.Confirmed)"
        activeCasesLabel.text = "\(state.Active)"
        updateMap()

    }
    
    
    func updateMap() {
        
        var coordinates: CLLocationCoordinate2D {
            let latString = Double(state.Lat) ?? 0
            let latitude = CLLocationDegrees(exactly: latString)
            let lonString = Double(state.Lon) ?? 0
            let longitude = CLLocationDegrees(exactly: lonString)
            return CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        }
        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        mapView.setRegion(region, animated: true)
    }

}
