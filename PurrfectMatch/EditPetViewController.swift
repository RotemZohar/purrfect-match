//
//  EditPetViewController.swift
//  PurrfectMatch
//
//  Created by admin on 15/07/2022.
//

import UIKit
import MapKit

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
    var addressCoor: CLLocationCoordinate2D?
    @IBOutlet weak var errorMsgLabel: UILabel!    
    
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
        addressCoor = CLLocationCoordinate2D(latitude: pet!.latitude!, longitude: pet!.longtitude!)
        
        if let urlStr = pet?.avatarUrl {
            let url = URL(string: urlStr)
            avatarImgEV.kf.setImage(with: url)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
        errorMsgLabel.isHidden = true
        addressEv.isEnabled = false
        
        if pet != nil {
            updateDisplay()
        }
    }
    
    @IBAction func update(_ sender: Any) {
        if (nameEv.text?.isEmpty == true || phoneEv.text?.isEmpty == true || (addressEv.text?.isEmpty == true && addressCoor == nil)) {
            errorMsgLabel.isHidden = false
        } else {
            errorMsgLabel.isHidden = true
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            pet?.name = nameEv.text
            pet?.phone = phoneEv.text
            pet?.address = addressEv.text
            pet?.breed = breedEv.text
            pet?.desc = descriptionEv.text
            pet?.latitude = addressCoor?.latitude
            pet?.longtitude = addressCoor?.longitude
            
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "searchMapSegue" {
            let dvc = segue.destination as! MapSearchController
            if addressCoor != nil{
                dvc.search = Search(text: addressEv.text ?? "", coor: addressCoor)
            }
        }
    }
}
