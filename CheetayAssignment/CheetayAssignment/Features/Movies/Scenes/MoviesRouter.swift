//  
//  MoviesRouter.swift
//  CheetayAssignment
//
//  Created by usama farooq on 07/07/2023.
//

import Foundation
import UIKit

class MoviesRouter {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
}

extension MoviesRouter {
    func routeToDetail(with movie: MovieProtocol, coreDataManger: CoreDataManager, delegate: MovieDetailDelegate) {
        let module = MovieDetailBuilder().build(with: navigationController, movie: movie, coreDataManager: coreDataManger, delegate: delegate)
        navigationController?.pushViewController(module, animated: true)
    }
}
