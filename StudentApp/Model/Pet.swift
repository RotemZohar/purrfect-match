//
//  Pet.swift
//  StudentApp
//
//  Created by admin on 01/07/2022.
//

import Foundation
import Firebase

class Pet {
    public var id: String? = ""
    public var name: String? = ""
    public var phone: String? = ""
    public var avatarUrl: String? = ""
    public var desc: String? = ""
    public var address: String? = ""
    public var breed: String? = ""
    public var user: String? = ""
    public var lastUpdated: Int64 = 0

    init(){}
    
    init(pet:PetDao){
        id = pet.id
        name = pet.name
        phone = pet.phone
        avatarUrl = pet.avatarUrl
        desc = pet.desc
        address = pet.address
        breed = pet.breed
        lastUpdated = pet.lastUpdated
    }
}

extension Pet{
    static func FromJson(json:[String:Any])->Pet{
        let p = Pet()
        p.id = json["id"] as? String
        p.name = json["name"] as? String
        p.phone = json["phone"] as? String
        p.avatarUrl = json["avatarUrl"] as? String
        p.desc = json["desc"] as? String
        p.address = json["address"] as? String
        p.breed = json["breed"] as? String
        if let lup = json["lastUpdated"] as? Timestamp{
            p.lastUpdated = lup.seconds
        }
        return p
    }
    
    func toJson()->[String:Any]{
        var json = [String:Any]()
        json["id"] = self.id!
        json["name"] = self.name!
        json["phone"] = self.phone!
        json["avatarUrl"] = self.avatarUrl!
        json["desc"] = self.desc!
        json["address"] = self.address!
        json["breed"] = self.breed!
        json["lastUpdated"] = FieldValue.serverTimestamp()
        return json
    }
}
