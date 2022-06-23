//
//  Student.swift
//  StudentApp
//
//  Created by Eliav Menachi on 11/05/2022.
//

import Foundation
import Firebase

class Student{
    public var id: String? = ""
    public var name: String? = ""
    public var phone: String? = ""
    public var avatarUrl: String? = ""
    public var lastUpdated: Int64 = 0

    init(){}
    
    init(student:StudentDao){
        id = student.id
        name = student.name
        phone = student.phone
        avatarUrl = student.avatarUrl
        lastUpdated = student.lastUpdated
    }
}

extension Student{
    static func FromJson(json:[String:Any])->Student{
        let s = Student()
        s.id = json["id"] as? String
        s.name = json["name"] as? String
        s.phone = json["phone"] as? String
        s.avatarUrl = json["avatarUrl"] as? String
        if let lup = json["lastUpdated"] as? Timestamp{
            s.lastUpdated = lup.seconds
        }
        return s
    }
    
    func toJson()->[String:Any]{
        var json = [String:Any]()
        json["id"] = self.id!
        json["name"] = self.name!
        json["phone"] = self.phone!
        json["avatarUrl"] = self.avatarUrl!
        json["lastUpdated"] = FieldValue.serverTimestamp()
        return json
    }
}
