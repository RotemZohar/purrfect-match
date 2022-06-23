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
    
    func getAllStudents(since:Int64, completion:@escaping ([Student])->Void){
        db.collection("Students").whereField("lastUpdated", isGreaterThanOrEqualTo: Timestamp(seconds: since, nanoseconds: 0)).getDocuments() { (querySnapshot, err) in
            var students = [Student]()
            if let err = err {
                print("Error getting documents: \(err)")
                completion(students)
            } else {
                for document in querySnapshot!.documents {
                    let s = Student.FromJson(json: document.data())
                    students.append(s)
                }
                completion(students)
            }
        }
    }
    
    func add(student:Student, completion:@escaping ()->Void){
        db.collection("Students").document(student.id!).setData(
            student.toJson())
        { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with")
            }
            completion()
        }
    }
    
    func getStudent(byId:String)->Student?{
        return nil
    }
    
    func delete(student:Student){
        
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
