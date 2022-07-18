//
//  Model.swift
//  StudentApp
//
//  Created by Eliav Menachi on 11/05/2022.
//

import Foundation
import UIKit
import CoreData


class ModelNotificatiponBase{
    let name:String
    init(_ name:String){
        self.name=name
    }
    func observe(callback:@escaping ()->Void){
        NotificationCenter.default.addObserver(forName: Notification.Name(name), object: nil, queue: nil){ data in
            NSLog("got notify")
            callback()
        }
    }
    
    func post(){
        NSLog("post notify")
        NotificationCenter.default.post(name: Notification.Name(name), object: self)
    }

}
class Model{
    let firebaseModel = ModelFirebase()
    let dispatchQueue = DispatchQueue(label: "com.purrfectMatch") // TODO: FIX

    // Notification center
    static let petDataNotification = ModelNotificatiponBase("com.purrfectMatch.studentDataNotification") // TODO: FIX
    
    private init(){
       
    }
    
    static let instance = Model()
    
    func getAllPets(completion:@escaping ([Pet])->Void){
        //get the Local Last Update data
        var lup = PetDao.localLastUpdated()
        NSLog("TAG PETS_LAST_UPDATE " + String(lup))
        
        //fetch all updated records from firebase
        firebaseModel.getAllPets(since: lup){ pets in
            //insert all records to local DB
            NSLog("TAG firebaseModel.getAllPets in \(pets.count)")
            self.dispatchQueue.async{
                for pet in pets {
                    PetDao.add(pet: pet)
                    if pet.lastUpdated > lup {
                        lup = pet.lastUpdated
                    }
                }
                //update the local last update date
                PetDao.setLocalLastUpdated(date: lup)
                
                DispatchQueue.main.async {
                    //return all records to caller
                    completion(PetDao.getAllPets())
                }
            }
        }
    }
    
    func add(pet:Pet, completion: @escaping (Pet)->Void){
        firebaseModel.add(pet:pet){ response in
            completion(response)
            Model.petDataNotification.post()
        }
    }
    
    func getPet(byId:String)->Pet?{
        return firebaseModel.getPet(byId: byId)
    }
    
    func delete(pet:Pet, completion:@escaping ()->Void){
        firebaseModel.delete(pet: pet){
            PetDao.delete(pet: pet)
            completion()
            Model.petDataNotification.post()
        }
    }
    
    func update(pet:Pet, completion:@escaping ()->Void){
        firebaseModel.update(pet: pet){
            completion()
            Model.petDataNotification.post()
        }
    }
    func uploadImage(name:String, image:UIImage, callback:@escaping(_ url:String)->Void){
        firebaseModel.uploadImage(name: name, image: image, callback: callback)
    }
    
    func checkUserValid(email:String, password:String, completion:@escaping (Bool)->Void){
        firebaseModel.checkUser(email: email, password: password) {Bool in
            completion(Bool)
        }
    }
    
    func checkEmailValid(email:String, completion:@escaping (Bool)->Void){
        firebaseModel.checkEmail(email: email) {Bool in
            completion(Bool)
        }
    }
    
    func addUser(name:String, email:String, password:String, completion:@escaping ()->Void){
        firebaseModel.addUser(name: name, email: email, password: password){
            completion()
        }
    }
}
