//
//  RequestDayOffModel.swift
//  wsm
//
//  Created by Lê Thanh Quang on 10/6/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import ObjectMapper

class RequestDayOffModel: BaseModel {

    var id: Int?
    var projectName: String?
    var positionName: String?

    var workSpace: UserWorkSpace?

    var numberDayOffNormal: Int?
    var reason: String?
    var addressContact: Any?

    var offHaveSalaryFrom: RequestDayOffFromModel?
    var offHaveSalaryTo: RequestDayOffToModel?

    var offNoSalaryFrom: RequestDayOffFromModel?
    var offNoSalaryTo: RequestDayOffToModel?

    var user: UserProfileModel?
    var group: UserGroup?
    var status: Any?
    var company: CompanyModel?
    var phoneNumber: Any?
    var partHandover: Any?
    var workHandover: Any?
    var userHandover: Any?
    var takenDayOffs: Any?
    var approver: Any?
    var createdAt: Date?
    var requestDayOffTypes: [RequestDayOffTypeModel]?
    var handleByGroupName: String?
    var dayOffType: String?
    var canApproveRejectRequest: Bool?

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
        offHaveSalaryFrom <- map["off_have_salary_from"]
        offHaveSalaryTo <- map["off_have_salary_to"]
        offNoSalaryFrom <- map["off_no_salary_from"]
        offNoSalaryTo <- map["off_no_salary_to"]
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
        requestDayOffTypes <- map["request_dayoff_type"]
        handleByGroupName <- map["handle_by_group_name"]
        dayOffType <- map["day_off_type"]
        canApproveRejectRequest <- map["can_approve_reject_request"]
    }
}

class RequestDayOffFromModel: BaseModel {

    var offPaidFrom: Date?
    var paidFromPeriod: TimeConventionType = .am

    init() {}

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        let customDateTransform = WSMDateTransform(formatFromJson: .custom("dd/MM/yyyy"), formatToJson: .custom("dd/MM/yyyy"))

        offPaidFrom <- (map["off_paid_from"], customDateTransform)
        paidFromPeriod <- map["paid_from_period"]
    }
}

class RequestDayOffToModel: BaseModel {

    var offPaidTo: Date?
    var paidToPeriod: TimeConventionType = .am

    init() {}

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        let customDateTransform = WSMDateTransform(formatFromJson: .custom("dd/MM/yyyy"), formatToJson: .custom("dd/MM/yyyy"))

        offPaidTo <- (map["off_paid_to"], customDateTransform)
        paidToPeriod <- map["paid_to_period"]
    }
}

class RequestDayOffTypeModel: BaseModel {
    
    var id: Int? // "special_dayoff_settings" -> "id"
    var specialDayOffSettingId: Int? // "special_dayoff_settings" -> "dayoff_setting_id"
    var numberDayOff: Float?
    var destroy: Bool? // have request -> false else true

    init(id: Int?, specialDayOffSettingId: Int?, numberDayOff: Float?, destroy: Bool?) {
        self.id = id
        self.specialDayOffSettingId = specialDayOffSettingId
        self.numberDayOff = numberDayOff
        self.destroy = destroy
    }

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        id <- map["special_dayoff_setting_id"]
        specialDayOffSettingId <- map["special_dayoff_setting_id"]
        numberDayOff <- map["number_dayoff"]
        destroy <- map["_destroy"]
    }
}
