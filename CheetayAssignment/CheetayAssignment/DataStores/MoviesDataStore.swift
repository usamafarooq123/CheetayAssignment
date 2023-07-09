//
//  MoviesDataStore.swift
//  CheetayAssignment
//
//  Created by usama farooq on 07/07/2023.
//

import Foundation

typealias MoviesDataStoreCompletion = (Result<MoviesResponse, Error>) -> Void
typealias SearchMoviesDataStoreCompletion = (Result<MoviesResponse, Error>) -> Void

/// - Parameter completion: block triggered when fetching is completed.
protocol MoviesDataStoreable {
    func moviesList(page: Int, completion: @escaping MoviesDataStoreCompletion)
    func searchMovies(with page: Int,name: String, completion: @escaping SearchMoviesDataStoreCompletion)
}

final class MoviesDataStore: BaseDataStore, MoviesDataStoreable {

    private let translation: ObjectTranslator
    
    init(service: Service, translation: ObjectTranslator = ObjectTranslation()) {
        self.translation = translation
        super.init(service: service)
    }
    
    func moviesList(page: Int, completion: @escaping MoviesDataStoreCompletion) {
        
        service.get(request: MoviesRequest(page: page)) {[weak self] (result) in
            switch result {
            case .success(let data):
                self?.translateResponse(data: data, completion: completion)
            case .failure(let error):
                completion(.failure(MoviesDataStoreError.networkError(error)))
            }
        }
    }
    
    func searchMovies(with page: Int, name: String, completion: @escaping SearchMoviesDataStoreCompletion) {
        let request = MovieSearchRequest(name: name, page: page)
        service.get(request: request) { [weak self] (result) in
            switch result {
            case .success(let data):
                self?.translateResponse(data: data, completion: completion)
            case .failure(let error):
                completion(.failure(MoviesDataStoreError.networkError(error)))
            }
        }
    }
    
    private func translateResponse(data: Data, completion: MoviesDataStoreCompletion) {
        do {
            let response: MoviesResponse = try translation.decodeObject(data: data)
            if  response.movies.isEmpty {
                completion(.failure(MoviesDataStoreError.noMoviesFound))
            } else {
                completion(.success(response) )
            }
        } catch let error {
            completion(.failure(MoviesDataStoreError.decodingError(error)))
        }
    }
}

extension MoviesDataStore {
    enum MoviesDataStoreError: Error {
        case networkError(Error)
        case decodingError(Error)
        case noMoviesFound
    }
}

extension MoviesDataStore.MoviesDataStoreError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .decodingError:
                return "Incorrect result recieved, please try again"
            case .networkError:
                return "Something went wrong, please try again"
            case .noMoviesFound:
                return "No movies found"
        }
    }
}
