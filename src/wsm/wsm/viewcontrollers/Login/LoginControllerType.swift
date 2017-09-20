//
//  LoginControllerType.swift
//  wsm
//
//  Created by nguyen.van.hung on 9/18/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import UIKit

protocol LoginControllerType {
    func didLogin(with user: User?)
}

extension LoginControllerType where Self: UIViewController {
    func login(with email: String, password: String) {
        AlertHelper.showLoading()
        LoginProvider.login(with: email, password: password).on(failed: { (error) in
            AlertHelper.hideLoading()
            AlertHelper.showError(message: error.message)
        }, completed: {
            AlertHelper.hideLoading()
        }, value: { (user) in
            self.didLogin(with: user)
        }).start()
    }
    func getProfile(userId: Int) {
        AlertHelper.showLoading()
        UserProvider.getProfile(userId: userId).on(failed: { (error) in
            AlertHelper.hideLoading()
            AlertHelper.showError(message: error.message)
        }, completed: {
            AlertHelper.hideLoading()
        }, value: { (profile) in
            print(profile.email ?? "error")
        }).start()
    }
}
