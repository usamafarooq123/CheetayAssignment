//
//  CoreDataManager.swift
//  CheetayAssignment
//
//  Created by usama farooq on 08/07/2023.
//

import Foundation
import CoreData
/**
 The `CoreDataManager` class provides a centralized interface for managing Core Data operations and interactions.

 Use this class to perform common Core Data tasks, such as initializing the Core Data stack, saving changes to the managed object context, fetching and updating data, and managing relationships between entities.

 ## Initialization

 To initialize the `CoreDataManager`, create an instance and call the `initialize` method. This will set up the Core Data stack, including the managed object model, persistent store coordinator, and managed object context.

 ## Saving Changes

 To save changes to the managed object context, call the `saveContext` method. This ensures that any modifications made to managed objects are persisted to the underlying persistent store.

 ## Fetching Data

 Use the `fetch` methods provided by the `CoreDataManager` to retrieve data from the persistent store. You can perform simple fetches with predicates and sort descriptors, or more complex fetches with compound predicates and relationships.

 ## Updating Data

 The `CoreDataManager` also provides methods for creating, updating, and deleting managed objects. Use the `createObject` method to create a new managed object, `updateObject` to modify an existing object, and `deleteObject` to delete an object from the managed object context.
**/


final class CoreDataManager {
    let coreDataStack: CoreDataStack
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
}
