//
//  ModelFirebase.swift
//  StudentApp
//
//  Created by Eliav Menachi on 18/05/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import UIKit

class ModelFirebase{
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    init(){
        
    }
    
    func getAllPets(since:Int64, completion:@escaping ([Pet])->Void){
        db.collection("Pets").whereField("lastUpdated", isGreaterThanOrEqualTo: Timestamp(seconds: since, nanoseconds: 0)).getDocuments() { (querySnapshot, err) in
            var pets = [Pet]()
            if let err = err {
                print("Error getting documents: \(err)")
                completion(pets)
            } else {
                for document in querySnapshot!.documents {
                    let s = Pet.FromJson(json: document.data())
                    s.id = document.documentID
                    pets.append(s)
                }
                completion(pets)
            }
        }
    }
    
    func add(pet:Pet, completion:@escaping ()->Void){
        db.collection("Pets").document().setData(
            pet.toJson())
        { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with")
            }
            completion()
        }
    }
    
    func update(pet:Pet, completion:@escaping ()->Void){
        db.collection("Pets").document(pet.id!).setData(
            pet.toJson())
        { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document updated with")
            }
            completion()
        }
    }
    func getPet(byId:String)->Pet?{
        return nil
    }
    
    func delete(pet:Pet, completion:@escaping ()->Void){
        db.collection("Pets").document(pet.id!).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
            completion()
        }
    }
    
    
    func uploadImage(name:String, image:UIImage, callback: @escaping (_ url:String)->Void){
        let storageRef = storage.reference()
        let imageRef = storageRef.child(name)
        let data = image.jpegData(compressionQuality: 0.8)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        imageRef.putData(data!, metadata: metaData){(metaData,error) in
            imageRef.downloadURL { (url, error) in
                let urlString = url?.absoluteString
                callback(urlString!)
            }
        }
    }
    
}
