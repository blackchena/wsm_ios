//
//  StatisticApiOutputModel.swift
//  wsm
//
//  Created by framgia on 10/24/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import ObjectMapper

class StatisticApiOutputModel: ResponseData {

    var listStatisticOfYear = [StatisticOfYearModel]()
    var statisticOfMonth: StatisticOfMonthModel?

    override func mapping(map: Map) {
        super.mapping(map: map)
        listStatisticOfYear <- map["data.statistics_of_year"]
        statisticOfMonth <- map["data.statistics_of_month"]
    }
}
