//
//  BaseViewController.swift
//  wsm
//
//  Created by nguyen.van.hung on 9/18/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import UIKit
import LGSideMenuController
import InAppLocalize
import BBBadgeBarButtonItem

class BaseViewController: UIViewController {

    private var rightBarButton: BBBadgeBarButtonItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()

        let menuImage = UIImage(named: "ic_menu_nav")
        let tintedMenuImage = menuImage?.withRenderingMode(.alwaysTemplate)
        let leftButton = UIButton(type: .custom)
        leftButton.setImage(tintedMenuImage, for: .normal)
        leftButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        leftButton.addTarget(self, action: #selector(self.showLeftMenu), for: .touchUpInside)
        leftButton.tintColor = UIColor.appTintColor
        let leftBarButton = UIBarButtonItem(customView: leftButton)
        navigationItem.leftBarButtonItem = leftBarButton

        let notificationImage = UIImage(named: "ic_notifications")
        let tintedNotificationImage = notificationImage?.withRenderingMode(.alwaysTemplate)
        let rightButton = UIButton(type: .custom)
        rightButton.setImage(tintedNotificationImage, for: .normal)
        rightButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        rightButton.addTarget(self, action: #selector(self.showNotification), for: .touchUpInside)
        rightButton.tintColor = UIColor.appTintColor
        rightBarButton = BBBadgeBarButtonItem(customUIButton: rightButton)
        rightBarButton?.badgeOriginX = 15
        rightBarButton?.badgeOriginY = -7
        navigationItem.rightBarButtonItem = rightBarButton

        if let title = self.title {
            self.title = LocalizationHelper.shared.localized(title)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let badgeValue = NotificationProvider.shared.badgeValue {
            rightBarButton?.badgeValue = badgeValue
        }
    }

    @objc private func showLeftMenu() {
        sideMenuController?.showLeftView(animated: true, delay: 0.0, completionHandler: nil)
    }

    @objc private func showNotification() {
        if let vc = getViewController(identifier: "NotificationViewController") as? NotificationViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
