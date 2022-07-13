//
//  StudentDetailsViewController.swift
//  StudentApp
//
//  Created by Kely Sotsky on 06/04/2022.
//

import UIKit
import Kingfisher

class PetDetailsViewController: UIViewController {
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    var pet:Pet?{
        didSet{
            if(idLabel != nil){
                updateDisplay()
            }
        }
    }
    
    func updateDisplay(){
        idLabel.text = pet?.id
        nameLabel.text = pet?.name
        if let urlStr = pet?.avatarUrl {
            let url = URL(string: urlStr)
            avatarImg.kf.setImage(with: url)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if pet != nil {
            updateDisplay()
        }
    }
}
