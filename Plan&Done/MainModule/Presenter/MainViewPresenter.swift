//
//  MainViewPresenter.swift
//  Plan&Done
//
//  Created by Alexander Senin on 08.11.2022.
//

import Foundation

protocol MainViewProtocol: AnyObject {
    
}

protocol MainViewPresenterProtocol: AnyObject {
    init(view: MainViewProtocol, router: RouterProtocol, dataAdapter: CoreDataAdapterProtocol, taskManager: TaskManagerProtocol, projectGroupManager: ProjectGroupManagerProtocol)
    
    var projectGroups: [ProjectGroup] { get }
    
    func setupInitialData()
    func addTask(title: String, desc: String?, dtCreation: Date, dtDeadline: Date?, isDone: Bool, project: Project?)
    
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
    private let projectGroupManager: ProjectGroupManagerProtocol!
    
    var projectGroups: [ProjectGroup] {
        get {
            return projectGroupManager.fetchAll()
        }
    }
    
    required init(view: MainViewProtocol, router: RouterProtocol, dataAdapter: CoreDataAdapterProtocol, taskManager: TaskManagerProtocol, projectGroupManager: ProjectGroupManagerProtocol) {
        self.view = view
        self.router = router
        self.dataAdapter = dataAdapter
        self.taskManager = taskManager
        self.projectGroupManager = projectGroupManager
    }
    
    func setupInitialData() {
        if !UserDefaults.standard.bool(forKey: "SetupInitialData") {
            let dataBuilder = BaseDataBuilder(dataAdapter: dataAdapter, projectManager: ProjectManager(dataAdapter: dataAdapter), projectGroupManager: ProjectGroupManager(dataAdapter: dataAdapter))
            dataBuilder.initialAssembly()
            UserDefaults.standard.set(true, forKey: "SetupInitialData")
        }
    }
    
    func addTask(title: String, desc: String?, dtCreation: Date, dtDeadline: Date?, isDone: Bool, project: Project?) {
        taskManager.create(title: title, desc: desc, dtCreation: dtCreation, dtDeadline: dtDeadline, isDone: isDone, project: project)
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
