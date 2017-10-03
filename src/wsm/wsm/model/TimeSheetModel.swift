//
//  TimeSheetModel.swift
//  wsm
//
//  Created by Lê Thanh Quang on 9/26/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import ObjectMapper
//import AFDateHelper

class TimeSheetModel: BaseModel {

    var month: Date?
    var startDate: Date?
    var endDate: Date?
    var totalDayOff: Float?
    var numberDayOffHaveSalary: Float?
    var numberDayOffNoSalary: Float?
    var numberOverTime: Float?
    var totalFining: Float?
    var timeSheetDays: [TimeSheetDayModel]?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        let customDateTransform = WSMDateTransform(formatFromJson: .custom("yyyy/m"), formatToJson: .custom("yyyy/m"))
        let iosDateTransform = WSMDateTransform(formatFromJson: DateFormatType.isoDate,
                                                formatToJson: DateFormatType.isoDate)

        month <- (map["month"], customDateTransform)
        startDate <- (map["start_date"], iosDateTransform)
        endDate <- (map["end_date"], iosDateTransform)
        totalDayOff <- map["total_day_off"]
        numberDayOffHaveSalary <- map["number_day_off_have_salary"]
        numberDayOffNoSalary <- map["number_day_off_no_salary"]
        numberOverTime <- map["number_over_time"]
        totalFining <- map["total_fining"]
        timeSheetDays <- map["timesheet"]

    }
}
