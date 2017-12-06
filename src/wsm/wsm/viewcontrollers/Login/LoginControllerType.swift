//
//  LoginControllerType.swift
//  wsm
//
//  Created by nguyen.van.hung on 9/18/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit

protocol LoginControllerType {
    func didLoginSuccess()
}

extension LoginControllerType where Self: UIViewController {
    func login(with email: String, password: String) {

        AlertHelper.showLoading()

        //reset authToken, all settings local data
        UserServices.clearData()

        LoginProvider.login(email, password)
            .then { loginResult -> UserProvider.AppSettingPromise in
                if UserServices.getFCMToken() != nil {
                    UserServices.saveFCMToken(nil)
                }

                //save authToken value
                UserServices.saveAuthToken(token: loginResult.loginData?.authenToken)

                //save user on local
                UserServices.saveUserLogin(loginModel: loginResult.loginData)

                //start async call apis setting for app
                return UserProvider.getAllAppSettingsAsync(userId: (loginResult.loginData?.userId)!)
            }.then { (userProfileResult, userSettingResult, listLeaveTypeSettingResult, listDayOffSettingResult, listNotifications) -> Void in
                UserServices.saveUserSettings(userProfileResult: userProfileResult.userData,
                                              userSettingResult: userSettingResult.userSetting,
                                              listLeaveTypeResult: listLeaveTypeSettingResult.listLeaveTypeSetting,
                                              listDayOffResult: listDayOffSettingResult,
                                              notificationData: listNotifications)
                self.didLoginSuccess()
            }.catch { error in
                AlertHelper.showError(error: error)
            }.always {
                AlertHelper.hideLoading()
        }
    }
}
