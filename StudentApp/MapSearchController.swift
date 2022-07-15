//
//  MapSearchController.swift
//  StudentApp
//
//  Created by admin on 15/07/2022.
//

import Foundation
import MapKit
import SwiftUI


class MapSearchController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    
    private let locationManager = CLLocationManager()
    private var currentLocationCoor: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLocationServices()
        
        mapView.delegate = self
        
        mapView.register(MyAnnotationView.self, forAnnotationViewWithReuseIdentifier: "MyAnnotation")
        
        
    }
    
    @IBAction func onSearchLocation(_ sender: Any) {
        let searchRequest = MKLocalSearch.Request()
        
        searchRequest.naturalLanguageQuery = searchText.text
        
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { response, error in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            
            guard let responseCoor = response.mapItems.first?.placemark.coordinate else {return}
            
            self.zoomToLatestLocation(with: responseCoor)
            
            self.currentLocationCoor = responseCoor
        }
        
    }
    // Current location
    private func configureLocationServices() {
        locationManager.delegate = self
        
        let status = CLLocationManager.authorizationStatus()
        
        if status == .notDetermined{
            locationManager.requestWhenInUseAuthorization()
        } else if status == .authorizedAlways || status == .authorizedWhenInUse{
            beginLocationUpdates(locationManager: locationManager)
        }
    }
    
    private func beginLocationUpdates(locationManager: CLLocationManager){
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    private func zoomToLatestLocation(with coordinate: CLLocationCoordinate2D){
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        
        mapView.setRegion(region, animated: true)
    }
}


extension MapSearchController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        guard let latestLocation = locations.first else {return}
        
        if currentLocationCoor == nil {
            zoomToLatestLocation(with: latestLocation.coordinate)
        }
        
        currentLocationCoor = latestLocation.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse{
            beginLocationUpdates(locationManager: manager)
        }
    }
}
