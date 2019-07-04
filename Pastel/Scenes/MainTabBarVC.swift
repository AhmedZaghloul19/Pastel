//
//  MainTabBarVC.swift
//  Pastel
//
//  Created by Ahmed Zaghloul on 6/29/19.
//  Copyright © 2019 Ahmed Zaghloul. All rights reserved.
//

import UIKit

class MainTabBarVC: UITabBarController{

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let navVC = viewControllers![0] as? UINavigationController, let vc = navVC.viewControllers.first as? GroupsVC {
            vc.searchController.isActive = false
        }
        if let navVC = viewControllers![1] as? UINavigationController, let vc = navVC.viewControllers.first as? PhotosVC {
            vc.searchController.isActive = false
        }
    }

}
