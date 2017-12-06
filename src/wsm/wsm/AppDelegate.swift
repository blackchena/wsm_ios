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
import Firebase
import UserNotifications

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
        registerForRemoteNotifications(application)
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        if let fcmToken = UserServices.getFCMToken() {
            updateDeviceTokenIfNeeded(fcmToken)
        }
        return true
    }

    static func initRootView() {
        if UserServices.isAlreadyLogin {
            showHomePage()
        }
        else {
            showLoginPageIfNeeded()
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

    static func showLoginPageIfNeeded() {
        if UIViewController.getTopViewController() is LoginViewController {
            return
        }
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

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // TODO: Handle notification data
        completionHandler(.newData)
    }

    private func registerForRemoteNotifications(_ application: UIApplication) {
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { _, _ in })
        } else {
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
    }

    func updateDeviceTokenIfNeeded(_ fcmToken: String) {
        if UserServices.getAuthToken() == nil {
            UserServices.saveFCMToken(fcmToken)
            return
        }
        LoginProvider.updateDeviceToken(fcmToken)
            .then { response -> Void in
                if !response.isSucceeded() {
                    UserServices.saveFCMToken(fcmToken)
                    return
                }
                UserServices.saveFCMToken(nil)
            }
            .catch { _ in
                UserServices.saveFCMToken(fcmToken)
            }
    }

}

// MARK: - MessagingDelegate

extension AppDelegate: MessagingDelegate {

    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        updateDeviceTokenIfNeeded(fcmToken)
    }

}

// MARK: - UNUserNotificationCenterDelegate

@available(iOS 10.0, *)
extension AppDelegate: UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        // TODO: Handle notification data
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                -> Void) {
        // TODO: Handle notification data
        completionHandler([])
    }

}
