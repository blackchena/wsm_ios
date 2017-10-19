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
import SwiftyUserDefaults
import Fabric
import Crashlytics

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

        LocalizationHelper.shared.addSupportedLanguage(AppConstant.supportLanguages)
        if let langCode = Locale.current.languageCode,
            AppConstant.supportLanguages.contains(langCode) {
            LocalizationHelper.shared.setCurrentLanguage(langCode)
        } else {
            LocalizationHelper.shared.setCurrentLanguage(AppConstant.defaultLanguage)
        }

        AppDelegate.initRootView()
        
        Fabric.with([Crashlytics.self])

        return true
    }
    
    static func initRootView() {
        if UserServices.isAlreadyLogin {
            showHomePage()
        }
        else {
            showLoginPage()
        }
    }

    static func showHomePage() {
        let navigationController = UIViewController.getStoryboardController(identifier: "NavigationController")
        let mainViewController = UIViewController.getStoryboardController(identifier: "MainViewController")
        let timeSheetVc = UIViewController.getStoryboardController(identifier: "TimeSheetViewController")
        
        guard let mainNav = navigationController as? NavigationController else {
            return
        }
        
        mainNav.setViewControllers([timeSheetVc], animated: false)
        
        guard let mainVc = mainViewController as? MainViewController else {
            return
        }
        
        mainVc.rootViewController = mainNav
        
        if let window = UIApplication.shared.delegate?.window {
            window!.rootViewController = mainViewController
            UIView.transition(with: window!,
                              duration: 0.3,
                              options: [.transitionCrossDissolve],
                              animations: nil, completion: nil)
        }
    }
    
    static func showLoginPage() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = mainStoryboard.instantiateInitialViewController()
        
        if let window = UIApplication.shared.delegate?.window {
            window!.rootViewController = loginViewController
            UIView.transition(with: window!,
                              duration: 0.3,
                              options: [.transitionCrossDissolve],
                              animations: nil, completion: nil)
        }
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
