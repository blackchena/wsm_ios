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

    public var path: String {
        switch self {
        case .getListRequestOff:
            return "/api/dashboard/request_offs"
        case .deleteRequestOff(let id):
            return "/api/dashboard/request_offs/\(id)"
        case .createRequestOff:
            return "/api/dashboard/request_offs"
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
        }
    }

    public var parameters: [String: Any]? {
        switch self {
        case .getListRequestOff(let page, let month, let status):
            return ["page": page ?? "", "month": month ?? "", "q[status_eq]": status ?? ""]
        case .createRequestOff(let requestModel):
            return createParameters(fromDataModel: requestModel)
        default:
            return nil
        }
    }
}

final class RequestOffProvider {

    static let shared  = RequestOffProvider()
    var listRequests = [RequestDayOffModel]()

    static func getListRequestOff(page: Int?, month: String?, status: Int?) -> Promise<ListRequestOffApiOutModel> {
        return ApiProvider.shared.requestPromise(target: MultiTarget(RequestOffApiEndpoint.getListRequestOff(page: page, month: month, status: status)))
    }

    static func deleteRequestOff(id: Int) -> Promise<ResponseData> {
        return ApiProvider.shared.requestPromise(target: MultiTarget(RequestOffApiEndpoint.deleteRequestOff(id: id)))
    }

    static func createRequestOff(requestModel: RequestOffApiInputModel) -> Promise<RequestDayOffModel> {
        return ApiProvider.shared.requestPromise(target: MultiTarget(RequestOffApiEndpoint.createRequestOff(requestModel: requestModel)))
    }
}
