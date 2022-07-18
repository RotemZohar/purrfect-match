//
//  AccountViewController.swift
//  PurrfectMatch
//
//  Created by admin on 18/07/2022.
//

import UIKit

class AccountViewController: UIViewController {
    
    @IBOutlet weak var helloUser: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        helloUser.text = "Hello, " + Defaults.getUserInfo().name + "!"
    }
    
    
    @IBAction func logout(_ sender: Any) {
        Defaults.clearUserInfo()
        performSegue(withIdentifier: "LogoutSegue", sender: self)
        
    }
}
