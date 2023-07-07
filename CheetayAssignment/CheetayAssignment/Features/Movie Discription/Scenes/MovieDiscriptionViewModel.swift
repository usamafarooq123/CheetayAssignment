//  
//  MovieDiscriptionViewModel.swift
//  CheetayAssignment
//
//  Created by usama farooq on 07/07/2023.
//

import Foundation

typealias MovieDiscriptionViewModelOutput = (MovieDiscriptionViewModelImpl.Output) -> Void

protocol MovieDiscriptionViewModelInput {
    
}

protocol MovieDiscriptionViewModel: MovieDiscriptionViewModelInput {
    var output: MovieDiscriptionViewModelOutput? { get set}
    
    func viewModelDidLoad()
    func viewModelWillAppear()
}

class MovieDiscriptionViewModelImpl: MovieDiscriptionViewModel, MovieDiscriptionViewModelInput {

    private let router: MovieDiscriptionRouter
    var output: MovieDiscriptionViewModelOutput?
    
    init(router: MovieDiscriptionRouter) {
        self.router = router
    }
    
    func viewModelDidLoad() {
        
    }
    
    func viewModelWillAppear() {
        
    }
    
    //For all of your viewBindings
    enum Output {
        
    }
}

extension MovieDiscriptionViewModelImpl {

}
