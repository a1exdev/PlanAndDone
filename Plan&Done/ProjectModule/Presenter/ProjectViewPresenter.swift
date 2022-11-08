//
//  ProjectViewPresenter.swift
//  Plan&Done
//
//  Created by Alexander Senin on 08.11.2022.
//

import Foundation

protocol ProjectViewProtocol: AnyObject {
    
}

protocol ProjectViewPresenterProtocol: AnyObject {
    init(view: ProjectViewProtocol, router: RouterProtocol)
}

class ProjectViewPresenter: ProjectViewPresenterProtocol {
    
    weak var view: ProjectViewProtocol?
    var router: RouterProtocol?
    
    required init(view: ProjectViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
}
