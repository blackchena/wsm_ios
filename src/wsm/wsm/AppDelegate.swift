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
        let navigationController = getViewController(identifier: "NavigationController")
        let mainViewController = getViewController(identifier: "MainViewController")
        let timeSheetVc = getViewController(identifier: "TimeSheetViewController")
        
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
        if #available(iOS 10, *) {
        } else {
            handleNotification(with: userInfo)
        }
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

    func handleNotification(with userInfo: [AnyHashable: Any]) {
        guard let jsonData = userInfo as? [String: Any],
              let aps = jsonData["aps"] as? [String: Any],
              let badge = aps["badge"] as? Int else {
            return
        }
        let localNotificationData = UserServices.getLocalNotificationData()
        localNotificationData?.unreadCount = badge
        UserServices.saveNotificationData(notifications: localNotificationData)
        NotificationProvider.shared.badgeValue = "\(badge)"
        let application = UIApplication.shared
        guard application.applicationState == .inactive || application.applicationState == .background,
              let permissionString = jsonData["permission"] as? String,
              let permission = RemoteNotificationPermission(rawValue: permissionString),
              UserServices.getAuthToken() != nil,
              let mainViewController = application.keyWindow?.rootViewController as? MainViewController,
              let navigationController = mainViewController.rootViewController as? UINavigationController,
              let notificationIdString = jsonData["notification_id"] as? String,
              let notificationId = Int(notificationIdString) else {
            NotificationCenter.default.post(name: NotificationName.reloadNotifications, object: nil)
            return
        }
        let nextViewController: UIViewController
        switch permission {
        case .requestOt:
            nextViewController = getViewController(identifier: "ListRequestOtViewController")
        case .requestLeave:
            nextViewController = getViewController(identifier: "ListReuqestLeaveViewController")
        case .requestOff:
            nextViewController = getViewController(identifier: "ListRequestOffViewController")
        case .manageRequestOt:
            // TODO: Handle manager's notification later
            nextViewController = getViewController(identifier: "TimeSheetViewController")
            break
        case .manageRequestLeave:
            // TODO: Handle manager's notification later
            nextViewController = getViewController(identifier: "TimeSheetViewController")
            break
        case .manageRequestOff:
            // TODO: Handle manager's notification later
            nextViewController = getViewController(identifier: "TimeSheetViewController")
            break
        }
        NotificationProvider.readSingleNotification(id: notificationId)
            .then { response -> Void in
                if !response.isSucceeded() {
                    return
                }
                NotificationProvider.shared.badgeValue = "\(badge - 1)"
                localNotificationData?.unreadCount = badge - 1
                UserServices.saveNotificationData(notifications: localNotificationData)
            }.always {
                navigationController.replaceRootViewController(by: nextViewController)
                navigationController.popToRootViewController(animated: false)
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
        handleNotification(with: response.notification.request.content.userInfo)
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                -> Void) {
        handleNotification(with: notification.request.content.userInfo)
        completionHandler([])
    }

}
