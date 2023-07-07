//  
//  MoviesBuilder.swift
//  CheetayAssignment
//
//  Created by usama farooq on 07/07/2023.
//

import Foundation
import UIKit

class MoviesBuilder {

    func build(with navigationController: UINavigationController?) -> UIViewController {
        
        let storyboard = UIStoryboard(name: "Movies", bundle: Bundle(for: MoviesBuilder.self))
        let viewController = storyboard.instantiateViewController(withIdentifier: "MoviesViewController") as! MoviesViewController
        let coordinator = MoviesRouter(navigationController: navigationController)
        let viewModel = MoviesViewModelImpl(router: coordinator)

        viewController.viewModel = viewModel
        
        return viewController
    }
}


