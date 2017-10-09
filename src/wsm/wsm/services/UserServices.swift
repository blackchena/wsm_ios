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
    
    static func clearToken() {
         Defaults[authToken] = nil
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
        saveUserProfile(userProfileResult: userProfileResult)
        saveUserSetting(userSettingResult: userSettingResult)
        saveLeaveTypeSettings(listLeaveTypeResult: listLeaveTypeResult)
        saveDayOffSettings(listDayOffResult: listDayOffResult)
    }

    public static func getLocalUserLogin() -> LoginModel? {
        guard let dataRaw = Defaults[userLogin] else {
            return nil
        }

        return LoginModel(JSONString: dataRaw)
    }

    public static func saveUserProfile(userProfileResult: UserProfileModel?) {
        Defaults[userProfile] = userProfileResult?.toJSONString()
    }
    
    public static func clearUserProfile() {
        Defaults[userProfile] = nil
    }

    public static func saveUserSetting(userSettingResult: UserSettingModel?) {
        Defaults[userSetting] = userSettingResult?.toJSONString()
    }
    
    public static func clearUserSetting() {
        Defaults[userSetting] = nil
    }

    public static func saveDayOffSettings(listDayOffResult: [DayOffModel]?) {
        Defaults[listDayOffSetting] = listDayOffResult?.toJSONString()
    }
    
    public static func clearDayOffSettings() {
        Defaults[listDayOffSetting] = nil
    }

    public static func saveLeaveTypeSettings(listLeaveTypeResult: [LeaveTypeModel]?) {
        Defaults[listLeaveTypeSetting] = listLeaveTypeResult?.toJSONString()
    }
    
    public static func clearLeaveTypeSettings() {
        Defaults[listLeaveTypeSetting] = nil
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

    public static func findLocalLeaveTypeSetting(id: Int?) -> LeaveTypeModel? {
        if let leavevTypes = getLocalLeaveTypeSettings(),
            let i = leavevTypes.index(where: {$0.id == id}) {
            return leavevTypes[i]
        } else {
            return nil
        }
    }
    
     static func clearAllUserData() {
        clearToken()
        clearUserProfile()
        clearUserSetting()
        clearDayOffSettings()
        clearLeaveTypeSettings()
    }
}
