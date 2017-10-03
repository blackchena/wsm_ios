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

final class RequestLeaveProvider {

    static var listRequests = [RequestLeaveModel]()

    static func submitRequestLeave(requestModel: RequestLeaveApiInputModel) -> Promise<CreateRequestLeaveApiOutModel> {
        return ApiProvider.shared.requestPromise(target: .submitRequestLeave(requestModel: requestModel))
    }
}
