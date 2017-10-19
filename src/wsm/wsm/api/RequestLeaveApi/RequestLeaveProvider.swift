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
    case editRequestLeave(requestModel: RequestLeaveApiInputModel)
    case getListRequestLeaves(page: Int?, month: String?, status: Int?)
    case deleteRequestLeave(int: Int)

    public var path: String {
        switch self {
        case .submitRequestLeave:
            return "/api/dashboard/request_leaves"
        case .editRequestLeave(let requestModel):
            if let id = requestModel.id {
                return "/api/dashboard/request_leaves/\(id)"
            }
            return ""
        case .getListRequestLeaves:
            return "/api/dashboard/request_leaves"
        case .deleteRequestLeave(let id):
            return "/api/dashboard/request_leaves/\(id)"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .submitRequestLeave:
            return .post
        case .editRequestLeave:
            return .put
        case .getListRequestLeaves:
            return .get
        case .deleteRequestLeave:
            return .delete

        }
    }

    public var parameters: [String: Any]? {
        switch self {
        case .submitRequestLeave(let requestModel),
             .editRequestLeave(let requestModel):
            return ["request_leave" : createParameters(fromDataModel: requestModel)]
        case .getListRequestLeaves(let page, let month, let status):
            return ["page": page ?? "", "month": month ?? "", "q[status_eq]": status ?? ""]
        default:
            return nil
        }
    }
}

final class RequestLeaveProvider {

    static let shared  = RequestLeaveProvider()
    var listRequests = [RequestLeaveModel]()

    static func submitRequestLeave(requestModel: RequestLeaveApiInputModel) -> Promise<CreateRequestLeaveApiOutModel> {
        if requestModel.id == nil {
            return ApiProvider.shared.requestPromise(target: MultiTarget(RequestLeaveApiEndpoint.submitRequestLeave(requestModel: requestModel)))
        } else {
            return ApiProvider.shared.requestPromise(target: MultiTarget(RequestLeaveApiEndpoint.editRequestLeave(requestModel: requestModel)))
        }
    }

    static func getListRequestLeaves(page: Int?, month: String?, status: Int?) -> Promise<ListRequestLeaveApiOutModel> {
        return ApiProvider.shared.requestPromise(target: MultiTarget(RequestLeaveApiEndpoint.getListRequestLeaves(page: page, month: month, status: status)))
    }

    static func deleteRequestLeave(id: Int) -> Promise<ResponseData> {
        return ApiProvider.shared.requestPromise(target: MultiTarget(RequestLeaveApiEndpoint.deleteRequestLeave(int: id)))
    }
}
