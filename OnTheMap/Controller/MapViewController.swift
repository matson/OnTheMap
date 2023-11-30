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
//                print("yes")
//            }
//            else{
//                print("nah")
//            }
//        }
        
        UdacityClient.putStudentLocation(objectId: "8ZExGR5uX8", uniqueKey: "1234", firstName: "John", lastName: "Doe", mapString: "Philly", mediaURL: "https://udacity.com", latitude: 35.386052, longitude: -107.083851) { success, error in
                    if success {
                        print("yes")
                    }
                    else{
                        print("nah")
                    }
                }
        
        
        
    }
    
       
    //MARK: Map and Pins Functionality 
    
        
        
    
    
    
    //MARK: BarButton Items
    
    @IBAction func postPinBarButton(_ sender: UIBarButtonItem) {
        print("here")
        print("passed this line")
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
