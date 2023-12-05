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
    
    @IBAction func findOnMap(_ sender: UIButton) {
        
        //if the user has not entered a location string...
        if let location = locationText.text, !location.isEmpty {
            performSegue(withIdentifier: "findOnMap", sender: nil)
            
        } else {
            // Show an alert if the text field is empty
            let alertController = UIAlertController(title: "Error", message: "Please enter a location", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("hello there I am called")
        if segue.identifier == "findOnMap" {
            if let destinationVC = segue.destination as? GeoCodingViewController {
                destinationVC.locationText = locationText.text
            }
        }
    }
   
}

