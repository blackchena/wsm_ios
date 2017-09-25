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
    static func getProfile(userId: Int) -> Promise<UserApiOutputModel> {
        return ApiProvider.shared.requestPromise(target: .getProfile(userId: userId))
    }
}
