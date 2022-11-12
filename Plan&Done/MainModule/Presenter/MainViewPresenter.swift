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
    
    var projectGroups: [ProjectGroup] { get }
    
    func setupInitialData()
    func resetAllData()
    
    func addTask(title: String, desc: String?, dtDeadline: Date?, isDone: Bool, project: Project)
    func addProject()

    func showProject()
    func showNewItemOverlay()
    func showNewTaskOverlay()
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
        dataAdapter.resetAllData()
        UserDefaults.standard.set(false, forKey: "SetupInitialData")
    }
    
    func addTask(title: String, desc: String?, dtDeadline: Date?, isDone: Bool, project: Project) {
        let dtCreation = Date()
        taskManager.create(title: title, desc: desc, dtCreation: dtCreation, dtDeadline: dtDeadline, isDone: isDone, project: project)
    }
    
    func addProject() {
        let title = "New Project"
        let image = ProjectImage.stack.rawValue
        let color = UIColor.systemBlue.name
        let group = projectGroups[3]
        projectManager.create(title: title, image: image, color: color, group: group)
        NotificationCenter.default.post(name: Notification.Name("NewProjectHasBeenAdded"), object: nil)
    }
    
    func showProject() {
        print("Show project")
    }
    
    func showNewItemOverlay() {
        router?.showNewItemOverlay()
    }
    
    func showNewTaskOverlay() {
        router?.showNewTaskOverlay()
    }
    
    func backToMainView() {
        router?.backToMainView()
    }
    
    func popToRoot() {
        router?.popToRoot()
    }
}
