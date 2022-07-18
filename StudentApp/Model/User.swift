//
//  User.swift
//  StudentApp
//
//  Created by admin on 18/07/2022.
//

import Foundation
import Firebase

class User {
    public var id: String? = ""
    public var name: String? = ""
    public var email: String? = ""

    init(){}
    
    init(user:User){
        id = user.id
        name = user.name
        email = user.email
    }
}

extension User{
    static func FromJson(json:[String:Any])->User{
        let user = User()
        user.id = json["id"] as? String
        user.name = json["name"] as? String
        user.email = json["email"] as? String
        return user
    }
    
    func toJson()->[String:Any]{
        var json = [String:Any]()
        json["id"] = self.id!
        json["name"] = self.name!
        json["email"] = self.email!
        return json
    }
}
