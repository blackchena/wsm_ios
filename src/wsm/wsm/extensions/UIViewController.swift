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
}
