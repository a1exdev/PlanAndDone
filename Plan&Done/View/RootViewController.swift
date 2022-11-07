//
//  RootViewController.swift
//  Plan&Done
//
//  Created by Alexander Senin on 05.11.2022.
//

import UIKit

class RootViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if !UserDefaults.standard.bool(forKey: "SetupInitialData") {
            
            let dataAdapter = CoreDataAdapter.shared
            
            let dataBuilder = DataBuilder(dataAdapter: dataAdapter, taskManager: TaskManager(dataAdapter: dataAdapter), projectManager: ProjectManager(dataAdapter: dataAdapter), projectGroupManager: ProjectGroupManager(dataAdapter: dataAdapter))
            
            dataBuilder.initialAssembly()
            UserDefaults.standard.set(true, forKey: "SetupInitialData")
        }
    }
}
