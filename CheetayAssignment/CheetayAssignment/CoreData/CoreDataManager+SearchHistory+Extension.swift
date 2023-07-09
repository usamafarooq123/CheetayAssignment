//
//  CoreDataManager+SearchHistory+Extension.swift
//  CheetayAssignment
//
//  Created by usama farooq on 08/07/2023.
//

import Foundation
import CoreData

extension CoreDataManager {
    func save(search: String) {
        guard getHistory(by: search) == nil else {return}
        let context = coreDataStack.writeContext()
        guard let entity = NSEntityDescription.entity(forEntityName: CoreDataEntity.history.rawValue, in: context) else {return}
        return context.performAndWait {
            let newUser = NSManagedObject(entity: entity, insertInto: context)
            newUser.setValue(search, forKey: "title")
            do {
                try context.save()
                print("Success")
            } catch {
                print("Error saving: \(error)")
            }
        }
    }

    func getHistory(by search: String) -> String? {
        let predicate = NSPredicate(format: "title == '\(search)'")
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CoreDataEntity.history.rawValue)
        fetchRequest.predicate = predicate
        do {
            let searches = try coreDataStack.readContext().fetch(fetchRequest)
            if searches.count > 0 {
                let moviesObject = searches.first!
                let title = (moviesObject.value(forKey: "title") as! String)
                return title
            }
        } catch  {
            print("Error in update movie: \(error)")
        }
        return nil
    }
    
    func fetchSearches() -> [String] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CoreDataEntity.history.rawValue)
        do {
            let objects = try coreDataStack.readContext().fetch(fetchRequest)
            var searches = [String]()
            if objects.count > 0 {
                for object in objects {
                    let search = (object.value(forKey: "title") as! String)
                    searches.append(search)
                }
            }
            return searches.suffix(10)
        } catch  {
            print("Error in fetch all movies: \(error)")
        }
        return []
    }
}
