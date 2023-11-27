//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Tracy Adams on 11/22/23.
//

import Foundation
import UIKit


class LoginViewController: UIViewController {
    

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var login: UIButton!
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        usernameTextField.text = ""
        passwordTextField.text = ""
    }
    
    
    //login action
    @IBAction func loginTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "completeLogin", sender: nil)
    }
    
}
