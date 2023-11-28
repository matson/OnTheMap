//
//  GeoCodingViewController.swift
//  OnTheMap
//
//  Created by Tracy Adams on 11/28/23.
//

import Foundation
import UIKit

class GeoCodingViewController: UIViewController {
    
    @IBOutlet weak var linkTextField: UITextField!
    
    
    
    
    @IBAction func cancel(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func linkToShare(_ sender: UITextField) {
        
    }
    
    @IBAction func submit(_ sender: UIButton) {
        
        //back to map view
        performSegue(withIdentifier: "backToMap", sender: nil)
        
    }
    
    
}
