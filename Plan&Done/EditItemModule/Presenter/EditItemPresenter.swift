//
//  EditItemPresenter.swift
//  Plan&Done
//
//  Created by Alexander Senin on 25.11.2022.
//

import UIKit

protocol EditItemProtocol: AnyObject {

}

protocol EditItemPresenterProtocol: AnyObject {
    init(view: EditItemProtocol, router: RouterProtocol, taskManager: TaskManagerProtocol, projectManager: ProjectManagerProtocol)

    var task: Task? { get set }
    var project: Project? { get set }
    
    func removeProject()
    func changeProjectState()
    func changeProjectTitle(newTitle: String)
    func changeProjectImage(newImage: String)
    func changeProjectColor(newColor: String)
    func changeProjectCreation(newCreation: Date)
    func changeProjectDeadline(newDeadline: Date)
    
    func removeTask()
    func changeTaskState()
    func changeTaskTitle(newTitle: String)
    func changeTaskDescription(newDescription: String)
    func changeTaskCreation(newCreation: Date)
    func changeTaskDeadline(newDeadline: Date?)
    func changeTaskProject(newProject: Project)
    
    func showMoreActionsOverlay(viewController: UIViewController)
    
    func showSelectProjectOverlay(viewController: UIViewController)
    func showSelectDayOverlay(viewController: UIViewController)
    func showSelectDeadlineOverlay(viewController: UIViewController)
    
    func backToMainView()
}

class CustomCellPresenter: EditItemPresenterProtocol {
    
    weak var view: EditItemProtocol?
    var router: RouterProtocol?
    
    private let taskManager: TaskManagerProtocol!
    private let projectManager: ProjectManagerProtocol!
    
    var task: Task?
    var project: Project?
    
    required init(view: EditItemProtocol, router: RouterProtocol, taskManager: TaskManagerProtocol, projectManager: ProjectManagerProtocol) {
        self.view = view
        self.router = router
        self.taskManager = taskManager
        self.projectManager = projectManager
    }
    
    func removeProject() {
        let tasks = project?.task?.allObjects as! [Task]
        tasks.forEach { task in
            taskManager.remove((task.id)!)
        }
        projectManager.remove((project?.id)!)
        backToMainView()
    }
    
    func changeProjectState() {
        projectManager.changeState(id: (project?.id)!)
    }
    
    func changeProjectTitle(newTitle: String) {
        projectManager.changeTitle(id: (project?.id)!, newTitle: newTitle)
    }
    
    func changeProjectImage(newImage: String) {
        projectManager.changeImage(id: (project?.id)!, newImage: newImage)
    }
    
    func changeProjectColor(newColor: String) {
        projectManager.changeColor(id: (project?.id)!, newColor: newColor)
    }
    
    func changeProjectCreation(newCreation: Date) {
        projectManager.changeCreation(id: (project?.id)!, newCreation: newCreation)
    }
    
    func changeProjectDeadline(newDeadline: Date) {
        projectManager.changeDeadline(id: (project?.id)!, newDeadline: newDeadline)
    }
    
    func removeTask() {
        taskManager.remove((task?.id)!)
        backToMainView()
    }
    
    func changeTaskState() {
        taskManager.changeState(id: (task?.id)!)
    }
    
    func changeTaskTitle(newTitle: String) {
        taskManager.changeTitle(id: (task?.id)!, newTitle: newTitle)
    }
    
    func changeTaskDescription(newDescription: String) {
        taskManager.changeDescription(id: (task?.id)!, newDescription: newDescription)
    }
    
    func changeTaskCreation(newCreation: Date) {
        taskManager.changeCreation(id: (task?.id)!, newCreation: newCreation)
    }
    
    func changeTaskDeadline(newDeadline: Date?) {
        taskManager.changeDeadline(id: (task?.id)!, newDeadline: newDeadline ?? nil)
    }
    
    func changeTaskProject(newProject: Project) {
        taskManager.changeProject(id: (task?.id)!, newProject: newProject)
    }
    
    func showMoreActionsOverlay(viewController: UIViewController) {
        router?.showMoreActionsOverlay(viewController: viewController, task: task, project: project)
    }
    
    func showSelectProjectOverlay(viewController: UIViewController) {
        router?.showSelectProjectOverlay(viewController: viewController, for: task)
    }
    
    func showSelectDayOverlay(viewController: UIViewController) {
        router?.showSelectDayOverlay(viewController: viewController, task: task, project: project)
    }
    
    func showSelectDeadlineOverlay(viewController: UIViewController) {
        router?.showSelectDeadlineOverlay(viewController: viewController, task: task, project: project)
    }
    
    func backToMainView() {
        router?.backToMainView()
    }
}

