//
//  PetDao+CoreDataProperties.swift
//  StudentApp
//
//  Created by admin on 01/07/2022.
//

import Foundation
import CoreData


extension PetDao {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PetDao> {
        return NSFetchRequest<PetDao>(entityName: "PetDao")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var avatarUrl: String?
    @NSManaged public var desc: String?
    @NSManaged public var address: String?
    @NSManaged public var breed: String?
    @NSManaged public var user: String?
    @NSManaged public var lastUpdated: Int64

}

extension PetDao : Identifiable {

}
