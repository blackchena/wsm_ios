//
//  AppDelegate.swift
//  wsm
//
//  Created by nguyen.van.hung on 9/18/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import InAppLocalize
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        //Change background color of SVProgressHUD dialog
        SVProgressHUD.setDefaultMaskType(.black)
        UINavigationBar.appearance().barTintColor = UIColor.appBarTintColor
        UINavigationBar.appearance().tintColor = UIColor.appTintColor
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.appTintColor]

        LocalizationHelper.shared.addSupportedLanguage(["vi", "en"])
        if let langCode = Locale.current.languageCode {
            LocalizationHelper.shared.setCurrentLanguage(langCode)
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
}
