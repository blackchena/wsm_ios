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
    case getListRequestLeaves(page: Int?, month: String?, status: String?)

    public var path: String {
        switch self {
        case .submitRequestLeave:
            return "/api/dashboard/request_leaves"
        case .getListRequestLeaves:
            return "/api/dashboard/request_leaves"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .submitRequestLeave:
            return .post
        case .getListRequestLeaves:
            return .get
        }
    }

    public var parameters: [String: Any]? {
        switch self {
        case .submitRequestLeave(let requestModel):
            return [
                "request_leave": createParameters(fromDataModel: requestModel)
            ]
        case .getListRequestLeaves(let page, let month, let status):
            return ["page": page, "month": month, "q[status_eq]": status]
        }
    }
}

final class RequestLeaveProvider {

    static let shared  = RequestLeaveProvider()
    var listRequests = [RequestLeaveModel]()

    static func submitRequestLeave(requestModel: RequestLeaveApiInputModel) -> Promise<CreateRequestLeaveApiOutModel> {
        return ApiProvider.shared.requestPromise(target: MultiTarget(RequestLeaveApiEndpoint.submitRequestLeave(requestModel: requestModel)))
    }

    static func getListRequestLeaves(page: Int?, month: String?, status: String?) -> Promise<ListRequestLeaveApiOutModel> {
        return ApiProvider.shared.requestPromise(target: MultiTarget(RequestLeaveApiEndpoint.getListRequestLeaves(page: page, month: month, status: status)))
    }
}
