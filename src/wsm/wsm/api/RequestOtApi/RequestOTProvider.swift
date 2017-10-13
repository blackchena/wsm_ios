//
//  RequestOTProvider.swift
//  wsm
//
//  Created by Lê Thanh Quang on 9/26/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import Result
import Moya
import ObjectMapper
import SwiftyUserDefaults
import PromiseKit

fileprivate enum RequestOtApiEndpoint: BaseApiTargetType {
    case submitRequestOt(requestModel: RequestOtApiInputModel)
    case getListRequestOts(page:Int, month:String?, status: Int?)

    public var path: String {
        switch self {
        case .submitRequestOt:
            return "/api/dashboard/request_ots"
        case .getListRequestOts:
            return "/api/dashboard/request_ots"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .submitRequestOt:
            return .post
        case .getListRequestOts:
            return .get
        }
    }


    public var parameters: [String: Any]? {
        switch self {
        case .submitRequestOt(let requestModel):
            return [
                "request_ot": createParameters(fromDataModel: requestModel)
            ]
        case .getListRequestOts(let page, let month, let status):
            return ["page": page, "month": month ?? "", "q[status_eq]": status ?? ""]
        }
    }
}

final class RequestOtProvider {
    static let shared = RequestOtProvider()
    var listRequestOts = [RequestOtModel]()

    static func submitRequestOt(requestModel: RequestOtApiInputModel) -> Promise<CreateRequestOtApiOutModel> {
        return ApiProvider.shared.requestPromise(target: MultiTarget(RequestOtApiEndpoint.submitRequestOt(requestModel: requestModel)))
    }
    
    static func getListRequestOts(page: Int, month: String?, status: Int?) -> Promise<ListRequestOTApiOutModel> {
        return ApiProvider.shared.requestPromise(target: MultiTarget(RequestOtApiEndpoint.getListRequestOts(page: page, month: month, status: status)))
    }
}
