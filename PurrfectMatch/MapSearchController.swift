//
//  MapSearchController.swift
//  PurrfectMatch
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
            currentAnnotaion = MKPointAnnotation()
            currentAnnotaion?.coordinate = currentLocationCoor!
            mapView.addAnnotation(self.currentAnnotaion!)
            zoomToLatestLocation(with: currentLocationCoor!)
        }
        
        
        mapView.delegate = self
        
        navigationController?.delegate = self
        
//        mapView.register(MyAnnotationView.self, forAnnotationViewWithReuseIdentifier: "MyAnnotation")
        
        
    }
    var currentAnnotaion: MKPointAnnotation?
    
    @IBAction func onSearchLocation(_ sender: Any) {
        let searchRequest = MKLocalSearch.Request()
        
        searchRequest.naturalLanguageQuery = searchText.text
        
        searchRequest.region = mapView.region
        
        let search = MKLocalSearch(request: searchRequest)
        
        search.start { response, error in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            
            guard let responseCoor = response.mapItems.first?.placemark.coordinate else {return}
            
            if self.currentAnnotaion != nil{
                self.mapView.removeAnnotation(self.currentAnnotaion!)
            }
            self.currentAnnotaion = MKPointAnnotation()
            self.currentAnnotaion?.coordinate = responseCoor
            self.mapView.addAnnotation(self.currentAnnotaion!)
            
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
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
        
        mapView.setRegion(region, animated: true)
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let vc = viewController as? NewPetViewController
        
        if searchText.text == ""{
            vc?.addressTv.text = String(currentLocationCoor!.latitude) + ", " + String(currentLocationCoor!.longitude)
        } else {
            vc?.addressTv.text = searchText.text
        }
        vc?.addressCoor = currentLocationCoor!
        
        let vc2 = viewController as? EditPetViewController
        
        if searchText.text == ""{
            vc2?.addressEv.text = String(currentLocationCoor!.latitude) + ", " + String(currentLocationCoor!.longitude)
        } else {
            vc2?.addressEv.text = searchText.text
        }
        vc2?.addressCoor = currentLocationCoor!
    }
}


extension MapSearchController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        guard let latestLocation = locations.first else {return}
        
        if currentLocationCoor == nil {
            zoomToLatestLocation(with: latestLocation.coordinate)
        }
        
        currentLocationCoor = latestLocation.coordinate
        self.currentAnnotaion = MKPointAnnotation()
        self.currentAnnotaion?.coordinate = latestLocation.coordinate
        self.mapView.addAnnotation(self.currentAnnotaion!)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse{
            beginLocationUpdates(locationManager: manager)
        }
    }
    
   
}
