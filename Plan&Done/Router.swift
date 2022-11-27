//
//  Router.swift
//  Plan&Done
//
//  Created by Alexander Senin on 08.11.2022.
//

import UIKit

protocol RouterMain {
    var navigationController: UINavigationController? { get set }
    var moduleAssembler: ModuleAssemblerProtocol? { get set }
}

protocol RouterProtocol: RouterMain {
    func initialViewController()
    
    func showProject(project: Project)
    
    func showSearchOverlay()
    func showSettingsOverlay()
    
    func showEditTaskOverlay(for task: Task)
    func showEditProjectOverlay(for project: Project)
    func showNewItemOverlay()
    func showNewTaskOverlay()
    
    func showSelectProjectOverlay(viewController: UIViewController, for task: Task?)
    func showSelectDayOverlay(viewController: UIViewController, for task: Task?)
    func showSelectDeadlineOverlay(viewController: UIViewController, for task: Task?)
    
    func getCustomCellPresenter(view: CustomCellProtocol) -> CustomCellPresenterProtocol?
    
    func backToMainView()
}

class Router: RouterProtocol {
    
    var navigationController: UINavigationController?
    var moduleAssembler: ModuleAssemblerProtocol?
    
    init(navigationContriller: UINavigationController, moduleAssembler: ModuleAssemblerProtocol) {
        navigationController = navigationContriller
        self.moduleAssembler = moduleAssembler
    }
    
    func initialViewController() {
        if let navigationController = navigationController {
            guard let mainViewController = moduleAssembler?.createMainModule(router: self) else { return }
            navigationController.viewControllers = [mainViewController]
        }
    }
    
    func showProject(project: Project) {
        if let navigationController = navigationController {
            guard let projectViewController = moduleAssembler?.createProjectModule(router: self, project: project) else { return }
            navigationController.pushViewController(projectViewController, animated: true)
        }
    }
    
    func showSearchOverlay() {
        if let navigationController = navigationController {
            guard let searchOverlay = moduleAssembler?.createSearchOverlay(router: self) else { return }
            searchOverlay.appear(sender: navigationController)
        }
    }
    
    func showSettingsOverlay() {
        if let navigationController = navigationController {
            guard let settingsOverlay = moduleAssembler?.createSettingsOverlay(router: self) else { return }
            settingsOverlay.appear(sender: navigationController)
        }
    }
    
    func showEditTaskOverlay(for task: Task) {
        if let navigationController = navigationController {
            guard let editTaskOverlay = moduleAssembler?.createEditTaskOverlay(router: self) else { return }
            editTaskOverlay.appear(sender: navigationController, task: task)
        }
    }
    
    func showEditProjectOverlay(for project: Project) {
        if let navigationController = navigationController {
            guard let editProjectOverlay = moduleAssembler?.createEditProjectOverlay(router: self) else { return }
            editProjectOverlay.appear(sender: navigationController, project: project)
        }
    }
    
    func showNewItemOverlay() {
        if let navigationController = navigationController {
            guard let newItemOverlay = moduleAssembler?.createNewItemOverlay(router: self) else { return }
            newItemOverlay.appear(sender: navigationController)
        }
    }
    
    func showNewTaskOverlay() {
        if let navigationController = navigationController {
            guard let newTaskOverlay = moduleAssembler?.createNewTaskOverlay(router: self) else { return }
            navigationController.presentedViewController?.dismiss(animated: false)
            newTaskOverlay.appear(sender: navigationController)
        }
    }
    
    func showSelectProjectOverlay(viewController: UIViewController, for task: Task?) {
        guard let selectProjectOverlay = moduleAssembler?.createSelectProjectOverlay(router: self, for: task) else { return }
        selectProjectOverlay.appear(sender: viewController)
    }
    
    func showSelectDayOverlay(viewController: UIViewController, for task: Task?) {
        guard let selectDayOverlay = moduleAssembler?.createSelectDayOverlay(router: self, for: task) else { return }
        selectDayOverlay.appear(sender: viewController)
    }
    
    func showSelectDeadlineOverlay(viewController: UIViewController, for task: Task?) {
        guard let selectDeadlineOverlay = moduleAssembler?.createSelectDeadlineOverlay(router: self, for: task) else { return }
        selectDeadlineOverlay.appear(sender: viewController)
    }

    func backToMainView() {
        if let navigationController = navigationController {
            navigationController.dismiss(animated: false)
            navigationController.removeFromParent()
        }
        NotificationCenter.default.post(name: Notification.Name("ViewHasBecomeActive"), object: nil)
    }
    
    func getCustomCellPresenter(view: CustomCellProtocol) -> CustomCellPresenterProtocol? {
        guard let expandableCellPresenter = moduleAssembler?.createCustomCellPresenter(view: view, router: self) else { return nil }
        return expandableCellPresenter
    }
}
