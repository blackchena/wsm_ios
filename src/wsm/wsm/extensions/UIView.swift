//
//  UIView.swift
//  wsm
//
//  Created by Lê Thanh Quang on 10/12/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import PromiseKit

extension UIView {

    public class func animateBlockOperation(animateWithDuration duration: TimeInterval,
                                delay: TimeInterval = 0,
                                options: UIViewAnimationOptions = [],
                                animations: @escaping () -> Void,
                                finish:  @escaping () -> Void,
                                completedAnim:  (() -> Void)?) -> BlockOperation {


        let operation = BlockOperation.init(block: {
            animate(withDuration: duration, delay: delay, options: options, animations: animations, completion: { b in
                if b == true {
                    finish()
                }

                completedAnim?()
            })
        })
        return operation
    }
}
