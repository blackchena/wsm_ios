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
    case changePassword(changePasswordModel: ChangePasswordApiInputModel)

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
        case .changePassword:
            return "/api/dashboard/passwords"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .changePassword:
            return .put
        default:
            return .get
        }
    }

    
    public var parameters: [String: Any]? {
        switch self {
        case .getProfile(let userId):
            return ["user_id": userId]
        case .changePassword(let changePasswordModel):
            return ["user": createParameters(fromDataModel: changePasswordModel)]
        default:
            return nil
        }
    }
}

final class UserProvider {

    typealias AppSettingPromise = Promise<(UserProfileApiOutputModel, UserSettingApiOutputModel, ListLeaveTypeSettingApiOutputModel, ListDayOffSettingApiOutputModel)>

    static func getProfile(userId: Int) -> Promise<UserProfileApiOutputModel> {
        return ApiProvider.shared.requestPromise(target: MultiTarget(UserApiEndpoint.getProfile(userId: userId)))
    }

    static func getSettings() -> Promise<UserSettingApiOutputModel> {
        return ApiProvider.shared.requestPromise(target: MultiTarget(UserApiEndpoint.getUserSettings))
    }

    static func getListLeaveTypeSetting() -> Promise<ListLeaveTypeSettingApiOutputModel> {
        return ApiProvider.shared.requestPromise(target: MultiTarget(UserApiEndpoint.getListLeaveTypesSettings))
    }

    static func getListDateOffSetting() -> Promise<ListDayOffSettingApiOutputModel> {
        return ApiProvider.shared.requestPromise(target: MultiTarget(UserApiEndpoint.getListDayOffSettings))
    }

    static func getAllAppSettingsAsync(userId: Int) -> AppSettingPromise {
        return when(fulfilled: getProfile(userId: userId), getSettings(), getListLeaveTypeSetting(), getListDateOffSetting())
    }

    static func changePassword(changePasswordModel: ChangePasswordApiInputModel) -> Promise<ResponseData> {
        return ApiProvider.shared.requestPromise(target: MultiTarget(UserApiEndpoint.changePassword(changePasswordModel: changePasswordModel)))
    }

}
