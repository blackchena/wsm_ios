//
//  TimesheetProvider.swift
//  wsm
//
//  Created by Lê Thanh Quang on 9/26/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import PromiseKit

class TimesheetProvider {

    static func getUserTimeSheet(month: Int, year: Int) -> Promise<TimeSheetApiOutputModel> {
        return ApiProvider.shared.requestPromise(target: .getTimeSheets(month: month, year: year))
    }
}
