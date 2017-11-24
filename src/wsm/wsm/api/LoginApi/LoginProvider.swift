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

    public var path: String {
        switch self {
        case .login:
            return "/api/sign_in"
        case .logout:
            return "/api/sign_out"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .login:
            return .post
        case .logout:
            return .delete
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
            }
            return ["sign_in": params]
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
}
