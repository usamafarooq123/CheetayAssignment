//  
//  favouriteMoviesRouter.swift
//  CheetayAssignment
//
//  Created by usama farooq on 09/07/2023.
//

import Foundation
import UIKit

class FavouriteMoviesRouter {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
}

extension FavouriteMoviesRouter {
    func routeToDetail(with movie: MovieProtocol, coreDataManger: CoreDataManager, delegate: MovieDetailDelegate) {
        let module = MovieDetailBuilder().build(with: navigationController, movie: movie, coreDataManager: coreDataManger, delegate: delegate)
        navigationController?.pushViewController(module, animated: true)
    }
}
