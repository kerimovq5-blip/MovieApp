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
            searchViewController(),
            whatchListController()
        ]
            
        }
    func homeviewcontroller() -> UIViewController {
        let controller = ViewController()
        controller.tabBarItem.title = "Home"
        
        controller.tabBarItem.image = UIImage(systemName: "house")?.withRenderingMode(.alwaysTemplate)
        controller.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        
        return controller
    }
    func searchViewController() -> UIViewController {
        let controller = SearchViewController()
        controller.tabBarItem.title = "Search"
        controller.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        controller.navigationController?.navigationBar.isHidden = true
        return controller
    }
    func whatchListController() -> UIViewController {
        let controller = WatchListController()
        controller.tabBarItem.title = "Watchlist"
        controller.tabBarItem.image = UIImage(named: "Bookmark")?
            .withRenderingMode(.alwaysTemplate)
        return controller
    }

            
    }

