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
}

class MoviesViewModelImpl: MoviesViewModel, MoviesViewModelInput {

    private let router: MoviesRouter
    var output: MoviesViewModelOutput?
    
    init(router: MoviesRouter) {
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

extension MoviesViewModelImpl {

}
