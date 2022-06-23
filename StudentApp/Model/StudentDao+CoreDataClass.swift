//
//  StudentDao+CoreDataClass.swift
//  StudentApp
//
//  Created by Eliav Menachi on 11/05/2022.
//
//

import Foundation
import CoreData
import UIKit

@objc(StudentDao)
public class StudentDao: NSManagedObject {
    static var context:NSManagedObjectContext? = { () -> NSManagedObjectContext? in
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return nil
        }
        return appDelegate.persistentContainer.viewContext
    }()
    
    static func getAllStudents()->[Student]{
        guard let context = context else {
            return []
        }

        do{
            let studentsDao = try context.fetch(StudentDao.fetchRequest())
            var stArray:[Student] = []
            for stDao in studentsDao{
                stArray.append(Student(student:stDao))
            }
            return stArray
        }catch let error as NSError{
            print("student fetch error \(error) \(error.userInfo)")
            return []
        }
    }
    
    static func add(student:Student){
        guard let context = context else {
            return
        }
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        let st = StudentDao(context: context)
        st.id = student.id
        st.name = student.name
        st.phone = student.phone
        st.avatarUrl = student.avatarUrl
        st.lastUpdated = student.lastUpdated
        
        do{
            try context.save()
        }catch let error as NSError{
            print("student add error \(error) \(error.userInfo)")
        }
    }
    
    static func getStudent(byId:String)->Student?{
        return nil
    }
    
    static func delete(student:Student){
        
    }
    
    static func localLastUpdated() -> Int64{
        return Int64(UserDefaults.standard.integer(forKey: "STUDENTS_LAST_UPDATE"))
    }
    
    static func setLocalLastUpdated(date:Int64){
        UserDefaults.standard.set(date, forKey: "STUDENTS_LAST_UPDATE")
    }
}
