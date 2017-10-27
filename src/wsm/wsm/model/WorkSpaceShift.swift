//
//  WorkSpaceShift.swift
//  wsm
//
//  Created by framgia on 10/3/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import ObjectMapper

class WorkSpaceShift : BaseModel {
    var id: Int?
    var maxComeLate: Int?
    var maxLevesEarly: Int?
    var timeIn: Date?
    var timeLunch: Date?
    var timeAfternoon: Date?
    var timeOut: Date?

    required init?(map: Map) {
    }

    public func mapping(map: Map) {
        let iosDateTransform = WSMDateTransform(formatFromJson: DateFormatType.isoDateTimeMilliSec,
                                                formatToJson: DateFormatType.isoDateTimeMilliSec)

        id <- map["id"]
        timeIn <- (map["time_in"], iosDateTransform)
        timeLunch <- (map["time_lunch"], iosDateTransform)
        timeAfternoon <- (map["time_afternoon"], iosDateTransform)
        timeOut <- (map["time_out"], iosDateTransform)
        maxComeLate <- map["max_come_late"]
        maxLevesEarly <- map["max_leves_early"]
    }

    func getMaxComeLateSpecial() -> Int? {
        guard let max = maxComeLate else {
            return nil
        }
        let maxSecond = max * 3600
        guard let special = UserServices.getLocalUserProfile()?.special else {
            return maxSecond
        }
        switch special {
        case .children:
            return maxSecond + AppConstant.childrenSpecialTime * 60
        case .baby:
            return maxSecond + AppConstant.babySpecialTime * 60
        default:
            return maxSecond
        }
    }

    func getMaxLeavesEarlySpecial() -> Int? {
        guard let max = maxLevesEarly else {
            return nil
        }
        let maxSecond = max * 3600
        guard let special = UserServices.getLocalUserProfile()?.special else {
            return maxSecond
        }
        switch special {
        case .children:
            return maxSecond + AppConstant.childrenSpecialTime * 60
        case .baby:
            return maxSecond + AppConstant.babySpecialTime * 60
        default:
            return maxSecond
        }
    }

    func getTimeInSpecial() -> Date? {
        guard let date = timeIn else {
            return nil
        }
        return UserServices.getLocalUserProfile()?.special == .children ? Calendar.current.date(byAdding: .minute, value: AppConstant.childrenSpecialTime, to: date) : date
    }

    func getTimeAfternoonSpecial() -> Date? {
        guard let date = timeAfternoon else {
            return nil
        }
        return UserServices.getLocalUserProfile()?.special == .children ? Calendar.current.date(byAdding: .minute, value: AppConstant.childrenSpecialTime, to: date) : date
    }

    func getTimeOutSpecial() -> Date? {
        guard let date = timeOut else {
            return nil
        }
        return UserServices.getLocalUserProfile()?.special == .children ? Calendar.current.date(byAdding: .minute, value: AppConstant.childrenSpecialTime, to: date) : date
    }
}
