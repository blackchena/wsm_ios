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
import PromiseKit

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

    /**
     * Show error with message is "localizedDescription" property of "error" parameter
     * Before show message will check the param makesureLoadingHidden if true -> call AlertHelper.hideLoading()
     */
    class func showError(error: Error?, makesureLoadingHidden: Bool = true) {
        showError(message: error?.localizedDescription, makesureLoadingHidden: makesureLoadingHidden)
    }

    /**
     * Show error with message is "localizedDescription" property of "error" parameter
     * Before show message will check the param makesureLoadingHidden if true -> call AlertHelper.hideLoading()
     * withDelayInMilliseconds: will delay call the fulfill of this Promise, default is 0.5s
     */
    class func showErrorWithPromise(error: Error?, makesureLoadingHidden: Bool = true, withDelayInMilliseconds: Int = 500) -> Promise<Void> {
        return showErrorWithPromise(message: error?.localizedDescription, makesureLoadingHidden: makesureLoadingHidden, withDelayInMilliseconds: withDelayInMilliseconds)
    }

    /**
     * Show error with "message" parameter
     * Before show message will check the param makesureLoadingHidden if true -> call AlertHelper.hideLoading()
     */
    class func showError(message: String?, makesureLoadingHidden: Bool = true) {

        if makesureLoadingHidden {
            hideLoading()
        }

        let alertController = UIAlertController(title: LocalizationHelper.shared.localized("app_name"), message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: LocalizationHelper.shared.localized("close"),
                                                style: .default,
                                                handler: nil))
        UIViewController.getTopViewController()?.present(alertController, animated: true, completion: nil)
    }

    /**
     * Show error with "message" parameter
     * Before show message will check the param makesureLoadingHidden if true -> call AlertHelper.hideLoading()
     * withDelayInMilliseconds will delay call the fulfill of this Promise, default is 0.5s
     */
    class func showErrorWithPromise(message: String?, makesureLoadingHidden: Bool = true, withDelayInMilliseconds: Int = 500) -> Promise<Void> {

        return Promise<Void> { fulfill, _ in
            if makesureLoadingHidden {
                hideLoading()
            }

            let alertController = UIAlertController(title: LocalizationHelper.shared.localized("app_name"), message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: LocalizationHelper.shared.localized("close"),
                                                    style: .default,
                                                    handler: nil))
            UIViewController.getTopViewController()?.present(alertController, animated: true, completion: nil)

            let when = DispatchTime.now() + DispatchTimeInterval.milliseconds(withDelayInMilliseconds)
            DispatchQueue.main.asyncAfter(deadline: when, execute: {
                fulfill()
            })
        }
    }

    /**
     * Show message dialog
     * Before show message will check the param makesureLoadingHidden if true -> call AlertHelper.hideLoading()
     */
    class func showInfo(message: String?, makesureLoadingHidden: Bool = true, handler: ((UIAlertAction) -> Swift.Void)? = nil) {

        if makesureLoadingHidden {
            hideLoading()
        }
        let alertController = UIAlertController(title: LocalizationHelper.shared.localized("app_name"), message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: LocalizationHelper.shared.localized("close"),
                                                style: .default,
                                                handler: handler))

        UIViewController.getTopViewController()?.present(alertController, animated: true, completion: nil)
    }

    class func showConfirm(message: String?, makesureLoadingHidden: Bool = true, handler: ((UIAlertAction) -> Swift.Void)? = nil) {

        if makesureLoadingHidden {
            hideLoading()
        }
        let alertController = UIAlertController(title: LocalizationHelper.shared.localized("app_name"),
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: LocalizationHelper.shared.localized("disagree"),
                                                style: .default,
                                                handler: nil))
        alertController.addAction(UIAlertAction(title: LocalizationHelper.shared.localized("agree"),
                                                style: .default,
                                                handler: handler))

        UIViewController.getTopViewController()?.present(alertController, animated: true, completion: nil)
    }

    /**
     * Show message dialog
     * Before show message will check the param makesureLoadingHidden if true -> call AlertHelper.hideLoading()
     */
    class func showInfoWithPromise(message: String?, makesureLoadingHidden: Bool = true) -> Promise<Void> {

        return Promise<Void> { fulfill, _ in
            if makesureLoadingHidden {
                hideLoading()
            }

            let alertController = UIAlertController(title: "wsm", message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: LocalizationHelper.shared.localized("CLOSE"),
                                                    style: .default,
                                                    handler: { _ in fulfill() }))

            UIViewController.getTopViewController()?.present(alertController, animated: true, completion: nil)
        }
        
    }
}
