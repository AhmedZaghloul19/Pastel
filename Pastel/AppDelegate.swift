//
//  AppDelegate.swift
//  Pastel
//
//  Created by Ahmed Zaghloul on 6/28/19.
//  Copyright © 2019 Ahmed Zaghloul. All rights reserved.
//

import UIKit
import Kingfisher

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if let rootTabBarVC = self.window?.rootViewController as? UITabBarController {
            if let firstNav = rootTabBarVC.viewControllers?.first as? UINavigationController, let secondNav = rootTabBarVC.viewControllers?[1] as? UINavigationController{
                if let groupsVC = firstNav.viewControllers.first as? GroupsVC, let photosVC = secondNav.viewControllers.first as? PhotosVC {
                    groupsVC.presenter = GroupsPresenter()
                    photosVC.presenter = PhotosPresenter()
                }
            }
        }
        
        
        return true
    }
}

