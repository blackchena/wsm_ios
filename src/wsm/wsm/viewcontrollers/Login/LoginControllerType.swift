//
//  LoginControllerType.swift
//  wsm
//
//  Created by nguyen.van.hung on 9/18/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import UIKit
import SwiftyUserDefaults

protocol LoginControllerType {
    func didLogin(with loginResult: LoginModel?)
}

extension LoginControllerType where Self: UIViewController {
    func login(with email: String, password: String) {

        AlertHelper.showLoading()

        //reset authToken
        Defaults[.authToken] = nil

        LoginProvider.login(email, password)
            .then { loginResult in
                self.didLogin(with: loginResult.loginData)
            }.catch { error in
                AlertHelper.showError(error: error)
        }
    }
    func getProfile(userId: Int) {
        AlertHelper.showLoading()
        UserProvider.getProfile(userId: userId).then { _ in
            AlertHelper.hideLoading()
            }.catch { error in
                AlertHelper.showError(error: error)
        }
    }
}
