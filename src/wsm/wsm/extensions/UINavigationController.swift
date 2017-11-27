//
//  UINavigationController.swift
//  wsm
//
//  Created by Thanh Nguyen Xuan on 11/27/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation

extension UINavigationController {

    func popViewController(animated: Bool, completion: (() -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        popViewController(animated: animated)
        CATransaction.commit()
    }

}
