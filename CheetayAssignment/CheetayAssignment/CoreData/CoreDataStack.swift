//
//  CoreDataStack.swift
//  CheetayAssignment
//
//  Created by usama farooq on 08/07/2023.
//

import CoreData

final class CoreDataStack {
    
    fileprivate let modelName: String = "CheetayAssignment"
    
    private let concurrentQueue = DispatchQueue(label: "serialQueue.coreData", qos: .default,
                                            attributes: .concurrent)

     func readContext() -> NSManagedObjectContext {
        var context: NSManagedObjectContext!
        concurrentQueue.sync {
            context = self.storeContainer().viewContext
        }
        return context
    }
    
     func writeContext() -> NSManagedObjectContext {
        var context: NSManagedObjectContext!
        concurrentQueue.sync(flags: .barrier) {
            context = self.storeContainer().viewContext
        }
        return context
    }
    
    @available(iOS 10.0, *)
    fileprivate func storeContainer() -> NSPersistentContainer {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }
    
    fileprivate func storeCoordinator() -> NSPersistentStoreCoordinator {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentDirectory.appendingPathComponent("\(self.modelName)).sqlite")
        let failureReason = "There was an error creating or loading the application's saved data."
        do  {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url)
        }   catch   {
            print("sql persistant store coordinator error: \(error), reason: \(failureReason)")
        }
        return coordinator
    }
    
    // MARK: - Helping Properties
    lazy fileprivate var applicationDocumentDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(urls.last!)
        return urls.last!
    }()
    
    lazy fileprivate var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "mom")
        return NSManagedObjectModel(contentsOf: modelURL!)!
    }()

}

