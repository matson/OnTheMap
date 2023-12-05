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
    var firstName: String = ""
    var lastName: String = ""
    var longitude: Double = 0.00
    var latitude: Double = 0.00
    let userId = UserSessionManager.shared.userKey
    var newPinCoordinates: CLLocationCoordinate2D?
    
    
    
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
                        self.latitude = latitude
                        self.longitude = longitude
                        self.newPinCoordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
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
        
        //get the userID to make getUser call:
        UdacityClient.getPublicUserData(userID: userId!) {  userData, error in
            if let userData = userData {
                self.firstName = userData.firstName
                self.lastName = userData.lastName
            } else {
                // Handle error
                if let error = error {
                    print("Error: \(error)")
                }
            }
        }
    }
    
    
    @IBAction func cancel(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    var isSeguePerformed = false
    @IBAction func submit(_ sender: UIButton) {
        print("submit")
        UdacityClient.postStudentLocation(uniqueKey: userId!, firstName: firstName, lastName: lastName, mapString: self.locationText!, mediaURL: self.linkTextField.text!, latitude: latitude, longitude: longitude) { success, error in
            if success {
                print("added student successfully")
                print("I'm first")
                DispatchQueue.main.async {
                    if !self.isSeguePerformed {
                        self.isSeguePerformed = true
                        self.performSegue(withIdentifier: "backToMap", sender: nil)
                    }
                }
            } else {
                print("nah")
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToMap" && !isSeguePerformed {
            print("hello I'm here")
            print(self.newPinCoordinates)
            //not a nil value
            if let mapViewController = segue.destination as? MapViewController {
                print("cool I got here")
                //will not get here because setup is wrong I believe
                mapViewController.newPinAnnotation = MKPointAnnotation()
                mapViewController.newPinAnnotation?.coordinate = newPinCoordinates ?? CLLocationCoordinate2D()
            }
        }
    }
    
    
}

//}  else {
//    // Show an alert if the text field is empty
//    let alertController = UIAlertController(title: "Error", message: "Please enter a link", preferredStyle: .alert)
//    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//    alertController.addAction(okAction)
//    present(alertController, animated: true, completion: nil)
//
//    return
//}




