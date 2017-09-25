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

final class LoginProvider {
    static func login(_ email: String, _ password: String) -> Promise<LoginApiOutputModel> {
        return ApiProvider.shared.requestPromise(target: .login(email, password))
    }

    static func logout() -> Promise<Void> {
        return ApiProvider.shared.requestPromise(target: .logout)
    }
}
