//
//  NewStudentViewController.swift
//  StudentApp
//
//  Created by Eliav Menachi on 11/05/2022.
//

import UIKit

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
    @IBOutlet weak var idTv: UITextField!
    @IBOutlet weak var addressTv: UITextField!
    @IBOutlet weak var breedTv: UITextField!
    @IBOutlet weak var descriptionTv: UITextField!
    @IBOutlet weak var avatarImgv: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
    }
    
    @IBAction func save(_ sender: Any) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        let pet = Pet()
        pet.name = nameTv.text
        pet.phone = phoneTv.text
        pet.address = addressTv.text
        pet.breed = breedTv.text
        pet.desc = descriptionTv.text
        pet.user = Defaults.getUserInfo().email
        if let image = selectedImage{
            Model.instance.uploadImage(name: pet.id!, image: image) { url in
                pet.avatarUrl = url
                Model.instance.add(pet: pet){
                    self.navigationController?.popViewController(animated: true)
                }
                
            }
        }else{
            Model.instance.add(pet: pet){
                self.navigationController?.popViewController(animated: true)
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
