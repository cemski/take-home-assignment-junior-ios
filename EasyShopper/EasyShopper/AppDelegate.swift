//
//  AppDelegate.swift
//  EasyShopper
//
//  Created by Cem Lapovski on 2020-06-30.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = CheckoutViewController()
        window?.makeKeyAndVisible()
        
        return true
    }

}
