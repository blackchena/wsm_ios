//
//  RequestOffProvider.swift
//  wsm
//
//  Created by Lê Thanh Quang on 9/26/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import PromiseKit
import Moya

fileprivate enum RequestOffApiEndpoint: BaseApiTargetType {
    case getListRequestOff(page: Int?, month: String?, status: Int?)
    case deleteRequestOff(id: Int)
    case createRequestOff(requestModel: RequestOffApiInputModel)
    case editRequestOff(id: Int, requestModel: RequestOffApiInputModel)
    case getListTheReplacement(groupId: Int)

    public var path: String {
        switch self {
        case .getListRequestOff:
            return "/api/dashboard/request_offs"
        case .deleteRequestOff(let id):
            return "/api/dashboard/request_offs/\(id)"
        case .createRequestOff:
            return "/api/dashboard/request_offs"
        case .editRequestOff(let id, _):
            return "/api/dashboard/request_offs/\(id)"
        case .getListTheReplacement(let groupId):
            return "api/dashboard/get_users_group?group_id=\(groupId)"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .getListRequestOff:
            return .get
        case .deleteRequestOff:
            return .delete
        case .createRequestOff:
            return .post
        case .editRequestOff:
            return .put
        case .getListTheReplacement:
            return .get
        }
    }

    public var parameters: [String: Any]? {
        switch self {
        case .getListRequestOff(let page, let month, let status):
            return ["page": page ?? "", "month": month ?? "", "q[status_eq]": status ?? ""]
        case .createRequestOff(let requestModel):
            return createParameters(fromDataModel: requestModel)
        case .editRequestOff( _, let requestModel):
            return createParameters(fromDataModel: requestModel)
        default:
            return nil
        }
    }
}

final class RequestOffProvider {

    static let shared  = RequestOffProvider()
    var listRequests = [RequestDayOffModel]()
    var listTheReplacements = [ReplacementModel]()

    static func getListRequestOff(page: Int?, month: String?, status: Int?) -> Promise<ListRequestOffApiOutModel> {
        return ApiProvider.shared.requestPromise(target: MultiTarget(RequestOffApiEndpoint.getListRequestOff(page: page, month: month, status: status)))
    }

    static func deleteRequestOff(id: Int) -> Promise<ResponseData> {
        return ApiProvider.shared.requestPromise(target: MultiTarget(RequestOffApiEndpoint.deleteRequestOff(id: id)))
    }

    static func createRequestOff(requestModel: RequestOffApiInputModel) -> Promise<RequestDayOffModel> {
        return ApiProvider.shared.requestPromise(target: MultiTarget(RequestOffApiEndpoint.createRequestOff(requestModel: requestModel)))
    }

    static func editRequestOff(id: Int, requestModel: RequestOffApiInputModel) -> Promise<RequestDayOffModel> {
        return ApiProvider.shared.requestPromise(target: MultiTarget(RequestOffApiEndpoint.editRequestOff(id: id, requestModel: requestModel)))
    }
    
    static func getListTheReplacement(groupId: Int) -> Promise<ReplacementApiOutputModel> {
        return ApiProvider.shared.requestPromise(target: MultiTarget(RequestOffApiEndpoint.getListTheReplacement(groupId: groupId)))
    }
}
