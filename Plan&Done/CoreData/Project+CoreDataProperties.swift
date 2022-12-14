//
//  Project+CoreDataProperties.swift
//  Plan&Done
//
//  Created by Alexander Senin on 13.11.2022.
//
//

import Foundation
import CoreData

extension Project {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Project> {
        return NSFetchRequest<Project>(entityName: "Project")
    }

    @NSManaged public var color: String?
    @NSManaged public var id: UUID?
    @NSManaged public var image: String?
    @NSManaged public var number: Int16
    @NSManaged public var title: String?
    @NSManaged public var isDone: Bool
    @NSManaged public var dtCreation: Date?
    @NSManaged public var dtDeadline: Date?
    @NSManaged public var group: ProjectGroup?
    @NSManaged public var task: NSSet?
}

// MARK: Generated accessors for task
extension Project {

    @objc(addTaskObject:)
    @NSManaged public func addToTask(_ value: Task)

    @objc(removeTaskObject:)
    @NSManaged public func removeFromTask(_ value: Task)

    @objc(addTask:)
    @NSManaged public func addToTask(_ values: NSSet)

    @objc(removeTask:)
    @NSManaged public func removeFromTask(_ values: NSSet)
}

extension Project: Identifiable {

}
