//
//  SprintTimer+CoreDataProperties.swift
//  Sprints
//
//  Created by Nadia Siddiqah on 1/14/21.
//
//

import Foundation
import CoreData


extension SprintTimer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SprintTimer> {
        return NSFetchRequest<SprintTimer>(entityName: "SprintTimer")
    }

    @NSManaged public var hour: String
    @NSManaged public var min: String
    @NSManaged public var sec: String

}

extension SprintTimer : Identifiable {

}
