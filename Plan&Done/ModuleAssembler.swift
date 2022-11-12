//
//  ModuleAssembler.swift
//  Plan&Done
//
//  Created by Alexander Senin on 08.11.2022.
//

import UIKit

protocol ModuleAssemblerProtocol {
    func createMainModule(router: RouterProtocol) -> UIViewController
    func createProjectModule(router: RouterProtocol, project: Project) -> UIViewController
    
    func createNewItemOverlay(router: RouterProtocol) -> NewItemOverlay
    func createNewTaskOverlay(router: RouterProtocol) -> NewTaskOverlay
}

class ModuleAssembler: ModuleAssemblerProtocol {
    
    private let coreDataAdapter = CoreDataAdapter.shared
    private lazy var taskManager = TaskManager(dataAdapter: coreDataAdapter)
    private lazy var projectManager = ProjectManager(dataAdapter: coreDataAdapter)
    private lazy var projectGroupManager = ProjectGroupManager(dataAdapter: coreDataAdapter)
    
    func createMainModule(router: RouterProtocol) -> UIViewController {
        let view = MainViewController()
        let presenter = MainViewPresenter(view: view, router: router, dataAdapter: coreDataAdapter, taskManager: taskManager, projectManager: projectManager, projectGroupManager: projectGroupManager)
        view.presenter = presenter
        return view
    }
    
    func createNewItemOverlay(router: RouterProtocol) -> NewItemOverlay {
        let view = NewItemOverlay()
        let presenter = MainViewPresenter(view: view, router: router, dataAdapter: coreDataAdapter, taskManager: taskManager, projectManager: projectManager, projectGroupManager: projectGroupManager)
        view.presenter = presenter
        return view
    }
    
    func createNewTaskOverlay(router: RouterProtocol) -> NewTaskOverlay {
        let view = NewTaskOverlay()
        let presenter = MainViewPresenter(view: view, router: router, dataAdapter: coreDataAdapter, taskManager: taskManager, projectManager: projectManager, projectGroupManager: projectGroupManager)
        view.presenter = presenter
        return view
    }
    
    func createProjectModule(router: RouterProtocol, project: Project) -> UIViewController {
        let view = ProjectViewController()
        let presenter = ProjectViewPresenter(view: view, router: router, taskManager: taskManager, project: project)
        view.presenter = presenter
        return view
    }
}
