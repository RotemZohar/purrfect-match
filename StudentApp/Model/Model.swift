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
    let dispatchQueue = DispatchQueue(label: "com.studentapp")

    // Notification center
    static let petDataNotification = ModelNotificatiponBase("com.menachi.studentDataNotification") // TODO: FIX?
    
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
                
//                sleep(5)
                DispatchQueue.main.async {
                    //return all records to caller
                    completion(PetDao.getAllPets())
                }
            }
        }
    }
    
    func add(pet:Pet, completion: @escaping ()->Void){
        firebaseModel.add(pet: pet){
            completion()
            Model.petDataNotification.post()
        }
    }
    
    func getPet(byId:String)->Pet?{
        return firebaseModel.getPet(byId: byId)
    }
    
    func delete(pet:Pet){
        firebaseModel.delete(pet: pet)
    }
    
    func uploadImage(name:String, image:UIImage, callback:@escaping(_ url:String)->Void){
        firebaseModel.uploadImage(name: name, image: image, callback: callback)
    }
}
