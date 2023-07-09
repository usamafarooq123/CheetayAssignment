//  
//  FavouriteMoviesViewModel.swift
//  CheetayAssignment
//
//  Created by usama farooq on 09/07/2023.
//

import Foundation

typealias FavouriteMoviesViewModelOutput = (FavouriteMoviesViewModelImpl.Output) -> Void

protocol FavouriteMoviesViewModelInput {
    
}

protocol FavouriteMoviesViewModel: FavouriteMoviesViewModelInput {
    var output: FavouriteMoviesViewModelOutput? { get set}
    
    func viewModelDidLoad()
    func viewModelWillAppear()
    func numberOfRows() -> Int
    func cellViewModel(forRow row: Int) -> MoviesCellViewModel
    func didSelect(with row: Int)
    func likeMovie(index: Int, state: Bool)
}

class FavouriteMoviesViewModelImpl: FavouriteMoviesViewModel, FavouriteMoviesViewModelInput {

    private let router: FavouriteMoviesRouter
    private var favMovies = [MovieProtocol]()
    var output: FavouriteMoviesViewModelOutput?
    let coreDataManager: CoreDataManager
    
    init(router: FavouriteMoviesRouter, coreDataManager: CoreDataManager) {
        self.router = router
        self.coreDataManager = coreDataManager
    }
    
    func viewModelDidLoad() {
        createObserver()
        fetchFavMovies()
    }
    
    func viewModelWillAppear() {
        
    }
    
    func fetchFavMovies() {
        let movies = coreDataManager.fetchMovies()
        favMovies =  movies.filter({$0.isLiked == true})
        send(.reload)
    }
    ///  Use this function to register an observer that listens for a notification with the name .likeMovie. When the like notification is posted, the specified selector method, methodOfReceivedNotification(notification:), will be called.
    func createObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: .likeMovie, object: nil)
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        fetchFavMovies()
    }
    
    func sendNotification() {
        NotificationCenter.default.post(name: .likeMovie, object: String(describing: FavouriteMoviesViewModelImpl.self))
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
    
    //For all of your viewBindings
    enum Output {
        case reload
    }
}

extension FavouriteMoviesViewModelImpl {
    func numberOfRows() -> Int {
        return favMovies.count
    }
    
    func cellViewModel(forRow row: Int) -> MoviesCellViewModel {
        let movie = favMovies[row]
        return MoviesCellViewModel(name: movie.title, releaseData: movie.releaseDate, imagePath: movie.posterPath ?? "", isLike: true, index: row)
    }
    
    func didSelect(with row: Int) {
        router.routeToDetail(with: favMovies[row], coreDataManger: coreDataManager, delegate: self)
    }
    
    func likeMovie(index: Int, state: Bool) {
        favMovies[index].isLiked = state
        coreDataManager.likeMovie(movie: favMovies[index])
        sendNotification()
    }
}

extension FavouriteMoviesViewModelImpl: MovieDetailDelegate {
    func update(movie id: Int) {
        guard let index = favMovies.firstIndex(where: {$0.id == id}) else {return}
        favMovies[index].isLiked = coreDataManager.getLiked(movieId: id)
        sendNotification()
    }
}
