//
//  StudentDao+CoreDataProperties.swift
//  StudentApp
//
//  Created by Eliav Menachi on 11/05/2022.
//
//

import Foundation
import CoreData


extension StudentDao {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StudentDao> {
        return NSFetchRequest<StudentDao>(entityName: "StudentDao")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var avatarUrl: String?
    @NSManaged public var lastUpdated: Int64

}

extension StudentDao : Identifiable {

}
