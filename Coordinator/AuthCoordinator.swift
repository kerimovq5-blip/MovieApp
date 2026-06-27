//
//  AuthCoordinator.swift
//  MovieApp
//
//  Created by Kerimov Qehreman on 27.06.26.
//
import UIKit

final class AuthCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
        
    }
}
