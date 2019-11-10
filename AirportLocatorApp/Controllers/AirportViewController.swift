//
//  ALMapViewController.swift
//  AirportLocatorApp
//
//  Created by Bilal Sattar on 09/11/2019.
//  Copyright © 2019 Bilal Sattar. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AirportViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
// TODO: APP Configuration
//  let app = AppConfiguration.sharedInstance.productionGoogleApiKey;
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBAction func focusMapView() {
        
        guard let locValue: CLLocationCoordinate2D = locManager.location?.coordinate else { return }
        let mapCenter = CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude)
        let region = MKCoordinateRegion(center: mapCenter, span: MKCoordinateSpan(latitudeDelta: 0.300, longitudeDelta: 0.300))
        mapView.setRegion(region, animated: true)
        mapView.setCenter(mapCenter, animated: true)
        mapView.region = region
        
    }
    
    // init Location
    let locManager = CLLocationManager()
    var lat : String?
    var lng : String?
    var from, to: CLLocation?
    
    let viewModel = AirportLocatorViewModel(airportLocationService: LocationService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        
        // Setting for Location
        self.locManager.requestAlwaysAuthorization()
        self.locManager.requestWhenInUseAuthorization()
        getCurrentLocation()
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.showsUserLocation = true
        activityIndicator?.hidesWhenStopped = true
        
        viewModel.register(view: self)
        
        self.onStartLoading()
    }
    
    //MARK: Current Location Access
    func getCurrentLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locManager.desiredAccuracy = kCLLocationAccuracyBest
            locManager.startUpdatingLocation()
            locManager.delegate = self
            
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                self.lat = "0.0"
                self.lng = "0.0"
            case .authorizedAlways, .authorizedWhenInUse:
                guard let currentLocation = locManager.location else {
                    return
                }
                self.lat = String(currentLocation.coordinate.latitude)
                self.lng = String(currentLocation.coordinate.longitude)
                viewModel.getAirportList(lat:lat ?? "0.0", lng:lng ?? "0.0")
            }
        } else {
            // TODO: Error Handling
            NSLog("Error Handling")
        }
    }
    
    //MARK: CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // TODO: Handle Location Update
    }
    
    //MARK: MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotationIdentifier = "Identifier"
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        if let annotationView = annotationView {
            let imageName = annotation.title == "My Location" ? "me" : "pin"
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: imageName)
        }
        return annotationView
    }
}

//MARK: - Extension
extension AirportViewController: MapViewDelegate {
    
    func onStartLoading() {
        activityIndicator?.startAnimating()
    }
    
    func onEndLoading() {
        activityIndicator?.stopAnimating()
    }
    
    func onSuccess(list: AirportListModel) {
        if list.isSuccess == true {
            let annotations = list.results.map { location -> MKAnnotation in
                var title = "";
                var distance = "";
                
                if let currentLocation = locManager.location {
                    let CLCoordinates = CLLocation(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
                    let coordinateDistance = CLLocation(latitude: location.latitude, longitude: location.longitude)
                    let distanceInMeters = coordinateDistance.distance(from: CLCoordinates)
                    if distanceInMeters < 1000 {
                        let strDistance = String(format: "%.2f", distanceInMeters)
                       distance = "Distance: " + strDistance + "M"
                    }
                    else {
                        let distanceAsString = String(format: "%.2f", (distanceInMeters/1000))
                        distance = "Distance: " + distanceAsString + "KM"
                    }
                    
                    title = location.name
                }
                
                let annotation = CustomPin(title: title, subtitle:distance,  coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
                
                return annotation
            }
            
            self.mapView.addAnnotations(annotations)
            self.focusMapView()
        }
    }
    
    func onFailure(Message: String) {
        NSLog("Error handling")
    }
}
