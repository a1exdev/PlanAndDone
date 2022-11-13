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
    
    func showEditItemOverlay()
    func showNewItemOverlay()
    func showNewTaskOverlay()
    
    func showSelectProjectOverlay()
    func showSelectDayOverlay()
    func showSelectDeadlineOverlay()
    
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
        print("Show search overlay")
    }
    
    func showSettingsOverlay() {
        print("Show settings overlay")
    }
    
    func showEditItemOverlay() {
        print("Show edit item overlay")
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
    
    func showSelectProjectOverlay() {
        print("Show select project overlay")
    }
    
    func showSelectDayOverlay() {
        print("Show select day overlay")
    }
    
    func showSelectDeadlineOverlay() {
        print("Show select deadline overlay")
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
