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
    let type: String
    // TODO: add on click some	how
    init(coordinate: CLLocationCoordinate2D,
         title: String, subtitle:String, type: String){
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.type = type
    }
    
    // TODO: delete this
    var markerTintColor: UIColor  {
        switch type {
        case "CLASS":
            return .red
        case "LAB":
            return .cyan
        default:
            return .green
        }
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
            
            markerTintColor = myAnno.markerTintColor
            //            if let letter = myAnno.type.first {
            //                glyphText = String(letter)
            //            }
            glyphImage = UIImage(named: "icons8-apple-logo-30")
        }
    }
}



class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLocationServices()
        
        mapView.delegate = self
        
        mapView.register(MyAnnotationView.self, forAnnotationViewWithReuseIdentifier: "MyAnnotation")
        
        
        // TODO: change to current location
        let center = CLLocationCoordinate2D(latitude: 31.970669, longitude: 34.771442)
        
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 100, longitudinalMeters: 100)
        
        mapView.setRegion(region, animated: true)
        
        // TODO: add pets locations
        let loc1 = MyAnnotation(coordinate: center, title: "Computer Science", subtitle: "ios class", type: "LAB")
        
        let lo2 = CLLocationCoordinate2D(latitude: 31.970669, longitude: 34.772442)
        let loc2 = MyAnnotation(coordinate: lo2, title: "Computer Science", subtitle: "android class", type: "AND")
        
        mapView.addAnnotations([loc1,loc2])
        
        createLine()
    }
    
    // TODO: delete this I think
    func createLine(){
        let locations = [CLLocationCoordinate2D(latitude: 31.970669, longitude: 34.772442),
                         CLLocationCoordinate2D(latitude: 31.958965, longitude: 34.770455),
                         CLLocationCoordinate2D(latitude: 31.958975, longitude: 34.770455),
                         CLLocationCoordinate2D(latitude: 31.958985, longitude: 34.770455),
                         CLLocationCoordinate2D(latitude: 31.958995, longitude: 34.770455),
                         CLLocationCoordinate2D(latitude: 31.959995, longitude: 34.770465),
                         CLLocationCoordinate2D(latitude: 31.958995, longitude: 34.770475),
                         CLLocationCoordinate2D(latitude: 31.958999, longitude: 34.770485),
                         CLLocationCoordinate2D(latitude: 31.970669, longitude: 34.771442)]
        
        let polyline = MKPolyline(coordinates: locations, count: locations.count)
        
        mapView.addOverlay(polyline)
        
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
        NSLog("annotation accessort click:  \(annotation.subtitle)")
        
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
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
}


extension MapViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("aaa")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("bbb")
    }
}

