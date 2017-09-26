//
//  LeaveTypeModel.swift
//  wsm
//
//  Created by Lê Thanh Quang on 9/25/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import ObjectMapper

class LeaveTypeModel: BaseModel {

    var id: Int?
    var name: String?
    var code: String?
    var limitTimes: Int?
    var isEnable: Bool?
    var compensationKind: String?
    var trackingTimeType: String?
    var typeLoop: String?
    var siblingId: String?
    var companyId: String?
    var maxLeaveDuration: Any?
    var maxPerOne: Int?
    var unlimit: Bool?
    var isSuccessive: Bool?
    var numberExpireCompensationDate: Int?
    var blockMinutes: Int?
    var enableForwardRequestMode: Bool?
    var timeOutForwardRequest: Int?
    var numberExpireDateCreateForm: Int?
    var limitDaySuccessive: Any?
    var isFollowTimeCompany: Bool?
    var minimumPerOne: Int?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        code <- map["code"]
        limitTimes <- map["limit_times"]
        isEnable <- map["is_enable"]
        compensationKind <- map["compensation_kind"]
        trackingTimeType <- map["tracking_time_type"]
        typeLoop <- map["type_loop"]
        siblingId <- map["sibling_id"]
        companyId <- map["company_id"]
        maxLeaveDuration <- map["max_leave_duration"]
        maxPerOne <- map["max_per_one"]
        unlimit <- map["unlimit"]
        isSuccessive <- map["is_successive"]
        numberExpireCompensationDate <- map["number_expire_compensation_date"]
        blockMinutes <- map["block_minutes"]
        enableForwardRequestMode <- map["enable_forward_request_mode"]
        timeOutForwardRequest <- map["timeout_forward_request"]
        numberExpireDateCreateForm <- map["number_expire_date_create_form"]
        limitDaySuccessive <- map["limit_day_successive"]
        isFollowTimeCompany <- map["is_follow_time_company"]
        minimumPerOne <- map["minimum_per_one"]
    }
}
