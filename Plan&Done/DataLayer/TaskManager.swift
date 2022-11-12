//
//  TaskManager.swift
//  Plan&Done
//
//  Created by Alexander Senin on 06.11.2022.
//

import Foundation

protocol TaskManagerProtocol {
    func fetchAll() -> [Task]
    func fetchById(_ id: UUID) -> Task?
    
    func create(title: String, desc: String?, dtCreation: Date, dtDeadline: Date?, isDone: Bool, project: Project)
    func remove(_ id: UUID)
    
    func changeTitle(id: UUID, newTitle: String)
    func changeDescription(id: UUID, newDescription: String)
    func changeDeadline(id: UUID, newDeadline: Date)
    func changeState(id: UUID)
}

class TaskManager: TaskManagerProtocol {
    
    private let dataAdapter: CoreDataAdapterProtocol!
    
    init(dataAdapter: CoreDataAdapterProtocol) {
        self.dataAdapter = dataAdapter
    }
    
    func fetchAll() -> [Task] {
        let tasks = dataAdapter.fetchObjects(of: Task.self)
        return tasks
    }
    
    func fetchById(_ id: UUID) -> Task? {
        let tasks = fetchAll()
        let task = tasks.filter{ $0.id == id }.first
        return task
    }
    
    func create(title: String, desc: String?, dtCreation: Date, dtDeadline: Date?, isDone: Bool, project: Project) {
        dataAdapter.saveTask(title: title, desc: desc, dtCreation: dtCreation, dtDeadline: dtDeadline, isDone: isDone, project: project)
    }
    
    func remove(_ id: UUID) {
        guard let task = fetchById(id) else { return }
        dataAdapter.deleteObject(task)
    }
    
    func changeTitle(id: UUID, newTitle: String) {
        guard let task = fetchById(id) else { return }
        task.title = newTitle
        dataAdapter.saveContext()
    }
    
    func changeDescription(id: UUID, newDescription: String) {
        guard let task = fetchById(id) else { return }
        task.desc = newDescription
        dataAdapter.saveContext()
    }
    
    func changeDeadline(id: UUID, newDeadline: Date) {
        guard let task = fetchById(id) else { return }
        task.dtDeadline = newDeadline
        dataAdapter.saveContext()
    }
    
    func changeState(id: UUID) {
        guard let task = fetchById(id) else { return }
        let taskState = task.isDone
        
        switch taskState {
        case true:
            task.isDone = false
        default:
            task.isDone = true
        }
        
        dataAdapter.saveContext()
    }
}
