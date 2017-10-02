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

final class RequestOtProvider {

    static var listRequests = [RequestOtModel]()

    static func submitRequestOt(requestModel: RequestOtApiInputModel) -> Promise<CreateRequestOtApiOutModel> {
        return ApiProvider.shared.requestPromise(target: .submitRequestOt(requestModel: requestModel))
    }
}
