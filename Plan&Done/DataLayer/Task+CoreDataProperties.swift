//
//  Task+CoreDataProperties.swift
//  Plan&Done
//
//  Created by Alexander Senin on 05.11.2022.
//
//

import Foundation
import CoreData

extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var desc: String?
    @NSManaged public var dtCreation: Date?
    @NSManaged public var dtDeadline: Date?
    @NSManaged public var isDone: Bool
    @NSManaged public var project: Project?
}

extension Task: Identifiable {

}
