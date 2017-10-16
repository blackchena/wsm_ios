//
//  RequestOffModel.swift
//  wsm
//
//  Created by framgia on 10/13/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import ObjectMapper

class RequestOffModel: BaseModel {

    var id: Int?
    var projectName: String?
    var positionName: String?

    var workSpace: UserWorkSpace?

    var numberDayOffNormal: Int?
    var reason: String?
    var addressContact: Any?

    var user: UserProfileModel?
    var group: UserGroup?
    var status: RequestStatus?
    var company: CompanyModel?
    var phoneNumber: Any?
    var partHandover: Any?
    var workHandover: Any?
    var userHandover: Any?
    var takenDayOffs: Any?
    var approver: Any?
    var createdAt: Date?
    var handleByGroupName: String?
    var dayOffType: String?
    var canApproveRejectRequest: Bool?

    init(){

    }

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        let isoMilliDateTransform = WSMDateTransform()
        id <- map["id"]
        projectName <- map["project_name"]
        positionName <- map["position_name"]
        workSpace <- map["workspace"]
        numberDayOffNormal <- map["number_dayoff_normal"]
        reason <- map["reason"]
        addressContact <- map["address_contact"]
        user <- map["user"]
        group <- map["group"]
        status <- map["status"]
        phoneNumber <- map["phone_number"]
        partHandover <- map["part_handover"]
        workHandover <- map["work_handover"]
        userHandover <- map["user_handover"]
        takenDayOffs <- map["taken_dayoffs"]
        approver <- map["approver"]
        createdAt <- (map["created_at"], isoMilliDateTransform)
        handleByGroupName <- map["handle_by_group_name"]
        dayOffType <- map["day_off_type"]
        canApproveRejectRequest <- map["can_approve_reject_request"]
    }
}
