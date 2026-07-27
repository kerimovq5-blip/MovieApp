//
//  TabbarController.swift
//  ControlProject
//
//  Created by Kerimov Qehreman on 29.05.26.
//

import UIKit

final class TabbarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        
        viewControllers = [
            homeviewcontroller(),
            searchNavigation(),
            watchlistNavigation()
        ]
            
        }
    func homeviewcontroller() -> UIViewController {
        let controller = ViewController()
        controller.tabBarItem.title = "Home"
        
        controller.tabBarItem.image = UIImage(systemName: "house")?.withRenderingMode(.alwaysTemplate)
        controller.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        
        return controller
    }
    private func searchNavigation() -> UIViewController {
        let controller = SearchViewController()
        let navigation = UINavigationController(rootViewController: controller)
        navigation.tabBarItem.title = "Search"
        navigation.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        navigation.navigationBar.isHidden = true
        return navigation
    }

    private func watchlistNavigation() -> UIViewController {
        let controller = WatchListController()
        let navigation = UINavigationController(rootViewController: controller)
        navigation.tabBarItem.title = "Watch list"
        navigation.tabBarItem.image = UIImage(named: "Bookmark")?
            .withRenderingMode(.alwaysTemplate)
        return navigation
    }
            
    }


