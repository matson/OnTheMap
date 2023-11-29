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
        
        UdacityClient.getPublicUserData(userID: "3903878747") { userData, error in
            if let userData = userData {
                
                // Access the user data using the appropriate property or method
                //print(userData.firstName)
            } else {
                // Handle error
                if let error = error {
                    print("Error: \(error)")
                }
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
