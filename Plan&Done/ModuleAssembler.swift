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

    func createSearchOverlay(router: RouterProtocol) -> SearchOverlay
    func createSettingsOverlay(router: RouterProtocol) -> SettingsOverlay

    func createEditTaskOverlay(router: RouterProtocol) -> EditTaskOverlay
    func createEditProjectOverlay(router: RouterProtocol) -> EditProjectOverlay
    func createMoreActionsOverlay(router: RouterProtocol) -> MoreActionsOverlay
    func createNewItemOverlay(router: RouterProtocol) -> NewItemOverlay
    func createNewTaskOverlay(router: RouterProtocol) -> NewTaskOverlay

    func createSelectProjectOverlay(router: RouterProtocol, for task: Task?) -> SelectProjectOverlay
    func createSelectDayOverlay(router: RouterProtocol, task: Task?, project: Project?) -> SelectDayOverlay
    func createSelectDeadlineOverlay(router: RouterProtocol, task: Task?, project: Project?) -> SelectDeadlineOverlay
    
    func createCustomCellPresenter(view: EditItemProtocol, router: RouterProtocol) -> EditItemPresenterProtocol
}

class ModuleAssembler: ModuleAssemblerProtocol {

    private let coreDataAdapter = CoreDataAdapter.shared
    private let taskBuilder = TaskBuilder.shared
    private lazy var taskManager = TaskManager(dataAdapter: coreDataAdapter)
    private lazy var projectManager = ProjectManager(dataAdapter: coreDataAdapter)
    private lazy var projectGroupManager = ProjectGroupManager(dataAdapter: coreDataAdapter)

    func createMainModule(router: RouterProtocol) -> UIViewController {
        let view = MainViewController()
        let presenter = MainViewPresenter(view: view, router: router, dataAdapter: coreDataAdapter, taskManager: taskManager, projectManager: projectManager, projectGroupManager: projectGroupManager)
        view.presenter = presenter
        return view
    }

    func createSearchOverlay(router: RouterProtocol) -> SearchOverlay {
        let view = SearchOverlay()
        let presenter = MainViewPresenter(view: view, router: router, dataAdapter: coreDataAdapter, taskManager: taskManager, projectManager: projectManager, projectGroupManager: projectGroupManager)
        view.presenter = presenter
        return view
    }

    func createSettingsOverlay(router: RouterProtocol) -> SettingsOverlay {
        let view = SettingsOverlay()
        let presenter = MainViewPresenter(view: view, router: router, dataAdapter: coreDataAdapter, taskManager: taskManager, projectManager: projectManager, projectGroupManager: projectGroupManager)
        view.presenter = presenter
        return view
    }
    
    func createEditTaskOverlay(router: RouterProtocol) -> EditTaskOverlay {
        let view = EditTaskOverlay()
        let presenter = CustomCellPresenter(view: view, router: router, taskManager: taskManager, projectManager: projectManager)
        view.presenter = presenter
        return view
    }
    
    func createEditProjectOverlay(router: RouterProtocol) -> EditProjectOverlay {
        let view = EditProjectOverlay()
        let presenter = CustomCellPresenter(view: view, router: router, taskManager: taskManager, projectManager: projectManager)
        view.presenter = presenter
        return view
    }
    
    func createMoreActionsOverlay(router: RouterProtocol) -> MoreActionsOverlay {
        let view = MoreActionsOverlay()
        let presenter = CustomCellPresenter(view: view, router: router, taskManager: taskManager, projectManager: projectManager)
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
        let presenter = NewTaskPresenter(view: view, router: router, taskBuilder: taskBuilder, taskManager: taskManager, projectGroupManager: projectGroupManager)
        view.presenter = presenter
        return view
    }

    func createSelectProjectOverlay(router: RouterProtocol, for task: Task?) -> SelectProjectOverlay {
        let view = SelectProjectOverlay()
        let newTaskPresenter = NewTaskPresenter(view: view, router: router, taskBuilder: taskBuilder, taskManager: taskManager, projectGroupManager: projectGroupManager)
        let customCellPresenter = CustomCellPresenter(view: view, router: router, taskManager: taskManager, projectManager: projectManager)
        view.newTaskPresenter = newTaskPresenter
        view.customCellPresenter = customCellPresenter
        view.task = task
        return view
    }

    func createSelectDayOverlay(router: RouterProtocol, task: Task?, project: Project?) -> SelectDayOverlay {
        let view = SelectDayOverlay()
        let newTaskPresenter = NewTaskPresenter(view: view, router: router, taskBuilder: taskBuilder, taskManager: taskManager, projectGroupManager: projectGroupManager)
        let customCellPresenter = CustomCellPresenter(view: view, router: router, taskManager: taskManager, projectManager: projectManager)
        view.newTaskPresenter = newTaskPresenter
        view.customCellPresenter = customCellPresenter
        view.task = task
        view.project = project
        return view
    }

    func createSelectDeadlineOverlay(router: RouterProtocol, task: Task?, project: Project?) -> SelectDeadlineOverlay {
        let view = SelectDeadlineOverlay()
        let newTaskPresenter = NewTaskPresenter(view: view, router: router, taskBuilder: taskBuilder, taskManager: taskManager, projectGroupManager: projectGroupManager)
        let customCellPresenter = CustomCellPresenter(view: view, router: router, taskManager: taskManager, projectManager: projectManager)
        view.newTaskPresenter = newTaskPresenter
        view.customCellPresenter = customCellPresenter
        view.task = task
        view.project = project
        return view
    }

    func createProjectModule(router: RouterProtocol, project: Project) -> UIViewController {
        let view = ProjectViewController()
        let presenter = ProjectViewPresenter(view: view, router: router, taskManager: taskManager, project: project)
        view.presenter = presenter
        return view
    }
    
    func createCustomCellPresenter(view: EditItemProtocol, router: RouterProtocol) -> EditItemPresenterProtocol {
        let presenter = CustomCellPresenter(view: view, router: router, taskManager: taskManager, projectManager: projectManager)
        return presenter
    }
}
