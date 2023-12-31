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
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    var locationText: String?
    let geocoder = CLGeocoder()
    var firstName: String = ""
    var lastName: String = ""
    var longitude: Double = 0.00
    var latitude: Double = 0.00
    let userId = UserSessionManager.shared.userKey
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let location = locationText {
            
            activityView.startAnimating()
            // Make a network request to a geocoding service using the location value
            // Handle the response and update the map view accordingly
            geocoder.geocodeAddressString(location) { (placemarks, error) in
                if let error = error {
                    // Handle any errors that occurred during geocoding
                    print("Geocoding error: \(error.localizedDescription)")
                    
                    // Show an alert to the user indicating the geocoding failed
                    let alert = UIAlertController(title: "Geocoding Error", message: "Failed to geocode the provided location", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                    self.activityView.stopAnimating()
                    return
                    
                }
                
                if let placemark = placemarks?.first {
                    // Access the location information from the placemark
                    let location = placemark.location
                    let coordinate = location?.coordinate
                    if let latitude = coordinate?.latitude, let longitude = coordinate?.longitude {
                        self.latitude = latitude
                        self.longitude = longitude
                        
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
                self.activityView.stopAnimating()
            }
        }
        
        //get the userID to make getUser call:
        UdacityClient.getPublicUserData(userID: userId!) {  userData, error in
            if let userData = userData {
                self.firstName = userData.firstName
                self.lastName = userData.lastName
            } else {
                // Handle error
                if let error = error {
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func submit(_ sender: UIButton) {
        
        // Check if linkTextField is empty or contains only whitespace
        guard let linkText = linkTextField.text, !linkText.isEmpty else {
            // Show an alert to the user indicating that linkTextField is required
            let alert = UIAlertController(title: "Error", message: "Please provide a link", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        // Check if geocoding was successful
        checkGeoCoding()
        
        UdacityClient.postStudentLocation(uniqueKey: userId!, firstName: firstName, lastName: lastName, mapString: self.locationText!, mediaURL: self.linkTextField.text!, latitude: latitude, longitude: longitude) { success, error in
            if success {
                
                NotificationCenter.default.post(name: NSNotification.Name("NewPinAdded"), object: nil)
                //dismiss to go back to tab bar screen
                self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                
            } else {
                let alert = UIAlertController(title: "Error", message: "Failed to post the location. Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    func checkGeoCoding(){
        if latitude == 0.0 || longitude == 0.0 {
            // Geocoding failed, display an alert to the user
            let alert = UIAlertController(title: "Geocoding Failed", message: "Unable to geocode the address. Please try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
    }
    
}






