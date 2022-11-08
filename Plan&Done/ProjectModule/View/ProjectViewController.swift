//
//  ProjectViewController.swift
//  Plan&Done
//
//  Created by Alexander Senin on 28.10.2022.
//

import UIKit

class ProjectViewController: UIViewController {
    
    var presenter: ProjectViewPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ProjectViewController: ProjectViewProtocol {
    
}
