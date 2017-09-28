//
//  UserServices.swift
//  wsm
//
//  Created by Lê Thanh Quang on 9/25/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import ObjectMapper
import SwiftyUserDefaults

class UserServices {

    //Put those keys here to prevent interactive with those key outside of this class
    private static let userLogin = DefaultsKey<String?>("WSM-userLogin")
    private static let userProfile = DefaultsKey<String?>("WSM-userProfile")
    private static let userSetting = DefaultsKey<String?>("WSM-userSetting")
    private static let listDayOffSetting = DefaultsKey<String?>("WSM-listDayOffSetting")
    private static let listLeaveTypeSetting = DefaultsKey<String?>("WSM-listLeaveTypeSetting")

    private static let authToken = DefaultsKey<String?>("WSM-AUTH-TOKEN")
    private static let currentLocale = DefaultsKey<String?>("WSM-LOCALE")

    public static func clearData() {
        Defaults.removeAll()
    }

    public static var isAlreadyLogin: Bool {
        return Defaults[authToken] != nil
    }

    public static func saveAuthToken(token: String?) {
        Defaults[authToken] = token
    }

    public static func getAuthToken() -> String? {
        return Defaults[authToken]
    }

    public static func saveUserLogin(loginModel: LoginModel?) {
        if let jsonString = loginModel?.toJSONString() {
            Defaults[userLogin] = jsonString
        }
    }

    public static func saveUserSettings(userProfileResult: UserProfileModel?,
                                        userSettingResult: UserSettingModel?,
                                        listLeaveTypeResult: [LeaveTypeModel]?,
                                        listDayOffResult: [DayOffModel]?) {

        Defaults[userProfile] = userProfileResult?.toJSONString()
        Defaults[userSetting] = userSettingResult?.toJSONString()
        Defaults[listDayOffSetting] = listLeaveTypeResult?.toJSONString()
        Defaults[listLeaveTypeSetting] = listDayOffResult?.toJSONString()
    }

    public static func getLocalUserLogin() -> LoginModel? {
        guard let dataRaw = Defaults[userLogin] else {
            return nil
        }

        return LoginModel(JSONString: dataRaw)
    }

    public static func getLocalUserProfile() -> UserProfileModel? {
        guard let dataRaw = Defaults[userProfile] else {
            return nil
        }

        return UserProfileModel(JSONString: dataRaw)
    }

    public static func getLocalUserSetting() -> UserSettingModel? {
        guard let dataRaw = Defaults[userSetting] else {
            return nil
        }

        return UserSettingModel(JSONString: dataRaw)
    }

    public static func getLocalDayOffSettings() -> [DayOffModel]? {
        guard let dataRaw = Defaults[listDayOffSetting] else {
            return nil
        }

        return [DayOffModel](JSONString: dataRaw)
    }

    public static func getLocalLeaveTypeSettings() -> [LeaveTypeModel]? {
        guard let dataRaw = Defaults[listLeaveTypeSetting] else {
            return nil
        }

        return [LeaveTypeModel](JSONString: dataRaw)
    }
}
