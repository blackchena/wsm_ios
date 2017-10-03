//
//  TimeSheetDayModel.swift
//  wsm
//
//  Created by Lê Thanh Quang on 9/26/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import ObjectMapper
//import AFDateHelper

class TimeSheetDayModel: BaseModel {

    var date: Date?
    var timeIn: Date?
    var timeOut: Date?
    var textMorning: String?
    var textAfternoon: String?
    var colorMorning: UIColor?
    var colorAfternoon: UIColor?
    var hoursOverTime: Float?
    var compensationHoliday: Bool?
    var colorSpecialDate: UIColor?

    var isSpecialCase: Bool {
        return TimeSheetSpecialCaseEnum(rawValue: textMorning ?? "") != nil && TimeSheetSpecialCaseEnum(rawValue: textAfternoon ?? "") != nil
    }

    var morningColorDisplay: UIColor? {
        if let date = date,
            date.compare(.isWeekend) && !(compensationHoliday ?? true) {
            return colorSpecialDate
        } else if let textMorning = textMorning,
            let dayOffType = TimeSheetDayOffTypeEnum(rawValue: textMorning[0]) {
            return dayOffType.dayOffColor
        } else {
            return colorMorning
        }
    }

    var morningTextDisplay: String? {
        if let morningDateTimeCheckin = Date(fromString: textMorning ?? "", format: .isoDateTimeMilliSec, timeZone: .local) {
            return morningDateTimeCheckin.toString(dateFormat: AppConstant.TimeFormat24HDisplay)
        } else {
            return textMorning
        }
    }

    var afternoonColorDisplay: UIColor? {
        if let date = date,
            date.compare(.isWeekend) && !(compensationHoliday ?? true) {
            return colorSpecialDate
        } else if let textAfternoon = textAfternoon,
            let dayOffType = TimeSheetDayOffTypeEnum(rawValue: textAfternoon[0]) {
            return dayOffType.dayOffColor
        } else {
            return colorAfternoon
        }
    }

    var afternoonTextDisplay: String? {
        if let afternoonDateTimeCheckout = Date(fromString: textAfternoon ?? "", format: .isoDateTimeMilliSec, timeZone: .local) {
            return afternoonDateTimeCheckout.toString(dateFormat: AppConstant.TimeFormat24HDisplay)
        } else {
            return textAfternoon
        }
    }

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        let defaultDateTransform = WSMDateTransform()
        let iosDateTransform = WSMDateTransform(formatFromJson: DateFormatType.isoDate,
                                                formatToJson: DateFormatType.isoDate)
        let hexColorTransform = HexColorTransform(prefixToJSON: true, alphaToJSON: false)

        date <- (map["date"], iosDateTransform)
        timeIn <- (map["time_in"], defaultDateTransform)
        timeOut <- (map["time_out"], defaultDateTransform)
        textMorning <- map["text_morning"]
        textAfternoon <- map["text_afternoon"]
        colorMorning <- (map["color_morning"], hexColorTransform)
        colorAfternoon <- (map["color_afternoon"], hexColorTransform)
        hoursOverTime <- map["hours_over_time"]
        compensationHoliday <- map["compensation_holiday"]
        colorSpecialDate <- (map["color_special_date"], hexColorTransform)
    }
}
