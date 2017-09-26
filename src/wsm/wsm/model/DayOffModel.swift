//
//  DateOffModel.swift
//  wsm
//
//  Created by Lê Thanh Quang on 9/25/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import ObjectMapper

class DayOffModel: BaseModel {

    var id: Int?
    var code: String?
    var companyId: String?
    var dayOffSettingId: Int?
    var amount: Int?
    var unit: String?
    var limitTimes: Int?
    var loopType: String?
    var payType: String?
    var name: String?
    var description: String?
    var remaining: Int?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        id <- map["id"]
        code <- map["code"]
        companyId <- map["company_id"]
        dayOffSettingId <- map["dayoff_setting_id"]
        amount <- map["amount"]
        unit <- map["unit"]
        limitTimes <- map["limit_times"]
        loopType <- map["loop_type"]
        payType <- map["pay_type"]
        name <- map["name"]
        description <- map["description"]
        remaining <- map["remaining"]
    }
}
