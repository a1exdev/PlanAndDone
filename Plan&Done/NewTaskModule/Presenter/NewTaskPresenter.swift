//
//  NewTaskPresenter.swift
//  Plan&Done
//
//  Created by Alexander Senin on 19.11.2022.
//

import UIKit

protocol NewTaskProtocol: AnyObject {

}

protocol NewTaskPresenterProtocol: AnyObject {
    init(view: NewTaskProtocol, router: RouterProtocol, taskBuilder: TaskBuilderProtocol, taskManager: TaskManagerProtocol, projectGroupManager: ProjectGroupManagerProtocol)

    var projectGroups: [ProjectGroup] { get }
    
    func produceTaskTitle(_ title: String)
    func produceTaskDesc(_ desc: String)
    func produceTaskCreation(_ creation: Date?)
    func produceTaskDeadline(_ deadline: Date?)
    func produceTaskIsDone(_ isDone: Bool)
    func produceTaskProject(_ project: Project)
    
    func fetchTaskCreation() -> Date?
    func fetchTaskDeadline() -> Date?
    func fetchTaskProject() -> Project?
    
    func resetTask()
    func createTask()
    
    func showSelectProjectOverlay(viewController: UIViewController)
    func showSelectDayOverlay(viewController: UIViewController)
    func showSelectDeadlineOverlay(viewController: UIViewController)
    
    func backToMainView()
}

class NewTaskPresenter: NewTaskPresenterProtocol {
    
    weak var view: NewTaskProtocol?
    var router: RouterProtocol?
    
    private let taskBuilder: TaskBuilderProtocol!
    private let taskManager: TaskManagerProtocol!
    private let projectGroupManager: ProjectGroupManagerProtocol!
    
    var projectGroups: [ProjectGroup] {
        get {
            return projectGroupManager.fetchAll()
        }
    }
    
    required init(view: NewTaskProtocol, router: RouterProtocol, taskBuilder: TaskBuilderProtocol, taskManager: TaskManagerProtocol, projectGroupManager: ProjectGroupManagerProtocol) {
        self.view = view
        self.router = router
        self.taskBuilder = taskBuilder
        self.taskManager = taskManager
        self.projectGroupManager = projectGroupManager
    }
    
    func produceTaskTitle(_ title: String) {
        taskBuilder.produceTitle(title)
    }
    
    func produceTaskDesc(_ desc: String) {
        taskBuilder.produceDesc(desc)
    }
    
    func produceTaskCreation(_ creation: Date?) {
        taskBuilder.produceDtCreation(creation ?? nil)
    }
    
    func produceTaskDeadline(_ deadline: Date?) {
        taskBuilder.produceDtDeadline(deadline)
    }
    
    func produceTaskIsDone(_ isDone: Bool) {
        taskBuilder.produceIsDone(isDone)
    }
    
    func produceTaskProject(_ project: Project) {
        taskBuilder.produceProject(project)
    }
    
    func fetchTaskCreation() -> Date? {
        return taskBuilder.fetchDtCreation()
    }
    
    func fetchTaskDeadline() -> Date? {
        return taskBuilder.fetchDtDeadline()
    }
    
    func fetchTaskProject() -> Project? {
        return taskBuilder.fetchProject()
    }
    
    func resetTask() {
        taskBuilder.resetTask()
    }
    
    func createTask() {
        taskBuilder.retrieveTask()
    }
    
    func showSelectProjectOverlay(viewController: UIViewController) {
        router?.showSelectProjectOverlay(viewController: viewController, for: nil)
    }
    
    func showSelectDayOverlay(viewController: UIViewController) {
        router?.showSelectDayOverlay(viewController: viewController, for: nil)
    }
    
    func showSelectDeadlineOverlay(viewController: UIViewController) {
        router?.showSelectDeadlineOverlay(viewController: viewController, for: nil)
    }
    
    func backToMainView() {
        router?.backToMainView()
    }
}
