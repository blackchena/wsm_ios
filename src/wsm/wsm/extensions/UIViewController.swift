//
//  UIViewController.swift
//  wsm
//
//  Created by framgia on 9/21/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation

extension UIViewController {
    open static func getStoryboardController(storyboardName: String = "Main", identifier: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
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
