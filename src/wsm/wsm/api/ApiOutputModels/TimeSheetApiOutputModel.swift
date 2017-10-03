//
//  TimeSheetApiOutputModel.swift
//  wsm
//
//  Created by Lê Thanh Quang on 9/26/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import ObjectMapper

class TimeSheetApiOutputModel: ResponseData {

    var userTimeSheetData: TimeSheetModel?

    override func mapping(map: Map) {
        super.mapping(map: map)

        userTimeSheetData <- map["data"]
    }
}
