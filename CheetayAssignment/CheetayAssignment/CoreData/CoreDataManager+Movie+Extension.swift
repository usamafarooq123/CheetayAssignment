//
//  CoreDataManager+Movie+Extension.swift
//  CheetayAssignment
//
//  Created by usama farooq on 08/07/2023.
//

import Foundation
import CoreData

extension CoreDataManager {
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
            var movies = [MovieProtocol]()
            if objects.count > 0 {
                for object in objects {
                    let movie = objectToMovieModel(object: object)
                    movies.append(movie)
                }
            }
            return movies
        } catch  {
            print("Error in fetch all movies: \(error)")
        }
        return []
    }
    
    func likeMovie(movie: MovieProtocol) {
        let predicate = NSPredicate(format: "id == '\(movie.id)'")
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: CoreDataEntity.movie.rawValue)
        fetchRequest.predicate = predicate
        
        return coreDataStack.writeContext().performAndWait {
            do {
                let movies = try coreDataStack.writeContext().fetch(fetchRequest)
                if movies.count > 0, let movieObject = movies.first {
                    movieObject.setValue(movie.isLiked, forKey: "isLiked")
                    try coreDataStack.writeContext().save()
                    
                }
            } catch  {
                print("Could not fetch: \(error)")
            }
        }
    }
    
    func getLiked(movieId: Int) -> Bool {
        guard let movie = fetchMovie(by: movieId) else {return false}
        return movie.isLiked
        
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
            let movies = try coreDataStack.writeContext().fetch(fetchRequest)
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
