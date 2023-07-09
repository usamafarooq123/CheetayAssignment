//
//  AppStartupRouter.swift
//  CheetayAssignment
//
//  Created by usama farooq on 07/07/2023.
//

import Foundation
import UIKit

/**
The AppStartupRouter class is responsible for setting up the initial view hierarchy of the application upon app startup.

Use this class to configure the root view controller of the app's main window. In this implementation, the AppStartupRouter sets the root view controller to a TabbarController, which represents the main tab bar interface of the application.
*/

final class AppStartupRouter {
    func route(into window: UIWindow?) {
        window!.rootViewController = TabbarController()
        window!.makeKeyAndVisible()
    }
}
