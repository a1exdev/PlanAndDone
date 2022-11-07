//
//  DataBulider.swift
//  Plan&Done
//
//  Created by Alexander Senin on 06.11.2022.
//

import UIKit

protocol DataBuilderProtocol {
    func initialAssembly()
    func factoryReset()
}

class DataBuilder: DataBuilderProtocol {
    
    init(dataAdapter: CoreDataAdapter, taskManager: TaskManager, projectManager: ProjectManager, projectGroupManager: ProjectGroupManager) {
        self.dataAdapter = dataAdapter
        self.taskManager = taskManager
        self.projectManager = projectManager
        self.projectGroupManager = projectGroupManager
    }
    
    private let dataAdapter: CoreDataAdapter!
    private let taskManager: TaskManager!
    private let projectManager: ProjectManager!
    private let projectGroupManager: ProjectGroupManager!
    
    func initialAssembly() {
        
        for _ in 0..<4 {
            projectGroupManager.create()
        }
        let projectGroups = projectGroupManager.fetchAll()
        
        projectManager.create(title: "Inbox", image: ProjectImage.tray.rawValue, color: UIColor.systemBlue.name, group: projectGroups[0])
        
        projectManager.create(title: "Today", image: ProjectImage.star.rawValue, color: UIColor.systemYellow.name, group: projectGroups[1])
        projectManager.create(title: "Upcoming", image: ProjectImage.calendar.rawValue, color: UIColor.systemRed.name, group: projectGroups[1])
        projectManager.create(title: "Anytime", image: ProjectImage.stack.rawValue, color: UIColor.systemMint.name, group: projectGroups[1])
        projectManager.create(title: "Someday", image: ProjectImage.box.rawValue, color: UIColor.systemBrown.name, group: projectGroups[1])
        
        projectManager.create(title: "Logbook", image: ProjectImage.journal.rawValue, color: UIColor.systemGreen.name, group: projectGroups[2])
        
        projectManager.create(title: "Custom 1", image: ProjectImage.stack.rawValue, color: UIColor.systemGray.name, group: projectGroups[3])
        projectManager.create(title: "Custom 2", image: ProjectImage.stack.rawValue, color: UIColor.systemGray.name, group: projectGroups[3])
    }
    
    func factoryReset() {
        dataAdapter.resetAll()
    }
}
