//
//  ProjectViewPresenter.swift
//  Plan&Done
//
//  Created by Alexander Senin on 08.11.2022.
//

import Foundation

protocol ProjectViewProtocol: AnyObject {
    
}

protocol ProjectViewPresenterProtocol: AnyObject {
    init(view: ProjectViewProtocol, router: RouterProtocol, taskManager: TaskManagerProtocol, project: Project)
    
    var project: Project { get set }
    
    func addTask()
}

class ProjectViewPresenter: ProjectViewPresenterProtocol {
    
    weak var view: ProjectViewProtocol?
    var router: RouterProtocol?
    
    private let taskManager: TaskManagerProtocol!
    
    var project: Project
    
    required init(view: ProjectViewProtocol, router: RouterProtocol, taskManager: TaskManagerProtocol, project: Project) {
        self.view = view
        self.router = router
        self.taskManager = taskManager
        self.project = project
    }
    
    func addTask() {
        let title = "New Task"
        let dtCreation = Date()
        let isDone = false
        taskManager.create(title: title, desc: nil, dtCreation: dtCreation, dtDeadline: nil, isDone: isDone, project: project)
        NotificationCenter.default.post(name: Notification.Name("NewTaskHasBeenAdded"), object: nil)
    }
}
