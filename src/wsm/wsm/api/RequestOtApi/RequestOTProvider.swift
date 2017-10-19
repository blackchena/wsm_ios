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
    case createRequestOt(requestModel: RequestOtApiInputModel)
    case editRequestOt(id: Int, requestModel: RequestOtApiInputModel)
    case getListRequestOts(page:Int, month:String?, status: Int?)
    case deleteOtRequest(id: Int)

    public var path: String {
        switch self {
        case .createRequestOt:
            return "/api/dashboard/request_ots"
        case .editRequestOt(let id, _):
            return "/api/dashboard/request_ots/\(id)"
        case .getListRequestOts:
            return "/api/dashboard/request_ots"
        case .deleteOtRequest(let id):
            return "/api/dashboard/request_ots/\(id)"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .createRequestOt:
            return .post
        case .editRequestOt:
            return .put
        case .getListRequestOts:
            return .get
        case .deleteOtRequest:
            return .delete
        }
    }


    public var parameters: [String: Any]? {
        switch self {
        case .createRequestOt(let requestModel),
             .editRequestOt(_, let requestModel):
            return [
                "request_ot": createParameters(fromDataModel: requestModel)
            ]
        case .getListRequestOts(let page, let month, let status):
            return ["page": page, "month": month ?? "", "q[status_eq]": status ?? ""]
        default:
            return nil
        }
    }
}

final class RequestOtProvider {
    static let shared = RequestOtProvider()
    var listRequestOts = [RequestOtModel]()
    
    static func createOTRequest(requestModel: RequestOtApiInputModel) -> Promise<CreateRequestOtApiOutModel> {
        return ApiProvider.shared.requestPromise(target: MultiTarget(RequestOtApiEndpoint.createRequestOt(requestModel: requestModel)))
    }
    
    static func updateOTRequest(id: Int, requestModel: RequestOtApiInputModel) -> Promise<CreateRequestOtApiOutModel> {
        return ApiProvider.shared.requestPromise(target: MultiTarget(RequestOtApiEndpoint.editRequestOt(id: id, requestModel: requestModel)))
    }
    
    static func getListRequestOts(page: Int, month: String?, status: Int?) -> Promise<ListRequestOTApiOutModel> {
        return ApiProvider.shared.requestPromise(target: MultiTarget(RequestOtApiEndpoint.getListRequestOts(page: page, month: month, status: status)))
    }
    
    static func deleteOtRequest(id: Int) -> Promise<ResponseData> {
        return ApiProvider.shared.requestPromise(target: MultiTarget(RequestOtApiEndpoint.deleteOtRequest(id: id)))
    }
}
