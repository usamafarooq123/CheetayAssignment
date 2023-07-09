//  
//  MovieDetailViewModel.swift
//  CheetayAssignment
//
//  Created by usama farooq on 08/07/2023.
//

import Foundation

protocol MovieDetailDelegate: AnyObject {
    func update(movie id: Int)
}


typealias MovieDetailViewModelOutput = (MovieDetailViewModelImpl.Output) -> Void

protocol MovieDetailViewModelInput {
    
}

protocol MovieDetailViewModel: MovieDetailViewModelInput {
    var output: MovieDetailViewModelOutput? { get set}
    
    func viewModelDidLoad()
    func viewModelWillAppear()
    func numberOfRows() -> Int
    func cellViewModel(forRow row: Int) -> MovieDetailCellViewModel
    func movieLike()
}

class MovieDetailViewModelImpl: MovieDetailViewModel, MovieDetailViewModelInput {

    private let router: MovieDetailRouter
    private var isLiked = false
    var output: MovieDetailViewModelOutput?
    var movie: MovieProtocol
    let corDataManager: CoreDataManager
    unowned var delegate: MovieDetailDelegate
    
    init(router: MovieDetailRouter, movie: MovieProtocol, coreDataManager: CoreDataManager, delegate: MovieDetailDelegate) {
        self.router = router
        self.movie = movie
        self.corDataManager = coreDataManager
        self.delegate = delegate
    }
    
    func viewModelDidLoad() {
        send(.reload)
        isLiked = movie.isLiked
        send(.updateLikeButton(movie.isLiked))
    }
    
    func viewModelWillAppear() {
        
    }
    
    //For all of your viewBindings
    enum Output {
        case reload
        case updateLikeButton(Bool)
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
}

extension MovieDetailViewModelImpl {
    
    func numberOfRows() -> Int {
        return 1
    }
    
    func cellViewModel(forRow row: Int) -> MovieDetailCellViewModel {
        return MovieDetailCellViewModel(name: movie.title,
                                        releaseData: movie.releaseDate,
                                        headerImagePath: movie.backdropPath,
                                        posterImagePath: movie.posterPath,
                                        description: movie.overView)
    }
    
    func movieLike() {
        isLiked = !isLiked
        send(.updateLikeButton(isLiked))
        movie.isLiked = isLiked
        corDataManager.likeMovie(movie: movie)
        delegate.update(movie: movie.id)
    }
}
