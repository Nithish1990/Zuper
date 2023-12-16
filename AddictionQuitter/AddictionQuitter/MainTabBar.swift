//
//  MainTabBar.swift
//  AddictionQuitter
//
//  Created by nithish-17632 on 16/12/23.
//

import UIKit

class MainTabBar: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let homeVc = HomeViewController()
        homeVc.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        let homeNav = UINavigationController(rootViewController: homeVc)
        
        let groupFollowVC = HomeViewController()
        groupFollowVC.tabBarItem = UITabBarItem(title: "Groups", image: UIImage(systemName: "person.3"), selectedImage: UIImage(systemName: "person.3.fill"))
        let groupFollowNav = UINavigationController(rootViewController: groupFollowVC)
        
        
        let profile = HomeViewController()
        profile.tabBarItem = UITabBarItem(title: "Profile", image:   UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        
        let profileNav = UINavigationController(rootViewController: profile)
        let searchVC = HomeViewController()
        let searchNav = UINavigationController(rootViewController: searchVC)
        searchVC.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass.fill"))

        self.setViewControllers([searchNav,homeNav,groupFollowNav,profileNav], animated: true)
        
        
        self.selectedIndex = 1
        
        self.tabBar.barTintColor = .systemBackground
        self.tabBar.tintColor = UIColor(AQColors.mainButtonColor)
    }
}
