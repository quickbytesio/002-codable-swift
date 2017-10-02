//
//  AppDelegate.swift
//  Quickbytes Example Swift
//
//  Created by Aaron Brethorst on 9/25/17.
//  Copyright © 2017 Quickbytes. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let window = UIWindow.init(frame: UIScreen.main.bounds)
    let viewController = ViewController.init(nibName: nil, bundle: nil)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        let navigation = UINavigationController(rootViewController: self.viewController);
        self.window.rootViewController = navigation

        self.window.makeKeyAndVisible()

        return true
    }
}
