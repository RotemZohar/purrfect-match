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
    static let studentDataNotification = ModelNotificatiponBase("com.menachi.studentDataNotification")
    
    private init(){
       
    }
    
    static let instance = Model()
    
    func getAllStudents(completion:@escaping ([Student])->Void){
        //get the Local Last Update data
        var lup = StudentDao.localLastUpdated()
        NSLog("TAG STUDENTS_LAST_UPDATE " + String(lup))
        
        //fetch all updated records from firebase
        firebaseModel.getAllStudents(since: lup){ students in
            //insert all records to local DB
            NSLog("TAG firebaseModel.getAllStudents in \(students.count)")
            self.dispatchQueue.async{
                for student in students {
                    StudentDao.add(student: student)
                    if student.lastUpdated > lup {
                        lup = student.lastUpdated
                    }
                }
                //update the local last update date
                StudentDao.setLocalLastUpdated(date: lup)
                
//                sleep(5)
                DispatchQueue.main.async {
                    //return all records to caller
                    completion(StudentDao.getAllStudents())
                }
            }
        }
    }
    
    func add(student:Student, completion: @escaping ()->Void){
        firebaseModel.add(student: student){
            completion()
            Model.studentDataNotification.post()
        }
    }
    
    func getStudent(byId:String)->Student?{
        return firebaseModel.getStudent(byId: byId)
    }
    
    func delete(student:Student){
        firebaseModel.delete(student: student)
    }
    
    func uploadImage(name:String, image:UIImage, callback:@escaping(_ url:String)->Void){
        firebaseModel.uploadImage(name: name, image: image, callback: callback)
    }
}
