//
//  StudentDetailsViewController.swift
//  StudentApp
//
//  Created by Kely Sotsky on 06/04/2022.
//

import UIKit
import Kingfisher

class StudentDetailsViewController: UIViewController {
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    var student:Student?{
        didSet{
            if(idLabel != nil){
                updateDisplay()
            }
        }
    }
    
    func updateDisplay(){
        idLabel.text = student?.id
        nameLabel.text = student?.name
        if let urlStr = student?.avatarUrl {
            let url = URL(string: urlStr)
            avatarImg.kf.setImage(with: url)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if student != nil {
            updateDisplay()
        }
    }
}
