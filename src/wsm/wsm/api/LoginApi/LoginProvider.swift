//
//  LoginProvider.swift
//  wsm
//
//  Created by nguyen.van.hung on 6/30/17.
//  Copyright © 2017 nguyen.van.hung. All rights reserved.
//

import Foundation
import Result
import Moya
import ObjectMapper
import SwiftyUserDefaults
import PromiseKit
import FirebaseMessaging

fileprivate enum LoginApiEndpoint: BaseApiTargetType {
    case login(String, String)
    case logout
    case updateDeviceToken(String)

    public var path: String {
        switch self {
        case .login:
            return "/api/sign_in"
        case .logout:
            return "/api/sign_out"
        case .updateDeviceToken:
            return "/api/dashboard/update_device_ids"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .login:
            return .post
        case .logout:
            return .delete
        case .updateDeviceToken:
            return .put
        }
    }

    public var parameters: [String: Any]? {
        switch self {
        case .login(let email, let password):
            var params: [String: Any] = [
                "email": email,
                "password": password
            ]
            if let fcmToken = Messaging.messaging().fcmToken {
                params["device_id"] = fcmToken
                params["device_type"] = "ios"
            }
            return ["sign_in": params]
        case .updateDeviceToken(let token):
            return ["device_id": token]
        default:
            return nil
        }
    }
}

final class LoginProvider {

    static func login(_ email: String, _ password: String) -> Promise<LoginApiOutputModel> {
        return ApiProvider.shared.requestPromise(target: MultiTarget(LoginApiEndpoint.login(email, password)))
    }

    static func logout() -> Promise<Void> {
        return ApiProvider.shared.requestPromise(target: MultiTarget(LoginApiEndpoint.logout))
    }

    static func updateDeviceToken(_ token: String) -> Promise<ResponseData> {
        return ApiProvider.shared.requestPromise(target: MultiTarget(LoginApiEndpoint.updateDeviceToken(token)))
    }

}
