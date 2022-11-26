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
    
    func create(isCustom: Bool)
    func remove(_ id: UUID)
}

class ProjectGroupManager: ProjectGroupManagerProtocol {
    
    private let dataAdapter: CoreDataAdapterProtocol!
    
    init(dataAdapter: CoreDataAdapterProtocol) {
        self.dataAdapter = dataAdapter
    }
    
    func fetchAll() -> [ProjectGroup] {
        let projectGroups = dataAdapter.fetchObjects(of: ProjectGroup.self)
        return projectGroups
    }
    
    func fetchById(_ id: UUID) -> ProjectGroup? {
        let projectGroups = fetchAll()
        let projectGroup = projectGroups.filter{ $0.id == id }.first
        return projectGroup
    }
    
    func create(isCustom: Bool) {
        dataAdapter.saveProjectGroup(isCustom: isCustom)
    }
    
    func remove(_ id: UUID) {
        guard let projectGroup = fetchById(id) else { return }
        dataAdapter.deleteObject(projectGroup)
    }
}
