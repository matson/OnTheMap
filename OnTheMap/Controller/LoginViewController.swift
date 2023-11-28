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
        UdacityClient.createSessionId(username: usernameTextField.text ?? "", password: passwordTextField.text ?? "", completion: handleSessionResponse(success:error:))
        
    }
    
    func handleSessionResponse(success: Bool, error: Error?) {
        //setLoggingIn(false)
        if success {
            performSegue(withIdentifier: "completeLogin", sender: nil)
        } else {
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
}
