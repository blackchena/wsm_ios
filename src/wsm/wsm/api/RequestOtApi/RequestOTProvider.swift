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

    public var path: String {
        switch self {
        case .submitRequestOt:
            return "/api/dashboard/request_ots"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .submitRequestOt:
            return .post
        }
    }


    public var parameters: [String: Any]? {
        switch self {
        case .submitRequestOt(let requestModel):
            return [
                "request_ot": createParameters(fromDataModel: requestModel)
            ]
        }
    }
}

final class RequestOtProvider {
    static var listRequests = [RequestOtModel]()

    static func submitRequestOt(requestModel: RequestOtApiInputModel) -> Promise<CreateRequestOtApiOutModel> {
        return ApiProvider.shared.requestPromise(target: MultiTarget(RequestOtApiEndpoint.submitRequestOt(requestModel: requestModel)))
    }
}
