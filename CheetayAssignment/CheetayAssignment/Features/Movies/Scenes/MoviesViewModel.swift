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
    func searchTextDidChange(text: String)
    
}

final class MoviesViewModelImpl: MoviesViewModel, MoviesViewModelInput {
    
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
        createObserver()
    }
    
    
    func createObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: .likeMovie, object: nil)
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        if let notification = notification.object as? String {
            if String(describing: MoviesViewModelImpl.self) != notification {
                send(.reload)
            }
        }
    }
    
    func sendNotification() {
        NotificationCenter.default.post(name: .likeMovie, object: String(describing: MoviesViewModelImpl.self))
    }
    
    func fetchMovies(text: String?) {
        if text?.isEmpty ?? true {
            fetchMovies()
        } else {
            searchMovie(text: text!)
        }
    }
   /// This method is called when initiating a movie search with the given text. It first checks if the oldSearch value is nil or different from the current search text. If it is, it clears the movies array, triggers a reload of the associated view, and updates the oldSearch value and pageNo to initial values. If the oldSearch value matches the current search text, it increments the pageNo by 1, unless the waiting flag is true. Finally, it calls the searchMovie(with:) method to perform the actual movie search with the provided text.

    func searchMovie(text: String) {
        if oldSearch == nil || oldSearch != text {
            movies = []
            send(.reload)
            oldSearch = text
            pageNo = 1
        } else {
            guard !waiting else {return}
            pageNo += 1
        }
        searchMovie(with: text)
    }
    
    
    func fetchMovies() {
        if oldSearch == nil {
            guard !waiting else {return}
            pageNo += 1
        } else {
            oldSearch = nil
            pageNo = 1
        }
        moreMovies(page: pageNo)
    }
    
    func searchTextDidChange(text: String) {
        if text.isEmpty {
            fetchSearchHistory()
            fetchMovies(text: nil)
        } else {
            send(.showSuggestionView(true))
            fetchMovies(text: text)
        }
    }
    
    func likeMovie(index: Int, state: Bool) {
        movies[index].isLiked = state
        coreDataManager.likeMovie(movie: movies[index])
        sendNotification()
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
                self.load(movies: response.movies)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    ///This method iterates over the given movies array and saves each movie using the coreDataManager. After saving the movies, it fetches the updated list of movies from the data store and updates the movies property of the current instance. Finally, it sends the .reload output state to trigger a reload of the associated view.

    func load(movies: [MovieProtocol]) {
        for movie in movies {
            coreDataManager.save(movie: movie)
        }
        let localMovies = coreDataManager.fetchMovies()
        self.movies = localMovies
        send(.reload)
    }
    ///This method appends the given movies array to the existing movies array in the data source. It then iterates over the movies and saves each movie using the coreDataManager. Additionally, it saves the search query name using the coreDataManager. Finally, it sends the .reload output state to trigger a reload of the associated view.
    func loadSeach(movies: [MovieProtocol], name: String) {
        self.movies.append(contentsOf: movies)
        for movie in movies {
            coreDataManager.save(movie: movie)
        }
        coreDataManager.save(search: name)
        send(.reload)
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
                    self.loadSeach(movies: response.movies, name: name)
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
    ///This method checks if the current execution thread is the main thread. If it is, the output closure is called directly with the provided state. If it's not, the output closure is dispatched asynchronously to the main thread to ensure safe access to UI-related operations.
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
        case showSuggestionView(Bool)
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
        movies[index].isLiked = coreDataManager.getLiked(movieId: id)
        send(.reloadCell(index))
        sendNotification()
    }
}
