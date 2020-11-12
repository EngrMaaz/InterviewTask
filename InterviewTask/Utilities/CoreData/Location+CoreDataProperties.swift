//
//  Location+CoreDataProperties.swift
//  InterviewTask
//
//  Created by HAPPY on 12/11/2020.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var city: String?
    @NSManaged public var id: UUID?
    @NSManaged public var lat: Double
    @NSManaged public var lon: Double
    @NSManaged public var state: String?

}

extension Location : Identifiable {

}
