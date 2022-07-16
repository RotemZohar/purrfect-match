//
//  LoginViewController.swift
//  StudentApp
//
//  Created by admin on 15/07/2022.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginEmailTv: UITextField!
    @IBOutlet weak var loginPasswordTv: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        errorLabel.isHidden = true
    }
    
    @IBAction func login(_ sender: Any) {
        errorLabel.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        let email: String? = loginEmailTv.text
        let password: String? = loginPasswordTv.text
        
        // check fields
        if (email == "" || password == "") {
            errorLabel.text = "You must fill all required fields!"
            errorLabel.isHidden = false
            activityIndicator.isHidden = true
        } else {
            // TODO: check if user exist
            
            // TODO: if yes, navigate to app
            
            // TODO: if not, add error notif
        }
    }
    
    
}
