//
//  HomeViewController.swift
//  wsm
//
//  Created by nguyen.van.hung on 9/18/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import LGSideMenuController

class MainViewController: LGSideMenuController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let leftMenuVc = storyboard.instantiateViewController(withIdentifier: "LeftMenuViewController")
        guard let leftMenu = leftMenuVc as? LeftMenuViewController else {
            return
        }
        leftViewController = leftMenu
        leftViewWidth = 270.0
        leftViewBackgroundImage = UIImage(named: "imageLeft")
        leftViewPresentationStyle = .slideAbove
        isLeftViewStatusBarHidden = false

        if let notificationData = UserServices.getLocalNotificationData() {
            NotificationProvider.shared.listNotifications = notificationData.listNotifications
            if let badge = notificationData.unreadCount {
                NotificationProvider.shared.badgeValue = "\(badge)"
            }
        }

    }
    override func leftViewWillLayoutSubviews(with size: CGSize) {
        super.leftViewWillLayoutSubviews(with: size)
        if !isLeftViewStatusBarHidden {
            leftView?.frame = CGRect(x: 0.0, y: 20.0, width: size.width, height: size.height - 20.0)
        }
    }
    deinit {
        print("MainViewController deinitialized")
    }
}
