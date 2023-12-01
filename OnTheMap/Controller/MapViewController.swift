//
//  MapController.swift
//  OnTheMap
//
//  Created by Tracy Adams on 11/27/23.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController{
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //to adjust map on screen:
        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
    }
    
       
    //MARK: Map and Pins Functionality 
    
    //notes here 
        
    
    
    
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
        
//        UdacityClient.getStudentLocation { studentData, error in
//            if let studentData = studentData {
//
//                // Access the user data using the appropriate property or method
//                print(studentData.longitude)
//            } else {
//                // Handle error
//                if let error = error {
//                    print("Error: \(error)")
//                }
//            }
//        }

//
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
