//
//  TimesheetProvider.swift
//  wsm
//
//  Created by Lê Thanh Quang on 9/26/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import PromiseKit
import Moya

fileprivate enum TimeSheetApiEndpoint: BaseApiTargetType {

    case getTimeSheets(month: Int, year: Int)

    public var path: String {
        switch self {
        case .getTimeSheets:
            return "/api/dashboard/user_timesheets"
        }
    }

    public var parameters: [String: Any]? {
        switch self {
        case .getTimeSheets(let month, let year):
            return ["month": month, "year": year]
        }
    }
}

class TimesheetProvider {

    static func getUserTimeSheet(month: Int, year: Int) -> Promise<TimeSheetApiOutputModel> {
        return ApiProvider.shared.requestPromise(target: MultiTarget(TimeSheetApiEndpoint.getTimeSheets(month: month, year: year)))
    }
}
