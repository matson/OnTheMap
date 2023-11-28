//
//  PostingViewController.swift
//  OnTheMap
//
//  Created by Tracy Adams on 11/27/23.
//

import Foundation
import UIKit

class PostingViewController: UIViewController {
   
    
    @IBOutlet weak var locationText: UITextField!
    
  
    
    
    @IBAction func cancelPost(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func enterLocation(_ sender: UITextField) {
        
        
    }
    
    @IBAction func findOnMap(_ sender: UIButton) {
        performSegue(withIdentifier: "findOnMap", sender: nil)
    }
}
