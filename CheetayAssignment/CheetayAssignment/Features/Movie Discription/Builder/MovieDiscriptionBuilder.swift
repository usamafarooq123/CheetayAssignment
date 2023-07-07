//  
//  MovieDiscriptionBuilder.swift
//  CheetayAssignment
//
//  Created by usama farooq on 07/07/2023.
//

import Foundation
import UIKit

class MovieDiscriptionBuilder {

    func build(with navigationController: UINavigationController?) -> UIViewController {
        
        let storyboard = UIStoryboard(name: "MovieDiscription", bundle: Bundle(for: MovieDiscriptionBuilder.self))
        let viewController = storyboard.instantiateViewController(withIdentifier: "MovieDiscriptionViewController") as! MovieDiscriptionViewController
        let coordinator = MovieDiscriptionRouter(navigationController: navigationController)
        let viewModel = MovieDiscriptionViewModelImpl(router: coordinator)

        viewController.viewModel = viewModel
        
        return viewController
    }
}


