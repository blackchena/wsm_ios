//
//  ListLeaveTypeApiOutputModel.swift
//  wsm
//
//  Created by Lê Thanh Quang on 9/25/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import ObjectMapper
//import AFDateHelper

class ListLeaveTypeSettingApiOutputModel: ResponseData {

    var listLeaveTypeSetting: [LeaveTypeModel]?

    override func mapping(map: Map) {
        super.mapping(map: map)
        listLeaveTypeSetting <- map["data"]
    }
}
