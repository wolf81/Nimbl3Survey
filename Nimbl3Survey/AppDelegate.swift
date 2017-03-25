//
//  AppDelegate.swift
//  Nimbl3Survey
//
//  Created by Wolfgang Schreurs on 22/03/2017.
//  Copyright © 2017 Wolftrail. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let viewController = SurveysViewController(transitionStyle: .scroll, navigationOrientation: .vertical)
        let navController = UINavigationController(rootViewController: viewController)
        self.window?.rootViewController = navController
        
        self.window?.makeKeyAndVisible()
        
        configureAppearance()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - Private
    
    private func configureAppearance() {
        UINavigationBar.appearance().barTintColor = AppTheme.backgroundColor
        UINavigationBar.appearance().tintColor = AppTheme.foregroundColor
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: AppTheme.foregroundColor]
        UILabel.appearance().backgroundColor = .clear
        
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().backgroundColor = AppTheme.backgroundColor.withAlphaComponent(0.5)
        UINavigationBar.appearance().isTranslucent = true
    }
}

