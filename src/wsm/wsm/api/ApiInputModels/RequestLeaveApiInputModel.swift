//
//  RequestOtModel.swift
//  wsm
//
//  Created by framgia on 9/26/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import ObjectMapper

public class RequestLeaveApiInputModel: BaseModel {
    var companyId: Int?
    var workspaceId: Int?
    var groupId: Int?
    var leaveTypeId: Int?
    var projectName: String?
    var checkoutTime: String?
    var checkinTime: String?
    var reason: String?
    var compensationAttributes = CompensationAttribute()

    init() {
    }

    required public init?(map: Map) {
    }

    public func mapping(map: Map) {
        workspaceId <- map["workspace_id"]
        groupId <- map["group_id"]
        projectName <- map["project_name"]
        leaveTypeId <- map["leave_type_id"]
        checkoutTime <- map["checkout_time"]
        checkinTime <- map["checkin_time"]
        compensationAttributes <- map["compensation_attributes"]
        reason <- map["reason"]
        companyId <- map["company_id"]
    }
}

class CompensationAttribute: BaseModel {
    var compensationFrom: String?
    var compensationTo: String?

    init() {
    }

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        compensationFrom <- map["compensation_from"]
        compensationTo <- map["compensation_to"]
    }
}


