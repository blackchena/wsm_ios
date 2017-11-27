//
//  UINavigationController.swift
//  wsm
//
//  Created by Thanh Nguyen Xuan on 11/27/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation

extension UINavigationController {

    func replaceRootViewController(by viewController: UIViewController) {
        viewControllers.removeFirst()
        viewController.view.layoutSubviews()
        viewControllers.insert(viewController, at: 0)
    }

}
