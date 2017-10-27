//
//  StatisticOfMonthModel.swift
//  wsm
//
//  Created by framgia on 10/24/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import ObjectMapper

class StatisticOfYearModel: BaseModel {

    var name: String?
    var data = [Double]()

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        name <- map["name"]
        data <- map["data"]
    }
}
