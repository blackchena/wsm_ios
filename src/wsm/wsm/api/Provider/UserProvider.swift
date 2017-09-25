//
//  UserProvider.swift
//  wsm
//
//  Created by framgia on 9/19/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import Result
import Moya
import PromiseKit
import ObjectMapper

final class UserProvider {

    typealias AppSettingPromise = Promise<(UserProfileApiOutputModel, UserSettingApiOutputModel, ListLeaveTypeSettingApiOutputModel, ListDayOffSettingApiOutputModel)>

    static func getProfile(userId: Int) -> Promise<UserProfileApiOutputModel> {
        return ApiProvider.shared.requestPromise(target: .getProfile(userId: userId))
    }

    static func getSettings() -> Promise<UserSettingApiOutputModel> {
        return ApiProvider.shared.requestPromise(target: .getUserSettings)
    }

    static func getListLeaveTypeSetting() -> Promise<ListLeaveTypeSettingApiOutputModel> {
        return ApiProvider.shared.requestPromise(target: .getListLeaveTypesSettings)
    }

    static func getListDateOffSetting() -> Promise<ListDayOffSettingApiOutputModel> {
        return ApiProvider.shared.requestPromise(target: .getListDayOffSettings)
    }

    static func getAllAppSettingsAsync(userId: Int) -> AppSettingPromise {
        return when(fulfilled: getProfile(userId: userId), getSettings(), getListLeaveTypeSetting(), getListDateOffSetting())
    }
}
