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
        let navigationController = UINavigationController()
        let module = MoviesBuilder().build(with: navigationController)
        navigationController.setViewControllers([module], animated: false)
        navigationController.setNavigationBarHidden(true, animated: false)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
