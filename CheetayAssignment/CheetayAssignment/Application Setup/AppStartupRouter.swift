//
//  AppStartupRouter.swift
//  CheetayAssignment
//
//  Created by usama farooq on 07/07/2023.
//

import Foundation
import UIKit

class AppStartupRouter {
    func route(into window: UIWindow?) {
        let coreDataManager = CoreDataManager(coreDataStack: CoreDataStack())
        let dataStore = MoviesDataStore(service: NetworkService())
        
        let navigationController = UINavigationController()
        let module = MoviesBuilder().build(with: navigationController, dataStore: dataStore, coreDataManager: coreDataManager)
        
        navigationController.setViewControllers([module], animated: false)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
