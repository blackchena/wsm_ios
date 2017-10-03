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

final class RequestOtProvider {

    static var listRequests = [RequestOtModel]()

    static func submitRequestOt(requestModel: RequestOtApiInputModel) -> Promise<CreateRequestOtApiOutModel> {
        return ApiProvider.shared.requestPromise(target: .submitRequestOt(requestModel: requestModel))
    }
}
