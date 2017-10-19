//
//  DateOffModel.swift
//  wsm
//
//  Created by Lê Thanh Quang on 9/25/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import ObjectMapper
import InAppLocalize

class DayOffSettingModel: BaseModel {

    var id: Int?
    var code: String?
    var companyId: String?
    var dayOffSettingId: Int?
    var amount: Float?
    var unit: String?
    var limitTimes: Float?
    var loopType: String?
    var payType: DateOffType = .noSalary
    var name: String?
    var description: String?
    var remaining: Float?
    var isAnnualLeave: Bool = false

    init(id: Int?, code: String?,
         companyId: String?,
         dayOffSettingId: Int?, amount: Float?,
         unit: String?, limitTimes: Float?,
         loopType: String?, payType: DateOffType,
         name: String?, description: String?,
         remaining: Float?, isAnnualLeave: Bool) {

        self.id = id
        self.code = code
        self.companyId = companyId
        self.dayOffSettingId = dayOffSettingId
        self.amount = amount
        self.unit = unit
        self.limitTimes = limitTimes
        self.loopType = loopType
        self.payType = payType
        self.name = name
        self.description = description
        self.remaining = remaining
        self.isAnnualLeave = isAnnualLeave
    }

    var dayOffAsString: String {
        return String(format: LocalizationHelper.shared.localized("off_type_with_amount"),
                      name ?? "N/A",
                      remaining ?? 0,
                      unit ?? "N/A")
    }

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
