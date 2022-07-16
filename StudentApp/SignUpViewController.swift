//
//  SignUpViewController.swift
//  StudentApp
//
//  Created by admin on 15/07/2022.
//

import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var signupNameTv: UITextField!
    @IBOutlet weak var signupEmailTv: UITextField!
    @IBOutlet weak var signupPasswordTv: UITextField!
    @IBOutlet weak var signupConfirmTv: UITextField!
    @IBOutlet weak var signupErrorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        signupErrorLabel.isHidden = true
    }
    
    @IBAction func signup(_ sender: Any) {
        signupErrorLabel.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()

        let name: String? = signupNameTv.text
        let email: String? = signupEmailTv.text
        let password: String? = signupPasswordTv.text
        let confirmPassword: String? = signupConfirmTv.text

        if (name == "" || email == "" || password == "" || confirmPassword == "") {
            signupErrorLabel.text = "You must fill all required fields!"
            signupErrorLabel.isHidden = false
            activityIndicator.isHidden = true
            
        } else if (password?.count ?? 0 < 8) {
            signupErrorLabel.text = "Password must be at least 8 characters!"
            signupErrorLabel.isHidden = false
            activityIndicator.isHidden = true
            
        } else if (password != confirmPassword) {
            signupErrorLabel.text = "Passwords don't match!"
            signupErrorLabel.isHidden = false
            activityIndicator.isHidden = true
            
        } else {
            // TODO: check if user exist
            
            // TODO: if yes, add error notif
            
            // TODO: if not, save user & nav to login
        }
    }
}
