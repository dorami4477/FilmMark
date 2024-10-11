//
//  TabBarController.swift
//  FilmMark
//
//  Created by 박다현 on 10/11/24.
//

import Foundation

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        
        tabBar.tintColor = Colors.primaryColor
        
        let home = UINavigationController(rootViewController: HomeViewController())
        home.tabBarItem = UITabBarItem(title: "Home", image: Icons.home, tag: 0)
        
        let search = UINavigationController(rootViewController: SearchViewController())
        search.tabBarItem = UITabBarItem(title: "Top Search", image: Icons.search, tag: 1)
        
        let download = UINavigationController(rootViewController: MyFilmViewController())
        download.tabBarItem = UITabBarItem(title: "Download", image: Icons.down, tag: 2)
        
        setViewControllers([home, search, download], animated: true)
    }
}
