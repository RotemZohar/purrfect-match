//
//  StudentDetailsViewController.swift
//  PurrfectMatch
//
//  Created by Kely Sotsky on 06/04/2022.
//

import UIKit
import Kingfisher

class PetDetailsViewController: UIViewController {
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBAction func onDelete(_ sender: Any) {
        if (pet != nil) {
            pet?.hasBeenDeleted = true
            Model.instance.update(pet: pet!) {
                self.navigationController?.popViewController(animated: true)
            }
//            Model.instance.delete(pet: pet!) {
//                self.navigationController?.popViewController(animated: true)
//            }
        }
    }
    
    var pet:Pet?{
        didSet{
            if(nameLabel != nil){
                updateDisplay()
            }
        }
    }
    
    func updateDisplay(){
        nameLabel.text = pet?.name
        phoneLabel.text = pet?.phone
        addressLabel.text = pet?.address
        breedLabel.text = pet?.breed
        descLabel.text = pet?.desc
        if let urlStr = pet?.avatarUrl {
            let url = URL(string: urlStr)
            avatarImg.kf.setImage(with: url)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if pet != nil {
            updateDisplay()
            deleteBtn.isHidden = Defaults.getUserInfo().email != pet?.user
            editBtn.isHidden = Defaults.getUserInfo().email != pet?.user
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "openEditDetails"){
            let dvc = segue.destination as! EditPetViewController
            dvc.pet = pet
            dvc.callbackResult = { result in
                self.pet = result
            }
        }
    }
}
