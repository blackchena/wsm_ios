//
//  UIViewController.swift
//  wsm
//
//  Created by framgia on 9/21/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation

extension UIViewController {

    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }

    static func getTopViewController() -> UIViewController? {
        if let rootController = UIApplication.shared.delegate?.window??.rootViewController {
            if let presentedController = rootController.presentedViewController as? UINavigationController {
                if let controller = presentedController.viewControllers.last {
                    return controller
                }
            } else if let presentedController = rootController.presentedViewController {
                if let topMostPresentedController = presentedController.presentedViewController {
                    return topMostPresentedController
                } else {
                    return presentedController
                }
            } else {
                return rootController
            }
        }

        return nil
    }
}
