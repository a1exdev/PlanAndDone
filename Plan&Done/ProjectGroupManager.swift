//
//  ProjectGroupManager.swift
//  Plan&Done
//
//  Created by Alexander Senin on 06.11.2022.
//

import Foundation

protocol ProjectGroupManagerProtocol {
    func fetchAll() -> [ProjectGroup]
    func fetchById(_ id: UUID) -> ProjectGroup?
    
    func create()
    func remove(_ id: UUID)
}

class ProjectGroupManager: ProjectGroupManagerProtocol {
    
    init(dataAdapter: CoreDataAdapter) {
        self.dataAdapter = dataAdapter
    }
    
    private let dataAdapter: CoreDataAdapter!
    
    func fetchAll() -> [ProjectGroup] {
        let projectGroups = dataAdapter.fetchObjects(of: ProjectGroup.self)
        return projectGroups
    }
    
    func fetchById(_ id: UUID) -> ProjectGroup? {
        let projectGroups = fetchAll()
        let projectGroup = projectGroups.filter{ $0.id == id }.first
        return projectGroup
    }
    
    func create() {
        dataAdapter.saveProjectGroup()
    }
    
    func remove(_ id: UUID) {
        guard let projectGroup = fetchById(id) else { return }
        dataAdapter.deleteObject(projectGroup)
    }
}
