//
//  ProjectGroup+CoreDataProperties.swift
//  Plan&Done
//
//  Created by Alexander Senin on 05.11.2022.
//
//

import Foundation
import CoreData

extension ProjectGroup {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProjectGroup> {
        return NSFetchRequest<ProjectGroup>(entityName: "ProjectGroup")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var project: NSSet?
}

// MARK: Generated accessors for project
extension ProjectGroup {

    @objc(addProjectObject:)
    @NSManaged public func addToProject(_ value: Project)

    @objc(removeProjectObject:)
    @NSManaged public func removeFromProject(_ value: Project)

    @objc(addProject:)
    @NSManaged public func addToProject(_ values: NSSet)

    @objc(removeProject:)
    @NSManaged public func removeFromProject(_ values: NSSet)
}

extension ProjectGroup: Identifiable {

}
