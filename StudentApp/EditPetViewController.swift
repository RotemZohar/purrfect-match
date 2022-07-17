//
//  EditPetViewController.swift
//  StudentApp
//
//  Created by admin on 15/07/2022.
//

import UIKit

class EditPetViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBAction func openCamera(_ sender: Any) {
        takePicture(source: .camera)
    }
    
    @IBAction func openGallery(_ sender: Any) {
        takePicture(source: .photoLibrary)
    }
    
    @IBOutlet weak var nameEv: UITextField!
    @IBOutlet weak var phoneEv: UITextField!
    @IBOutlet weak var addressEv: UITextField!
    @IBOutlet weak var breedEv: UITextField!    
    @IBOutlet weak var descriptionEv: UITextField!
    @IBOutlet weak var avatarImgEV: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var pet:Pet?{
        didSet{
            if(nameEv != nil){
                updateDisplay()
            }
        }
    }
    
    func updateDisplay(){
        nameEv.text = pet?.name
        phoneEv.text = pet?.phone
        addressEv.text = pet?.address
        breedEv.text = pet?.breed
        descriptionEv.text = pet?.desc
        if let urlStr = pet?.avatarUrl {
            let url = URL(string: urlStr)
            avatarImgEV.kf.setImage(with: url)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        
        if pet != nil {
            updateDisplay()
        }
    }
    
    @IBAction func update(_ sender: Any) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        pet?.name = nameEv.text
        pet?.phone = phoneEv.text
        pet?.address = addressEv.text
        pet?.breed = breedEv.text
        pet?.desc = descriptionEv.text
        if let image = selectedImage{
            Model.instance.uploadImage(name: pet?.id ?? "", image: image) { url in
                self.pet?.avatarUrl = url
                Model.instance.update(pet: self.pet!){
                    self.callbackResult?(self.pet!)
                    self.navigationController?.popViewController(animated: true)
                }
                
            }
        }else{
            Model.instance.update(pet: pet!){
                self.callbackResult?(self.pet!)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    var callbackResult: ((Pet) -> ())?
    
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
        self.avatarImgEV.image = selectedImage
        self.dismiss(animated: true, completion: nil)
        
    }
}
