//
//  AlertHelper.swift
//  wsm
//
//  Created by Nguyen Hung on 8/26/17.
//  Copyright © 2017 nguyen.van.hung. All rights reserved.
//

import UIKit
import SVProgressHUD
import InAppLocalize

final class AlertHelper {
    class func showLoading() {
        if Thread.current.isMainThread {
            SVProgressHUD.show()
        } else {
            DispatchQueue.main.async {
                SVProgressHUD.show()
            }
        }
    }

    class func hideLoading() {
        if Thread.current.isMainThread {
            SVProgressHUD.dismiss()
        } else {
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }
        }
    }

    class func showError(error: Error?) {
        showError(message: error?.localizedDescription)
    }

    class func showError(message: String?) {
        if let rootController = UIApplication.shared.delegate?.window??.rootViewController {
            let alertController = UIAlertController(title: "wsm", message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: LocalizationHelper.shared.localized("CLOSE"),
                                                    style: .default,
                                                    handler: nil))
            if let presentedController = rootController.presentedViewController as? UINavigationController {
                if let controller = presentedController.viewControllers.last {
                    controller.present(alertController, animated: true, completion: nil)
                }
            } else if let presentedController = rootController.presentedViewController {
                if let topMostPresentedController = presentedController.presentedViewController {
                    topMostPresentedController.present(alertController, animated: true, completion: nil)
                } else {
                    presentedController.present(alertController, animated: true, completion: nil)
                }
            } else {
                rootController.present(alertController, animated: true, completion: nil)
            }
        }
    }

    class func showInfo(message: String?, handler: ((UIAlertAction) -> Swift.Void)? = nil) {
        if let rootController = UIApplication.shared.delegate?.window??.rootViewController {
            let alertController = UIAlertController(title: "wsm", message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: LocalizationHelper.shared.localized("CLOSE"),
                                                    style: .default,
                                                    handler: handler))
            if let presentedController = rootController.presentedViewController as? UINavigationController {
                if let controller = presentedController.viewControllers.last {
                    controller.present(alertController, animated: true, completion: nil)
                }
            } else if let presentedController = rootController.presentedViewController {
                if let topMostPresentedController = presentedController.presentedViewController {
                    topMostPresentedController.present(alertController, animated: true, completion: nil)
                } else {
                    presentedController.present(alertController, animated: true, completion: nil)
                }
            } else {
                rootController.present(alertController, animated: true, completion: nil)
            }
        }
    }
}
