//
//  MapSearchController.swift
//  StudentApp
//
//  Created by admin on 15/07/2022.
//

import Foundation
import MapKit
import SwiftUI

struct Search {
    var text: String?
    var coor: CLLocationCoordinate2D?
}


class MapSearchController: UIViewController, MKMapViewDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    
    private let locationManager = CLLocationManager()
    private var currentLocationCoor: CLLocationCoordinate2D?
    
    var search:Search?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLocationServices()
        
        if search != nil {
            searchText.text = search!.text
            currentLocationCoor = search?.coor
            zoomToLatestLocation(with: currentLocationCoor!)
        }
        
        if searchText.text != nil || searchText.text != "" {
            onSearchLocation(self)
        }
        
        mapView.delegate = self
        
        navigationController?.delegate = self
        
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
    
    @IBAction func onSave(_ sender: Any) {
        navigationController?.popViewController(animated: true)
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
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let vc = viewController as? NewPetViewController
        vc?.addressTv.text = searchText.text
        vc?.addressCoor = currentLocationCoor!
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
