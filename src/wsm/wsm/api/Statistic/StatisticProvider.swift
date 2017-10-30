//
//  StatisticProvider.swift
//  wsm
//
//  Created by framgia on 10/24/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import Result
import Moya
import ObjectMapper
import SwiftyUserDefaults
import PromiseKit

fileprivate enum StatisticApiEndPoint: BaseApiTargetType {
    case getStatisticUser(year: Int?)

    public var path: String {
        switch self {
        case .getStatisticUser:
            return "/api/dashboard/statistics/users"
        }
    }

    var parameters: [String : Any]? {
        switch self {
        case .getStatisticUser(let year):
            if let year = year {
                return ["year" : year]
            }
            return nil
        }
    }
}

final class StatisticProvider {
    static func getStatisticUser(year: Int?) -> Promise<StatisticApiOutputModel> {
        return ApiProvider.shared.requestPromise(target: MultiTarget(StatisticApiEndPoint.getStatisticUser(year: year)))
    }
}
