//
//  ListDayOffSettingApiOutputModel.swift
//  wsm
//
//  Created by Lê Thanh Quang on 9/25/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import ObjectMapper

class ListDayOffSettingApiOutputModel: ResponseData {

    var listDayOffSetting: [DayOffSettingModel]?
    var remainingDayOff: Float?

    override func mapping(map: Map) {
        super.mapping(map: map)

        listDayOffSetting <- map["data.special_dayoff_settings"]
        remainingDayOff <- map["remaining_days_off"]
    }
}
