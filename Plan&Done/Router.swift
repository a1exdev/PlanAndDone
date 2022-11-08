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
    func initialViewController(projectGroups: [ProjectGroup]?)
    func showProject(tasks: [Task]?)
    func showNewItemOverlay()
    func showNewTaskOverlay()
    func backToMainView()
    func popToRoot()
}

class Router: RouterProtocol {
    
    var navigationController: UINavigationController?
    var moduleAssembler: ModuleAssemblerProtocol?
    
    init(navigationContriller: UINavigationController, moduleAssembler: ModuleAssemblerProtocol) {
        self.navigationController = navigationContriller
        self.moduleAssembler = moduleAssembler
    }
    
    func initialViewController(projectGroups: [ProjectGroup]?) {
        if let navigationController = navigationController {
            guard let mainViewController = moduleAssembler?.createMainModule(projectGroups: projectGroups, router: self) else { return }
            navigationController.viewControllers = [mainViewController]
        }
    }
    
    func showProject(tasks: [Task]?) {
        if let navigationController = navigationController {
            guard let projectViewController = moduleAssembler?.createProjectModule(tasks: tasks, router: self) else { return }
            navigationController.pushViewController(projectViewController, animated: true)
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
    
    func backToMainView() {
        if let navigationController = navigationController {
            navigationController.dismiss(animated: false)
            navigationController.removeFromParent()
            NotificationCenter.default.post(name: Notification.Name("ViewHasBecomeActive"), object: nil)
        }
    }
    
    func popToRoot() {
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
}
