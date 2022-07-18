//
//  ModelFirebase.swift
//  PurrfectMatch
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
    
    func add(pet:Pet, completion:@escaping (Pet)->Void){
        let doc = db.collection("Pets").document();
        pet.id = doc.documentID
        doc.setData(
            pet.toJson())
        { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with")
            }
            completion(pet)
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
    
    func checkUser(email:String, password:String, completion:@escaping (Bool)->Void){
        db.collection("Users")
            .whereField("email", isEqualTo: email)
            .whereField("password", isEqualTo: password)
            .getDocuments() { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                    completion(false)
            } else {
                if(snapshot!.documents.isEmpty) {
                    print("User doesnt exist")
                    completion(false)
                } else {
                    print("Loggin in...")
                    for document in snapshot!.documents {
                        let u = User.FromJson(json: document.data())
                        Defaults.save(user: u)
                        Defaults.sync()
                    }
                    completion(true)
                }
            }
        }
    }
    
    func checkEmail(email:String, completion:@escaping (Bool)->Void){
        db.collection("Users")
            .whereField("email", isEqualTo: email)
            .getDocuments() { (snapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completion(true)
            } else {
                if(snapshot!.documents.isEmpty) {
                    print("Email doesnt exist")
                    completion(false)
                } else {
                    print("Email exist")
                    completion(true)
                }
            }
        }
    }
    
    func addUser(name:String, email:String, password:String, completion:@escaping ()->Void){
        db.collection("Users").document().setData([
            "name": name,
            "email": email,
            "password": password])
        { err in
            if let err = err {
                print("Error adding user: \(err)")
            } else {
                print("user created")
            }
            completion()
        }
    }
    
}
