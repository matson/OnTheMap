//
//  MapController.swift
//  OnTheMap
//
//  Created by Tracy Adams on 11/27/23.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locations = DataManager.shared.studentLocations
    var newPinAnnotation: MKPointAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        
        //to adjust map on screen:
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshMap), name: NSNotification.Name("NewPinAdded"), object: nil)
        
        UdacityClient.getStudentLocation { studentData, error in
            if let studentData = studentData {
                
                self.locations.append(contentsOf: studentData)
                
                var annotations = [MKPointAnnotation]()
                
                for location in self.locations {
                    // Notice that the float values are being used to create CLLocationDegree values.
                    // This is a version of the Double type.
                    let lat = CLLocationDegrees(location.latitude)
                    let long = CLLocationDegrees(location.longitude)
                    
                    // The lat and long are used to create a CLLocationCoordinates2D instance.
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    let first = location.firstName
                    let last = location.lastName
                    let mediaURL = location.mediaURL
                    
                    // Here we create the annotation and set its coordiate, title, and subtitle properties
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = mediaURL
                    
                    // Finally we place the annotation in an array of annotations.
                    annotations.append(annotation)
                    
        
                }
               
                self.mapView.addAnnotations(annotations)
            }
            else{
                print("nah")
            }
        }
        
    }
    
    @objc func refreshMap() {
        UdacityClient.getStudentLocation { studentData, error in
            if let studentData = studentData {
                
                self.locations.append(contentsOf: studentData)
                
                var annotations = [MKPointAnnotation]()
                
                for location in self.locations {
                    // Notice that the float values are being used to create CLLocationDegree values.
                    // This is a version of the Double type.
                    let lat = CLLocationDegrees(location.latitude)
                    let long = CLLocationDegrees(location.longitude)
                    
                    // The lat and long are used to create a CLLocationCoordinates2D instance.
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    let first = location.firstName
                    let last = location.lastName
                    let mediaURL = location.mediaURL
                    
                    // Here we create the annotation and set its coordiate, title, and subtitle properties
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = mediaURL
                    
                    // Finally we place the annotation in an array of annotations.
                    annotations.append(annotation)
                    
        
                }
               
                self.mapView.addAnnotations(annotations)
            }
            else{
                print("nah")
            }
        }
    }
    
       
    //MARK: Map and Pins Functionality 
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"

        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView

        if pinView == nil {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.markerTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }

        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            //let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                UIApplication.shared.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
    
    //MARK: BarButton Items
    
    @IBAction func postPinBarButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "postPin", sender: nil)
    }
    
    @IBAction func logOut(_ sender: UIBarButtonItem) {
        UdacityClient.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
   
    
}

//        UdacityClient.getPublicUserData(userID: "3903878747") { userData, error in
//            if let userData = userData {
//
//                // Access the user data using the appropriate property or method
//                //print(userData.firstName)
//            } else {
//                // Handle error
//                if let error = error {
//                    print("Error: \(error)")
//                }
//            }
//        }
        


//        UdacityClient.postStudentLocation(uniqueKey: "1234", firstName: "John", lastName: "Doe", mapString: "Mountain View, CA", mediaURL: "https://udacity.com", latitude: 37.386052, longitude: -122.083851) { success, error in
//            if success {
//                print("added student successfully")
//            }
//            else{
//                print("nah")
//            }
//        }
//
//        UdacityClient.putStudentLocation(objectId: "bji6d8rcspggujsjjd10", uniqueKey: "1234", firstName: "John", lastName: "Doe", mapString: "Cupertino, CA", mediaURL: "https://udacity.com", latitude: 37.322998, longitude: -122.032182) { success, error in
//                    if success {
//                        print("changed student successfully")
//                    }
//                    else{
//                        print("nah")
//                    }
//                }
