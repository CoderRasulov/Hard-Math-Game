//
//  AppDelegate.swift
//  Hard Math Game
//
//  Created by Asliddin Rasulov on 3/2/20.
//  Copyright © 2020 Asliddin Rasulov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UserDefaults.standard.set(true, forKey: "voice")
        UserDefaults.standard.set(true, forKey: "showTimer")
        // Override point for customization after application launch.
        return true
    }
}

