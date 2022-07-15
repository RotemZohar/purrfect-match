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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
    }
    
    @IBAction func login(_ sender: Any) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        var email: String? = loginEmailTv.text
        var password: String? = loginPasswordTv.text
        
        // TODO: check if user exist
        
        // TODO: if yes, navigate to app
        
        // TODO: if not, add error notif

    }
    
    
}
