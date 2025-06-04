//
//  TabBarController.swift
//  NewsApp
//
//  Created by Юлия Дегтярева on 2025-05-11.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.tintColor = .black
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        viewControllers = [
            setupNavigationController(rootViewController: GeneralViewController(viewModel: GeneralViewModel()),
                                      title: "General",
                                      imageName:  "newspaper"),
            setupNavigationController(rootViewController: BusinessViewController(),
                                      title: "Business",
                                      imageName: "briefcase"),
            setupNavigationController(rootViewController: TechnologyViewController(),
                                      title: "Technology",
                                      imageName: "gyroscope")
            
        ]
    }
    
    private func setupNavigationController(rootViewController: UIViewController,
                                           title: String,
                                           imageName: String) -> UINavigationController
    {
        
        let navigationController = UINavigationController(rootViewController: rootViewController)
        
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = UIImage(systemName: imageName)
        rootViewController.navigationItem.title = title
        navigationController.navigationBar.prefersLargeTitles = true
        
        return navigationController
    }
    
    private func setupTabBar() {
        let apperance = UITabBarAppearance()
        apperance.configureWithOpaqueBackground()
        tabBar.scrollEdgeAppearance = apperance
        
        view.tintColor = .black
    }
}
