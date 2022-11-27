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
    
    var searchItems: [SearchItems] { get }
    var projectGroups: [ProjectGroup] { get }
    
    func setupInitialData()
    func resetAllData()
    
    func addProject()
    func goToItem(with id: UUID)
    func showProject(project: Project)
    
    func showSearchOverlay()
    func showEditProjectOverlay(for project: Project)
    func showSettingsOverlay()
    func showNewItemOverlay()
    func showNewTaskOverlay()
    
    func backToMainView()
    
    func getExpandableCellPresenter(view: CustomCellProtocol) -> CustomCellPresenterProtocol?
}

class MainViewPresenter: MainViewPresenterProtocol {
    
    weak var view: MainViewProtocol?
    var router: RouterProtocol?
    
    private let dataAdapter: CoreDataAdapterProtocol!
    private let taskManager: TaskManagerProtocol!
    private let projectManager: ProjectManagerProtocol!
    private let projectGroupManager: ProjectGroupManagerProtocol!
    
    var searchItems: [SearchItems] {
        get {
            var searchItems = [SearchItems]()
            
            let tasks = taskManager.fetchAll()
            if !tasks.isEmpty {
                tasks.forEach { task in
                    if task.title != "" {
                        searchItems.append(SearchItems(id: task.id!, title: task.title!, image: nil, color: nil))
                    }
                }
            }
            
            let projects = projectManager.fetchAll()
            projects.forEach { project in
                if project.title != "" {
                    searchItems.append(SearchItems(id: project.id!, title: project.title!, image: project.image!, color: project.color!))
                }
            }
            
            return searchItems
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
        UserDefaults.standard.removeObject(forKey: "SetupInitialData")
        dataAdapter.resetAllData()
    }
    
    func addProject() {
        let title = ""
        let dtCreation = Date()
        let isDone = false
        let image = ProjectImage.circle.rawValue
        let color = UIColor.systemGray.name
        let group = projectGroups.first { $0.isCustom == true }
        let number = Int(((group!.project?.allObjects as! [Project]).count) + 1)
        projectManager.create(number: number, title: title, dtCreation: dtCreation, dtDeadline: nil, isDone: isDone, image: image, color: color, group: group!)
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
    
    func showEditProjectOverlay(for project: Project) {
        router?.showEditProjectOverlay(for: project)
    }
    
    func showSettingsOverlay() {
        router?.showSettingsOverlay()
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
    
    func getExpandableCellPresenter(view: CustomCellProtocol) -> CustomCellPresenterProtocol? {
        router?.getCustomCellPresenter(view: view)
    }
}
