//
//  MapController.swift
//  OnTheMap
//
//  Created by Tracy Adams on 11/27/23.
//

import Foundation
import UIKit

class MapViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    @IBAction func postPinBarButton(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "postPin", sender: nil)
    }
    
    @IBAction func logOut(_ sender: UIBarButtonItem) {
    }
}
