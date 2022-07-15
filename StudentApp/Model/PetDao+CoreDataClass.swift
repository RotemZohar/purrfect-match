//
//  PetDao+CoreDataClass.swift
//  StudentApp
//
//  Created by admin on 01/07/2022.
//

import Foundation
import CoreData
import UIKit

@objc(PetDao)
public class PetDao: NSManagedObject {
    static var context:NSManagedObjectContext? = { () -> NSManagedObjectContext? in
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }()
    
    static func getAllPets()->[Pet]{
        guard let context = context else {
            return []
        }

        do{
            let petsDao = try context.fetch(PetDao.fetchRequest())
            var petArray:[Pet] = []
            for petDao in petsDao{
                petArray.append(Pet(pet:petDao))
            }
            return petArray
        }catch let error as NSError{
            print("pet fetch error \(error) \(error.userInfo)")
            return []
        }
    }
    
    static func add(pet:Pet){
        guard let context = context else {
            return
        }
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        let p = PetDao(context: context)
        p.id = pet.id
        p.name = pet.name
        p.phone = pet.phone
        p.avatarUrl = pet.avatarUrl
        p.lastUpdated = pet.lastUpdated
        p.desc = pet.desc
        p.address = pet.address
        p.breed = pet.breed
        p.user = pet.user
        
        do{
            try context.save()
        }catch let error as NSError{
            print("pet add error \(error) \(error.userInfo)")
        }
    }
    
    static func getPet(byId:String)->Pet?{
        return nil
    }
    
    static func delete(pet:Pet){
        guard let context = context else {
            return
        }
        
        let fetchReq = PetDao.fetchRequest()
        
        do{
            let petsDao = try context.fetch(fetchReq)
            for petDao in petsDao {
                if (pet.id == petDao.id)
                {
                    context.delete(petDao)
                }
            }
                
            }catch let error as NSError{
            print("Pet fetch error \(error) \(error.userInfo)")
        }
            
        do{
            try context.save()
        }catch let error as NSError{
            print("pet delete error \(error) \(error.userInfo)")
        }
        Model.petDataNotification.post()
    }
    
    static func update(pet:Pet){
        guard let context = context else {
            return
        }
        
        let fetchReq = PetDao.fetchRequest()
        fetchReq.predicate = NSPredicate.init(format: "id == \(pet.id)")
        
        do{
            let petsDao = try context.fetch(fetchReq)
            for petDao in petsDao {
                //context.updatedObjects({})
            }
        }catch let error as NSError{
            print("Pet update error \(error) \(error.userInfo)")
        }
            
        do{
            try context.save()
        }catch let error as NSError{
            print("pet add error \(error) \(error.userInfo)")
        }
        Model.petDataNotification.post()
    }
    
    static func localLastUpdated() -> Int64{
        return Int64(UserDefaults.standard.integer(forKey: "PETS_LAST_UPDATE"))
    }
    
    static func setLocalLastUpdated(date:Int64){
        UserDefaults.standard.set(date, forKey: "PETS_LAST_UPDATE")
    }
}
