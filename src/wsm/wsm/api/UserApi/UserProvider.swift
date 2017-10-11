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

fileprivate enum UserApiEndpoint: BaseApiTargetType {
    case getProfile(userId: Int)
    case getUserSettings
    case getListLeaveTypesSettings
    case getListDayOffSettings

    public var path: String {
        switch self {
        case .getProfile(let userId):
            return "/api/dashboard/users/\(userId)"
        case .getUserSettings:
            return "api/dashboard/user_settings"
        case .getListLeaveTypesSettings:
            return "/api/dashboard/leave_types"
        case .getListDayOffSettings:
            return "/api/dashboard/dayoff_settings"
        }
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .getProfile(let userId):
            return ["user_id": userId]
        default:
            return nil
        }
    }
}

final class UserProvider {

    typealias AppSettingPromise = Promise<(UserProfileApiOutputModel, UserSettingApiOutputModel, ListLeaveTypeSettingApiOutputModel, ListDayOffSettingApiOutputModel)>

    private static func getProfile(userId: Int) -> Promise<UserProfileApiOutputModel> {
        return ApiProvider.shared.requestPromise(target: MultiTarget(UserApiEndpoint.getProfile(userId: userId)))
    }

    private static func getSettings() -> Promise<UserSettingApiOutputModel> {
        return ApiProvider.shared.requestPromise(target: MultiTarget(UserApiEndpoint.getUserSettings))
    }

    private static func getListLeaveTypeSetting() -> Promise<ListLeaveTypeSettingApiOutputModel> {
        return ApiProvider.shared.requestPromise(target: MultiTarget(UserApiEndpoint.getListLeaveTypesSettings))
    }

    private static func getListDateOffSetting() -> Promise<ListDayOffSettingApiOutputModel> {
        return ApiProvider.shared.requestPromise(target: MultiTarget(UserApiEndpoint.getListDayOffSettings))
    }

    static func getAllAppSettingsAsync(userId: Int) -> AppSettingPromise {
        return when(fulfilled: getProfile(userId: userId), getSettings(), getListLeaveTypeSetting(), getListDateOffSetting())
    }
}
