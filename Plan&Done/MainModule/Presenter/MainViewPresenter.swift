//
//  MainViewPresenter.swift
//  Plan&Done
//
//  Created by Alexander Senin on 08.11.2022.
//

import UIKit

protocol MainViewProtocol: AnyObject {
    
}

protocol MainViewPresenterProtocol: AnyObject {
    init(view: MainViewProtocol, router: RouterProtocol, dataAdapter: CoreDataAdapterProtocol, taskManager: TaskManagerProtocol, projectManager: ProjectManagerProtocol, projectGroupManager: ProjectGroupManagerProtocol)
    
    var items: [Item] { get }
    var projectGroups: [ProjectGroup] { get }
    
    func setupInitialData()
    func resetAllData()
    
    func addTask(title: String, desc: String?, dtDeadline: Date?, isDone: Bool, project: Project)
    func addProject()
    
    func goToItem(with id: UUID)

    func showProject(project: Project)
    
    func showSearchOverlay()
    func showSettingsOverlay()
    
    func showEditItemOverlay()
    func showNewItemOverlay()
    func showNewTaskOverlay()
    
    func showSelectProjectOverlay(viewController: UIViewController)
    func showSelectDayOverlay(viewController: UIViewController)
    func showSelectDeadlineOverlay(viewController: UIViewController)
    
    func backToMainView()
    func popToRoot()
}

class MainViewPresenter: MainViewPresenterProtocol {
    
    weak var view: MainViewProtocol?
    var router: RouterProtocol?
    
    private let dataAdapter: CoreDataAdapterProtocol!
    private let taskManager: TaskManagerProtocol!
    private let projectManager: ProjectManagerProtocol!
    private let projectGroupManager: ProjectGroupManagerProtocol!
    
    var items: [Item] {
        get {
            var items = [Item]()
            
            let tasks = taskManager.fetchAll()
            tasks.forEach { task in
                items.append(Item(id: task.id!, title: task.title!, image: nil, color: nil))
            }
            
            let projects = projectManager.fetchAll()
            projects.forEach { project in
                items.append(Item(id: project.id!, title: project.title!, image: project.image!, color: project.color!))
            }
            
            return items
        }
    }
    
    var projectGroups: [ProjectGroup] {
        get {
            return projectGroupManager.fetchAll()
        }
    }
    
    required init(view: MainViewProtocol, router: RouterProtocol, dataAdapter: CoreDataAdapterProtocol, taskManager: TaskManagerProtocol, projectManager: ProjectManagerProtocol, projectGroupManager: ProjectGroupManagerProtocol) {
        self.view = view
        self.router = router
        self.dataAdapter = dataAdapter
        self.taskManager = taskManager
        self.projectManager = projectManager
        self.projectGroupManager = projectGroupManager
    }
    
    func setupInitialData() {
        let dataBuilder = BaseDataBuilder(dataAdapter: dataAdapter, projectManager: ProjectManager(dataAdapter: dataAdapter), projectGroupManager: ProjectGroupManager(dataAdapter: dataAdapter))
        dataBuilder.initialAssembly()
    }
    
    func resetAllData() {
        UserDefaults.standard.set(false, forKey: "SetupInitialData")
        dataAdapter.resetAllData()
    }
    
    func addTask(title: String, desc: String?, dtDeadline: Date?, isDone: Bool, project: Project) {
        let dtCreation = Date()
        taskManager.create(title: title, desc: desc, dtCreation: dtCreation, dtDeadline: dtDeadline, isDone: isDone, project: project)
    }
    
    func addProject() {
        let title = "New Project"
        let image = ProjectImage.circle.rawValue
        let color = UIColor.systemGray.name
        let group = projectGroups[3]
        let number = (group.project?.allObjects as! [Project]).last?.number ?? 0
        projectManager.create(number: Int(number) + 1, title: title, image: image, color: color, group: group)
        NotificationCenter.default.post(name: Notification.Name("NewProjectHasBeenAdded"), object: nil)
    }
    
    func goToItem(with id: UUID) {
        let tasks = taskManager.fetchAll()
        tasks.forEach { task in
            if task.id == id {
                showProject(project: task.project!)
                return
            }
        }
        
        let projects = projectManager.fetchAll()
        projects.forEach { project in
            if project.id == id {
                showProject(project: project)
                return
            }
        }
    }
    
    func showProject(project: Project) {
        router?.showProject(project: project)
    }
    
    func showSearchOverlay() {
        router?.showSearchOverlay()
    }
    
    func showSettingsOverlay() {
        router?.showSettingsOverlay()
    }
    
    func showEditItemOverlay() {
        router?.showEditItemOverlay()
    }
    
    func showNewItemOverlay() {
        router?.showNewItemOverlay()
    }
    
    func showNewTaskOverlay() {
        router?.showNewTaskOverlay()
    }
    
    func showSelectProjectOverlay(viewController: UIViewController) {
        router?.showSelectProjectOverlay(viewController: viewController)
    }
    
    func showSelectDayOverlay(viewController: UIViewController) {
        router?.showSelectDayOverlay(viewController: viewController)
    }
    
    func showSelectDeadlineOverlay(viewController: UIViewController) {
        router?.showSelectDeadlineOverlay(viewController: viewController)
    }
    
    func backToMainView() {
        router?.backToMainView()
    }
    
    func popToRoot() {
        router?.popToRoot()
    }
}
