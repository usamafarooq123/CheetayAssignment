//  
//  MoviesViewModel.swift
//  CheetayAssignment
//
//  Created by usama farooq on 07/07/2023.
//

import Foundation

typealias MoviesViewModelOutput = (MoviesViewModelImpl.Output) -> Void

protocol MoviesViewModelInput {
    
}

protocol MoviesViewModel: MoviesViewModelInput {
    var output: MoviesViewModelOutput? { get set}
    
    func viewModelDidLoad()
    func viewModelWillAppear()
    func numberOfRows() -> Int
    func cellViewModel(forRow row: Int) -> MoviesCellViewModel
    func searchMovie(with name: String)
    func didSelect(with row: Int)
}

class MoviesViewModelImpl: MoviesViewModel, MoviesViewModelInput {
    
    //MARK: Private Properties
    private let router: MoviesRouter
    private let dataStore: MoviesDataStoreable
    private var movies = [Movie]()
    private let debouncer = Debouncer(interval: 0.5)
    var output: MoviesViewModelOutput?
    
    
    init(router: MoviesRouter, dataStore: MoviesDataStoreable) {
        self.router = router
        self.dataStore = dataStore
    }
    
    func viewModelDidLoad() {
        fetchMovies()
    }
    
    func fetchMovies() {
        dataStore.moviesList { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                self.movies = response.movies
                self.send(.reload)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func searchMovie(with name: String) {
        guard name.count > 0 else {return}
        debouncer.debounce {
            self.dataStore.searchMovies(with: name) { [weak self] result in
                guard let self = self else {return}
                switch result {
                case .success(let response):
                    self.movies = response.movies
                    print(response.movies.count)
                    self.send(.reload)
                case .failure(let error):
                    let message = error.localizedDescription
                    self.movies = []
                    self.send(.reload)
                    self.send(.setEmptyView(message))
                    print(error.localizedDescription)
                }
            }
        }
        

    }
    
    private func send(_ state: Output) {
        
        if Thread.isMainThread {
            output?(state)
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.output?(state)
            }
        }
    }
    
    func viewModelWillAppear() {
        
    }
    
    //For all of your viewBindings
    enum Output {
        case reload
        case setEmptyView(String)
    }
}

extension MoviesViewModelImpl {
    
    func numberOfRows() -> Int {
        return movies.count
    }
    
    func cellViewModel(forRow row: Int) -> MoviesCellViewModel {
        let movie = movies[row]
        return MoviesCellViewModel(name: movie.title, releaseData: movie.releaseDate, imagePath: movie.posterPath ?? "")
    }
    
    func didSelect(with row: Int) {
        let movie = movies[row]
        router.routeToDetail(with: movie)
    }
}
