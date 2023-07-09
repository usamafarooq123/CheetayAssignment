//
//  TabbarController.swift
//  CheetayAssignment
//
//  Created by usama farooq on 09/07/2023.
//

import Foundation
import UIKit

class TabbarController: UITabBarController {
    
    let moviesNC = UINavigationController()
    let favouriteNC  = UINavigationController()
    let coreDataManager = CoreDataManager(coreDataStack: CoreDataStack())
    let dataStore = MoviesDataStore(service: NetworkService())
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabbar()
    }
    
    func configureTabbar() {
        self.delegate = self
        self.tabBar.backgroundColor = .white
        
        let moviesModule = MoviesBuilder().build(with: moviesNC, dataStore: dataStore, coreDataManager: coreDataManager)
        moviesNC.setViewControllers([moviesModule], animated: false)
    
        
        moviesNC.tabBarItem = UITabBarItem(title: "Movies", image: UIImage(systemName: "video"), selectedImage:UIImage(systemName: "video.fill"))
        
        
        let favouriteMoviesModule = FavouriteMoviesBuilder().build(with: favouriteNC, coreDataManager: coreDataManager)
        favouriteNC.setViewControllers([favouriteMoviesModule], animated: false)
        
        favouriteNC.tabBarItem = UITabBarItem(title: "Movies", image: UIImage(systemName: "heart"), selectedImage:UIImage(systemName: "heart.fill"))
        
        let tabBarList = [moviesNC,favouriteNC]
        
        viewControllers = tabBarList
        self.selectedIndex = 0

    }
    
    private func getImage(_ name: String) -> UIImage {
        let image = UIImage(named: name, in: nil, compatibleWith: nil)?.withRenderingMode(.alwaysOriginal)
        return image ?? UIImage()
    }
}

extension TabbarController: UITabBarControllerDelegate {
    
}
