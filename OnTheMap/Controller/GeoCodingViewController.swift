//
//  GeoCodingViewController.swift
//  OnTheMap
//
//  Created by Tracy Adams on 11/28/23.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class GeoCodingViewController: UIViewController {
    
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    var locationText: String?
    let geocoder = CLGeocoder()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let location = locationText {
            // Make a network request to a geocoding service using the location value
            // Handle the response and update the map view accordingly
            geocoder.geocodeAddressString(location) { (placemarks, error) in
                if let error = error {
                    // Handle any errors that occurred during geocoding
                    print("Geocoding error: \(error.localizedDescription)")
                    return
                }
                
                if let placemark = placemarks?.first {
                    // Access the location information from the placemark
                    let location = placemark.location
                    let coordinate = location?.coordinate
                    if let latitude = coordinate?.latitude, let longitude = coordinate?.longitude {
                        // Use the coordinate to place the location on the map
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        self.mapView.addAnnotation(annotation)
                        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                        self.mapView.setRegion(region, animated: true)
                    } else {
                        // Handle the case when either latitude or longitude is nil
                        print("Error: Invalid latitude or longitude")
                    }
                    
                }
            }
        }
    }
    
    
    @IBAction func cancel(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func linkToShare(_ sender: UITextField) {
        
    }
    
    @IBAction func submit(_ sender: UIButton) {
        // Perform geocoding request here
        if let location = locationText {
            // Make a network request to a geocoding service using the location value
            // Handle the response and update the map view accordingly
            geocoder.geocodeAddressString(location) { (placemarks, error) in
                if let error = error {
                    // Handle any errors that occurred during geocoding
                    print("Geocoding error: \(error.localizedDescription)")
                    return
                }
                
                if let placemark = placemarks?.first {
                    // Access the location information from the placemark
                    let location = placemark.location
                    let coordinate = location?.coordinate
                    if let latitude = coordinate?.latitude, let longitude = coordinate?.longitude {
                        // Use the coordinate to place the location on the map
                        //                        let annotation = MKPointAnnotation()
                        //                        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                        //                        self.mapView.addAnnotation(annotation)
                        //                        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                        //                        self.mapView.setRegion(region, animated: true)
                        //API CALL here:
                        //What do I do with the unique key, and name fields?
                        UdacityClient.postStudentLocation(uniqueKey: "1234", firstName: "John", lastName: "Doe", mapString: self.locationText!, mediaURL: self.linkTextField.text!, latitude: latitude, longitude: longitude) { success, error in
                            if success {
                                print("added student successfully")
                            }
                            else{
                                print("nah")
                            }
                        }
                        
                    } else {
                        // Handle the case when either latitude or longitude is nil
                        print("Error: Invalid latitude or longitude")
                    }
                    
                }
            }
        }
        
        //back to map view
        performSegue(withIdentifier: "backToMap", sender: nil)
        
    }
    
    
}

