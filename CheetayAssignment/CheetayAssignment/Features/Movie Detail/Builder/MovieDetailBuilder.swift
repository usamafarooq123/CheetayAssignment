//  
//  MovieDetailBuilder.swift
//  CheetayAssignment
//
//  Created by usama farooq on 08/07/2023.
//

import Foundation
import UIKit

class MovieDetailBuilder {

    func build(with navigationController: UINavigationController?, movie: MovieProtocol) -> UIViewController {
        
        let storyboard = UIStoryboard(name: "MovieDetail", bundle: Bundle(for: MovieDetailBuilder.self))
        let viewController = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        let coordinator = MovieDetailRouter(navigationController: navigationController)
        let viewModel = MovieDetailViewModelImpl(router: coordinator, movie: movie)

        viewController.viewModel = viewModel
        
        return viewController
    }
}


