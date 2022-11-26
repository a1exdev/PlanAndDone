//
//  BaseDataBulider.swift
//  Plan&Done
//
//  Created by Alexander Senin on 06.11.2022.
//

import UIKit

protocol BaseDataBuilderProtocol {
    func initialAssembly()
}

class BaseDataBuilder: BaseDataBuilderProtocol {
    
    private let dataAdapter: CoreDataAdapterProtocol!
    private let projectManager: ProjectManagerProtocol!
    private let projectGroupManager: ProjectGroupManagerProtocol!
    
    init(dataAdapter: CoreDataAdapterProtocol, projectManager: ProjectManagerProtocol, projectGroupManager: ProjectGroupManagerProtocol) {
        self.dataAdapter = dataAdapter
        self.projectManager = projectManager
        self.projectGroupManager = projectGroupManager
    }
    
    func initialAssembly() {
        
        for _ in 0..<3 {
            projectGroupManager.create(isCustom: false)
        }
        projectGroupManager.create(isCustom: true)
        
        let projectGroups = projectGroupManager.fetchAll()
        
        projectManager.create(number: 1, title: "Inbox", dtCreation: Date(), dtDeadline: nil, isDone: false, image: ProjectImage.tray.rawValue, color: UIColor.systemBlue.name, group: projectGroups[0])
        
        projectManager.create(number: 1, title: "Today", dtCreation: Date(), dtDeadline: nil, isDone: false, image: ProjectImage.star.rawValue, color: UIColor.systemYellow.name, group: projectGroups[1])
        projectManager.create(number: 2, title: "Upcoming", dtCreation: Date(), dtDeadline: nil, isDone: false, image: ProjectImage.calendar.rawValue, color: UIColor.systemRed.name, group: projectGroups[1])
        projectManager.create(number: 3, title: "Anytime", dtCreation: Date(), dtDeadline: nil, isDone: false, image: ProjectImage.stack.rawValue, color: UIColor.systemMint.name, group: projectGroups[1])
        projectManager.create(number: 4, title: "Someday", dtCreation: Date(), dtDeadline: nil, isDone: false, image: ProjectImage.box.rawValue, color: UIColor.systemBrown.name, group: projectGroups[1])
        
        projectManager.create(number: 1, title: "Logbook", dtCreation: Date(), dtDeadline: nil, isDone: false, image: ProjectImage.journal.rawValue, color: UIColor.systemGreen.name, group: projectGroups[2])
    }
}
