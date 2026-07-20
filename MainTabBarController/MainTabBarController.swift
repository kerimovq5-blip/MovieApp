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
        lazy var controller = ViewController()
        controller.tabBarItem.title = "Home"
        
        controller.tabBarItem.image = UIImage(systemName: "house")
        controller.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        
        return controller
    }
    func searchViewController() -> UIViewController {
        lazy var controller = SearchViewController()
        controller.tabBarItem.title = "Search"
        controller.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        controller.navigationController?.navigationBar.isHidden = true
        return controller
    }
    func whatchListController() -> UIViewController {
        lazy var controller = WatchListController()
        controller.tabBarItem.title = "Watchlist"
        controller.tabBarItem.image = UIImage(named: "Bookmark")
        controller.tabBarItem.selectedImage = UIImage(systemName: "rectangle.stack.person.crop.circle.fill")
        return controller
    }

            
    }

