//
//  MapViewController.swift
//  StudentApp
//
//  Created by Eliav Menachi on 15/06/2022.
//

import UIKit
import MapKit

class MyAnnotation: NSObject, MKAnnotation{
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    let pet: Pet?
    init(coordinate: CLLocationCoordinate2D, pet: Pet){
        self.coordinate = coordinate
        self.pet = pet
        self.title = pet.name
        self.subtitle = pet.desc
    }
}


class MyAnnotationView: MKMarkerAnnotationView{
    override var annotation: MKAnnotation? {
        willSet {
            guard let myAnno = newValue as? MyAnnotation else {
                return
            }
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            glyphText = myAnno.pet?.name
            // TODO: maybe load pet image
//            glyphImage = UIImage(named: "icons8-apple-logo-30")
        }
    }
}



class MapViewController: UIViewController, MKMapViewDelegate {
    
    var data = [Pet]()
    var selectedPet: Pet?
    
    @IBOutlet weak var mapView: MKMapView!
    
    private let locationManager = CLLocationManager()
    private var currentLocationCoor: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLocationServices()
        
        mapView.delegate = self
        
        mapView.register(MyAnnotationView.self, forAnnotationViewWithReuseIdentifier: "MyAnnotation")
        Model.petDataNotification.observe {
            self.loadAnnotations()
        }
        loadAnnotations()
    }
    
    func loadAnnotations() {
        Model.instance.getAllPets(){
            pets in
            self.data = pets
            
            for pet in pets {
                if (pet.latitude != 0 && pet.longtitude != 0) && (pet.latitude != nil && pet.longtitude != nil){
                    let coor = CLLocationCoordinate2D(latitude: pet.latitude!, longitude: pet.longtitude!)
                    let ann = MyAnnotation(coordinate: coor, pet: pet)
                    self.mapView.addAnnotation(ann)
                }
            }
        }
    }
    
    
    func mapView(_ mapView:MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        
        guard let annotation = annotation as? MyAnnotation else {
            return nil
        }
        
        var view: MKMarkerAnnotationView
        if let dview = mapView.dequeueReusableAnnotationView(withIdentifier: "MyAnnotation") as? MKMarkerAnnotationView{
            view = dview
        }else{
            view = MyAnnotationView(annotation: annotation, reuseIdentifier: "MyAnnotation")
        }
        return view
    }
    
    func mapView(_ mapView:MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped: UIControl){
        guard let annotation = annotationView.annotation as? MyAnnotation else{
            return
        }
        selectedPet = annotation.pet
        performSegue(withIdentifier: "ShowPetDetailsFromMap", sender: self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "ShowPetDetailsFromMap"){
            let dvc = segue.destination as! PetDetailsViewController
            dvc.pet = selectedPet
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer{
        let polyRender = MKPolylineRenderer(overlay: overlay)
        polyRender.strokeColor = .red
        polyRender.lineWidth = 8
        return polyRender
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
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 100000, longitudinalMeters: 100000)
        
        mapView.setRegion(region, animated: true)
    }
    
}


extension MapViewController: CLLocationManagerDelegate{
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

