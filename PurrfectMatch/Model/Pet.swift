//
//  Pet.swift
//  PurrfectMatch
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
    public var longtitude: Double? = 0
    public var latitude: Double? = 0
    public var breed: String? = ""
    public var user: String? = ""
    public var lastUpdated: Int64 = 0
    public var hasBeenDeleted: Bool = false

    init(){}
    
    init(pet:PetDao){
        id = pet.id
        name = pet.name
        phone = pet.phone
        avatarUrl = pet.avatarUrl
        desc = pet.desc
        address = pet.address
        breed = pet.breed
        user = pet.user
        lastUpdated = pet.lastUpdated
        longtitude = pet.longtitude as? Double
        latitude = pet.latitude as? Double
        hasBeenDeleted = pet.hasBeenDeleted
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
        p.user = json["user"] as? String
        p.longtitude = json["longtitude"] as? Double
        p.latitude = json["latitude"] as? Double
        p.hasBeenDeleted = json["hasBeenDeleted"] as? Bool ?? true
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
        json["user"] = self.user!
        json["longtitude"] = self.longtitude!
        json["latitude"] = self.latitude!
        json["hasBeenDeleted"] = self.hasBeenDeleted
        json["lastUpdated"] = FieldValue.serverTimestamp()
        return json
    }
}
