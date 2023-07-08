//  
//  MovieDetailViewModel.swift
//  CheetayAssignment
//
//  Created by usama farooq on 08/07/2023.
//

import Foundation

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
    let movie: MovieProtocol
    
    init(router: MovieDetailRouter, movie: MovieProtocol) {
        self.router = router
        self.movie = movie
    }
    
    func viewModelDidLoad() {
        send(.reload)
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
    }
}
