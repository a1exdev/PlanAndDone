//
//  ProjectManager.swift
//  Plan&Done
//
//  Created by Alexander Senin on 06.11.2022.
//

import UIKit

protocol ProjectManagerProtocol {
    func fetchAll() -> [Project]
    func fetchById(_ id: UUID) -> Project?
    
    func create(number: Int, title: String, dtCreation: Date, dtDeadline: Date?, isDone: Bool, image: String, color: String, group: ProjectGroup)
    func remove(_ id: UUID)
    
    func changeState(id: UUID)
    func changeTitle(id: UUID, newTitle: String)
    func changeCreation(id: UUID, newCreation: Date)
    func changeDeadline(id: UUID, newDeadline: Date)
    func changeImage(id: UUID, newImage: String)
    func changeColor(id: UUID, newColor: String)
}

class ProjectManager: ProjectManagerProtocol {
    
    private let dataAdapter: CoreDataAdapterProtocol!
    
    init(dataAdapter: CoreDataAdapterProtocol) {
        self.dataAdapter = dataAdapter
    }
    
    func fetchAll() -> [Project] {
        let projects = dataAdapter.fetchObjects(of: Project.self)
        return projects
    }
    
    func fetchById(_ id: UUID) -> Project? {
        let projects = fetchAll()
        let project = projects.filter{ $0.id == id }.first
        return project
    }
    
    func create(number: Int, title: String, dtCreation: Date, dtDeadline: Date?, isDone: Bool, image: String, color: String, group: ProjectGroup) {
        dataAdapter.saveProject(number: number, title: title, dtCreation: dtCreation, dtDeadline: dtDeadline, isDone: isDone, image: image, color: color, group: group)
    }
    
    func remove(_ id: UUID) {
        guard let projectToDelete = fetchById(id) else { return }
        let projects = fetchAll()
        projects.forEach { project in
            if project.number > projectToDelete.number {
                project.number -= 1
            }
        }
        dataAdapter.deleteObject(projectToDelete)
    }
    
    func changeState(id: UUID) {
        guard let project = fetchById(id) else { return }
        let projectState = project.isDone
        
        switch projectState {
        case true:
            if project.task?.count == 0 {
                changeImage(id: project.id!, newImage: ProjectImage.circle.rawValue)
            } else {
                changeImage(id: project.id!, newImage: ProjectImage.pie.rawValue)
            }
            changeColor(id: project.id!, newColor: UIColor.systemGray.name)
            project.isDone = false
        default:
            changeImage(id: project.id!, newImage: ProjectImage.done.rawValue)
            changeColor(id: project.id!, newColor: UIColor.systemBlue.name)
            project.isDone = true
        }
        
        dataAdapter.saveContext()
    }
    
    func changeTitle(id: UUID, newTitle: String) {
        guard let project = fetchById(id) else { return }
        project.title = newTitle
        dataAdapter.saveContext()
    }
    
    func changeCreation(id: UUID, newCreation: Date) {
        guard let project = fetchById(id) else { return }
        project.dtCreation = newCreation
        dataAdapter.saveContext()
    }
    
    func changeDeadline(id: UUID, newDeadline: Date) {
        guard let project = fetchById(id) else { return }
        project.dtDeadline = newDeadline
        dataAdapter.saveContext()
    }
    
    func changeImage(id: UUID, newImage: String) {
        guard let project = fetchById(id) else { return }
        project.image = newImage
        dataAdapter.saveContext()
    }
    
    func changeColor(id: UUID, newColor: String) {
        guard let project = fetchById(id) else { return }
        project.color = newColor
        dataAdapter.saveContext()
    }
}
