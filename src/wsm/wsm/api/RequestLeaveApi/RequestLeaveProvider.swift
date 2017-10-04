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

fileprivate enum RequestLeaveApiEndpoint: BaseApiTargetType {
    case submitRequestLeave(requestModel: RequestLeaveApiInputModel)

    public var path: String {
        switch self {
        case .submitRequestLeave:
            return "/api/dashboard/request_leaves"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .submitRequestLeave:
            return .post
        }
    }

    public var parameters: [String: Any]? {
        switch self {
        case .submitRequestLeave(let requestModel):
            return [
                "request_leave": createParameters(fromDataModel: requestModel)
            ]
        }
    }
}

final class RequestLeaveProvider {

    static var listRequests = [RequestLeaveModel]()

    static func submitRequestLeave(requestModel: RequestLeaveApiInputModel) -> Promise<CreateRequestLeaveApiOutModel> {
        return ApiProvider.shared.requestPromise(target: MultiTarget(RequestLeaveApiEndpoint.submitRequestLeave(requestModel: requestModel)))
    }
}
