//
//  NewStudentViewController.swift
//  PurrfectMatch
//
//  Created by Eliav Menachi on 11/05/2022.
//

import UIKit

class NewStudentViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
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
    @IBOutlet weak var avatarImgv: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
    }
    
    @IBAction func save(_ sender: Any) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        let student = Student()
        student.id = idTv.text
        student.name = nameTv.text
        if let image = selectedImage{
            Model.instance.uploadImage(name: student.id!, image: image) { url in
                student.avatarUrl = url
                Model.instance.add(student: student){
                    self.navigationController?.popViewController(animated: true)
                }
                
            }
        }else{
            Model.instance.add(student: student){
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
