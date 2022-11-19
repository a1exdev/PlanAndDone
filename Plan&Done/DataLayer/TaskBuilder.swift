//
//  TaskBuilder.swift
//  Plan&Done
//
//  Created by Alexander Senin on 18.11.2022.
//

import Foundation

protocol TaskBuilderProtocol {
    static var shared: TaskBuilder { get }
    
    func resetTask()
    
    func produceTitle(_ title: String)
    func produceDesc(_ desc: String?)
    func produceDtCreation(_ dtCreation: Date)
    func produceDtDeadline(_ dtDeadline: Date?)
    func produceIsDone(_ isDone: Bool)
    func produceProject(_ project: Project)
    
    func fetchDtCreation() -> Date?
    func fetchDtDeadline() -> Date?
    func fetchProject() -> Project?
    
    func retrieveTask()
}

class TaskBuilder: TaskBuilderProtocol {
    
    static var shared: TaskBuilder = {
        let instance = TaskBuilder(taskManager: TaskManager(dataAdapter: CoreDataAdapter.shared))
        return instance
    }()
    
    private init(taskManager: TaskManagerProtocol) {
        self.taskManager = taskManager
    }
    
    private let taskManager: TaskManagerProtocol!
    
    private var title: String?
    private var desc: String?
    private var dtCreation: Date?
    private var dtDeadline: Date?
    private var isDone: Bool?
    private var project: Project?
    
    func resetTask() {
        title = nil
        desc = nil
        dtCreation = nil
        dtDeadline = nil
        isDone = nil
        project = nil
    }
    
    func produceTitle(_ title: String) {
        self.title = title
    }
    
    func produceDesc(_ desc: String?) {
        self.desc = desc
    }
    
    func produceDtCreation(_ dtCreation: Date) {
        self.dtCreation = dtCreation
    }
    
    func produceDtDeadline(_ dtDeadline: Date?) {
        self.dtDeadline = dtDeadline
    }
    
    func produceIsDone(_ isDone: Bool) {
        self.isDone = isDone
    }
    
    func produceProject(_ project: Project) {
        self.project = project
    }
    
    func fetchDtCreation() -> Date? {
        return self.dtCreation
    }
    
    func fetchDtDeadline() -> Date? {
        return self.dtDeadline
    }
    
    func fetchProject() -> Project? {
        return self.project
    }
    
    func retrieveTask() {
        taskManager.create(title: self.title!, desc: self.desc, dtCreation: self.dtCreation!, dtDeadline: self.dtDeadline, isDone: self.isDone!, project: self.project!)
        resetTask()
    }
}

extension TaskBuilder: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
