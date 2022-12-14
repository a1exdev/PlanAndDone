//
//  CoreDataAdapter.swift
//  Plan&Done
//
//  Created by Alexander Senin on 05.11.2022.
//

import CoreData

protocol CoreDataAdapterProtocol {
    static var shared: CoreDataAdapter { get }
    
    func saveContext()
    func resetAllData()
    
    func fetchObjects<T: NSManagedObject>(of type: T.Type) -> [T]
    func deleteObject<T: NSManagedObject>(_ object: T)
    
    func saveTask(title: String, desc: String?, dtCreation: Date, dtDeadline: Date?, isDone: Bool, project: Project)
    func saveProject(number: Int, title: String, dtCreation: Date, dtDeadline: Date?, isDone: Bool, image: String, color: String, group: ProjectGroup)
    func saveProjectGroup(isCustom: Bool)
}

class CoreDataAdapter: CoreDataAdapterProtocol {
    
    static var shared: CoreDataAdapter = {
        let instance = CoreDataAdapter()
        return instance
    }()
    
    private init() {}

    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Plan_Done")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                context.rollback()
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func resetAllData() {
        let storeContainer = persistentContainer.persistentStoreCoordinator

        for store in storeContainer.persistentStores {
            do {
                try storeContainer.destroyPersistentStore(
                    at: store.url!,
                    ofType: store.type,
                    options: nil
                )
            } catch let error {
                print(error.localizedDescription)
            }
        }

        persistentContainer = NSPersistentContainer(name: "Plan_Done")

        persistentContainer.loadPersistentStores {
            (store, error) in
            print(store)
            if let error {
                print(error.localizedDescription)
            }
        }
        
        exit(-1)
    }
    
    func fetchObjects<T: NSManagedObject>(of type: T.Type) -> [T] {
        guard let request = T.fetchRequest() as? NSFetchRequest<T> else { return [] }
        let result = try? context.fetch(request)
        return result!
    }
    
    func deleteObject<T: NSManagedObject>(_ object: T) {
        context.delete(object)
        saveContext()
    }
    
    func saveTask(title: String, desc: String?, dtCreation: Date, dtDeadline: Date?, isDone: Bool, project: Project) {
        
        let task = Task(context: context)
        task.id = UUID()
        task.title = title
        task.desc = desc
        task.dtCreation = dtCreation
        task.dtDeadline = dtDeadline
        task.isDone = isDone
        task.project = project
        
        saveContext()
    }
    
    func saveProject(number: Int, title: String, dtCreation: Date, dtDeadline: Date?, isDone: Bool, image: String, color: String, group: ProjectGroup) {
        
        let project = Project(context: context)
        project.id = UUID()
        project.number = Int16(number)
        project.title = title
        project.dtCreation = dtCreation
        project.dtDeadline = dtDeadline
        project.isDone = isDone
        project.image = image
        project.color = color
        project.group = group
        
        saveContext()
    }
    
    func saveProjectGroup(isCustom: Bool) {
        let projectGroup = ProjectGroup(context: context)
        projectGroup.id = UUID()
        projectGroup.isCustom = isCustom
        saveContext()
    }
}

extension CoreDataAdapter: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
