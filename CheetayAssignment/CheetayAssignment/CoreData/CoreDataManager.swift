//
//  CoreDataManager.swift
//  CheetayAssignment
//
//  Created by usama farooq on 08/07/2023.
//

import Foundation
import CoreData

final class CoreDataManager {
    private let coreDataStack: CoreDataStack
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    private func objectToMovieModel(object: NSManagedObject) -> MovieProtocol {
        let id = (object.value(forKey: "id") as! Int)
        let title = (object.value(forKey: "title") as! String)
        let releaseData = (object.value(forKey: "releaseDate") as! String)
        let overView = (object.value(forKey: "overView") as! String)
        let posterPath = (object.value(forKey: "posterPath") as? String)
        let backdropPath = (object.value(forKey: "backdropPath") as? String)
        let isLiked = (object.value(forKey: "isLiked") as! Bool)
        
        return MovieModel(backdropPath: backdropPath, posterPath: posterPath, id: id, title: title, releaseDate: releaseData, overView: overView, isLiked: isLiked)
    }
    
    func fetchMovies() -> [MovieProtocol] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CoreDataEntity.movie.rawValue)
        do {
            let objects = try coreDataStack.readContext().fetch(fetchRequest)
            var users = [MovieProtocol]()
            if objects.count > 0 {
                for object in objects {
                    let user = objectToMovieModel(object: object)
                    users.append(user)
                }
            }
            return users
        } catch  {
            print("Error in fetch all movies: \(error)")
        }
        return []
    }
    
    private func likeMovie(entity: String, movie: MovieProtocol) -> Bool {
        let predicate = NSPredicate(format: "id == '\(movie.id)'")
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entity)
        fetchRequest.predicate = predicate
        
        return coreDataStack.writeContext().performAndWait {
            do {
                let movies = try coreDataStack.writeContext().fetch(fetchRequest)
                if movies.count > 0, let movieObject = movies.first {
                    movieObject.setValue(movie.isLiked, forKey: "isLiked")
                    try coreDataStack.writeContext().save()
                    return true
                }
            } catch  {
                print("Could not fetch: \(error)")
            }
            return false
        }
    }
    
    func save(movie: MovieProtocol) {
        guard fetchMovie(by: movie.id) == nil else {return}
        let context = coreDataStack.writeContext()
        guard let entity = NSEntityDescription.entity(forEntityName: CoreDataEntity.movie.rawValue, in: context) else {return}
        return context.performAndWait {
            let newUser = NSManagedObject(entity: entity, insertInto: context)
        
            newUser.setValue(movie.id, forKey: "id")
            newUser.setValue(movie.isLiked, forKey: "isLiked")
            newUser.setValue(movie.backdropPath, forKey: "backdropPath")
            newUser.setValue(movie.posterPath, forKey: "posterPath")
            newUser.setValue(movie.overView, forKey: "overView")
            newUser.setValue(movie.releaseDate, forKey: "releaseDate")
            newUser.setValue(movie.title, forKey: "title")
            do {
                try context.save()
                print("Success")
            } catch {
                print("Error saving: \(error)")
            }
        }
    }

    func fetchMovie(by id: Int) -> MovieProtocol? {
        let predicate = NSPredicate(format: "id == '\(id)'")
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CoreDataEntity.movie.rawValue)
        fetchRequest.predicate = predicate
        do {
            let movies = try coreDataStack.readContext().fetch(fetchRequest)
            if movies.count > 0 {
                let moviesObject = movies.first!
                let movie = objectToMovieModel(object: moviesObject)
                return movie
            }
        } catch  {
            print("Error in update movie: \(error)")
        }
        return nil
    }

}
