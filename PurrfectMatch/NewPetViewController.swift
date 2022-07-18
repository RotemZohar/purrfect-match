//
//  NewStudentViewController.swift
//  PurrfectMatch
//
//  Created by Eliav Menachi on 11/05/2022.
//

import UIKit
import CoreLocation

class NewPetViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBAction func openCamera(_ sender: Any) {
        takePicture(source: .camera)
    }
    
    @IBAction func openGallery(_ sender: Any) {
        takePicture(source: .photoLibrary)
    }
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var phoneTv: UITextField!
    @IBOutlet weak var nameTv: UITextField!
    @IBOutlet weak var addressTv: UITextField!
    @IBOutlet weak var breedTv: UITextField!
    @IBOutlet weak var descriptionTv: UITextField!
    @IBOutlet weak var avatarImgv: UIImageView!
    @IBOutlet weak var errorMsgLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        errorMsgLabel.isHidden = true
        addressTv.isEnabled = false
    }
    
    var addressCoor: CLLocationCoordinate2D?
    
    @IBAction func save(_ sender: Any) {
        if (nameTv.text?.isEmpty == true || phoneTv.text?.isEmpty == true || (addressTv.text?.isEmpty == true && addressCoor == nil)) {
            errorMsgLabel.isHidden = false
        } else {
            errorMsgLabel.isHidden = true
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            let pet = Pet()
            pet.name = nameTv.text
            pet.phone = phoneTv.text
            pet.address = addressTv.text
            pet.breed = breedTv.text
            pet.desc = descriptionTv.text
            pet.user = Defaults.getUserInfo().email
            pet.longtitude = addressCoor?.longitude
            pet.latitude = addressCoor?.latitude
            
            Model.instance.add(pet: pet){ savedPet in
                    if let image = self.selectedImage {
                        Model.instance.uploadImage(name: savedPet.id!, image: image) { url in
                            pet.avatarUrl = url
                            Model.instance.update(pet: pet) {
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    } else {
                        self.navigationController?.popViewController(animated: true)
                    }
            }
        }
    }
    
    func takePicture(source: UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source;
        imagePicker.allowsEditing = true
        if (UIImagePickerController.isSourceTypeAvailable(source))
        {
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    var selectedImage: UIImage?
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        selectedImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage
        self.avatarImgv.image = selectedImage
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "searchMapSegue" {
             let dvc = segue.destination as! MapSearchController
             if addressCoor != nil{
                 dvc.search = Search(text: addressTv.text ?? "", coor: addressCoor)
             }
         }
     }
     
    
}
