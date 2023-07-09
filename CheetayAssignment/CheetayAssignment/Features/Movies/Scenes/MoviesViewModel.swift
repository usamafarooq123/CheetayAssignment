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
    func fetchMovies(text: String?)
    func numberOfRows() -> Int
    func cellViewModel(forRow row: Int) -> MoviesCellViewModel
    func didSelect(with row: Int)
    func fetchSearchHistory()
    func likeMovie(index: Int, state: Bool)
    
}

class MoviesViewModelImpl: MoviesViewModel, MoviesViewModelInput {
    
    //MARK: Private Properties
    private let router: MoviesRouter
    private let dataStore: MoviesDataStoreable
    private var movies = [MovieProtocol]()
    private let debouncer = Debouncer(interval: 1)
    private let coreDataManager: CoreDataManager
    private var waiting: Bool = false
    private var pageNo: Int = 0
    private var oldSearch: String?
    var output: MoviesViewModelOutput?
    
    
    init(router: MoviesRouter, dataStore: MoviesDataStoreable, coreDataManager: CoreDataManager) {
        self.router = router
        self.dataStore = dataStore
        self.coreDataManager = coreDataManager
    }
    
    func viewModelDidLoad() {
       
    }
    
    func fetchMovies(text: String?) {
//        guard !waiting else {return}
        if text?.isEmpty ?? true {
            if oldSearch == nil {
                guard !waiting else {return}
                pageNo += 1
            } else {
                oldSearch = nil
                pageNo = 1
            }
            fetchMovies()
        } else {
            if oldSearch == nil || oldSearch != text {
                movies = []
                send(.reload)
                oldSearch = text
                pageNo = 1
            } else {
                guard !waiting else {return}
                pageNo += 1
            }
            searchMovie(with: text!)
        }
    }
    
    func fetchMovies() {
        moreMovies(page: pageNo)
    }
    
    func calculatePage() {
        
    }
    
    func likeMovie(index: Int, state: Bool) {
        movies[index].isLiked = state
        coreDataManager.likeMovie(movie: movies[index])
    }
    
    func getLiked(movieId: Int) -> Bool {
       return coreDataManager.getLiked(movieId: movieId)
    }
    
    func moreMovies(page: Int) {
       
        waiting = true
        dataStore.moviesList(page: page) { [weak self] result in
            guard let self = self else {return}
            self.waiting = false
            switch result {
                
            case .success(let response):
                for movie in response.movies {
                    self.coreDataManager.save(movie: movie)
                }
                let localMovies = self.coreDataManager.fetchMovies()
                self.movies = localMovies
                self.send(.reload)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func searchMovie(with name: String) {
        waiting = true
        guard name.count > 0 else {return}
        debouncer.debounce {
            self.dataStore.searchMovies(with: self.pageNo, name: name) { [weak self] result in
               
                guard let self = self else {return}
                self.waiting = false
                switch result {
                case .success(let response):
                    self.movies.append(contentsOf: response.movies)
                    for movie in response.movies {
                        self.coreDataManager.save(movie: movie)
                    }
                    self.coreDataManager.save(search: name)
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
        case setHistory([String])
        case reloadCell(Int)
    }
}

extension MoviesViewModelImpl {
    
    func numberOfRows() -> Int {
        return movies.count
    }
    
    func cellViewModel(forRow row: Int) -> MoviesCellViewModel {
        let movie = movies[row]
        return MoviesCellViewModel(name: movie.title, releaseData: movie.releaseDate, imagePath: movie.posterPath ?? "", isLike: getLiked(movieId: movie.id), index: row)
    }
    
    func didSelect(with row: Int) {
        let movie = movies[row]
        router.routeToDetail(with: movie, coreDataManger: coreDataManager, delegate: self)
    }
    
    func fetchSearchHistory() {
        let searchHistory = coreDataManager.fetchSearches()
        guard searchHistory.count != 0 else {return}
        send(.setHistory(searchHistory))
    }
}

extension MoviesViewModelImpl: MovieDetailDelegate {
    func update(movie id: Int) {
        guard let index = movies.firstIndex(where: {$0.id == id}) else {return}
        send(.reloadCell(index))
    }
    
    
}
