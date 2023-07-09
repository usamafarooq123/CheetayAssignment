//  
//  favouriteMoviesBuilder.swift
//  CheetayAssignment
//
//  Created by usama farooq on 09/07/2023.
//

import Foundation
import UIKit

class FavouriteMoviesBuilder {

    func build(with navigationController: UINavigationController?, coreDataManager: CoreDataManager) -> UIViewController {
        
        let storyboard = UIStoryboard(name: "FavouriteMovies", bundle: Bundle(for: FavouriteMoviesBuilder.self))
        let viewController = storyboard.instantiateViewController(withIdentifier: "FavouriteMoviesViewController") as! FavouriteMoviesViewController
        let coordinator = FavouriteMoviesRouter(navigationController: navigationController)
        let viewModel = FavouriteMoviesViewModelImpl(router: coordinator, coreDataManager: coreDataManager)

        viewController.viewModel = viewModel
        
        return viewController
    }
}


