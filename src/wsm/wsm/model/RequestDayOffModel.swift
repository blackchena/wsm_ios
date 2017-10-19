//
//  RequestDayOffModel.swift
//  wsm
//
//  Created by Lê Thanh Quang on 10/6/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import ObjectMapper
import InAppLocalize

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

    var offNoSalaryFrom = RequestDayOffFromModel(isHaveSalary: false)
    var offNoSalaryTo = RequestDayOffToModel(isHaveSalary: false)

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
    var requestDayOffTypes: [RequestDayOffTypeModel]?
    var handleByGroupName: String?
    var dayOffType: String?
    var canApproveRejectRequest: Bool?

    init(){

    }

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        map.shouldIncludeNilValues = true
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

    func getRequestTimeString() -> String {
        let dateFormat = LocalizationHelper.shared.localized("date_format")
        var result = ""
        if let offHaveSalaryFromDate = offHaveSalaryFrom?.offPaidFrom,
            let offHaveSalaryFromPeriod = offHaveSalaryFrom?.paidFromPeriod {

            result = offHaveSalaryFromDate.toString(dateFormat: dateFormat) + " " + offHaveSalaryFromPeriod.rawValue

            if let offNoSalaryFromDate = offNoSalaryFrom.offPaidFrom ,
                let offNoSalaryFromPeriod = offNoSalaryFrom.paidFromPeriod,
                offNoSalaryFromDate < offHaveSalaryFromDate
                    || (offNoSalaryFromDate == offHaveSalaryFromDate && offNoSalaryFromPeriod == .am) {

                result = offNoSalaryFromDate.toString(dateFormat: dateFormat) + " " + offNoSalaryFromPeriod.rawValue
            }
        } else if let offNoSalaryFromDate = offNoSalaryFrom.offPaidFrom ,
            let offNoSalaryFromPeriod = offNoSalaryFrom.paidFromPeriod {

            result = offNoSalaryFromDate.toString(dateFormat: dateFormat) + " " + offNoSalaryFromPeriod.rawValue
        }

        result += " → "

        if let offHaveSalaryToDate = offHaveSalaryTo?.offPaidTo,
            let offHaveSalaryToPeriod = offHaveSalaryTo?.paidToPeriod {

            var toDate = offHaveSalaryToDate.toString(dateFormat: dateFormat) + " " + offHaveSalaryToPeriod.rawValue

            if let offNoSalaryToDate = offNoSalaryTo.offPaidTo ,
                let offNoSalaryToPeriod = offNoSalaryTo.paidToPeriod,
                offNoSalaryToDate > offHaveSalaryToDate
                    || (offNoSalaryToDate == offHaveSalaryToDate && offNoSalaryToPeriod == .pm) {

                toDate = offNoSalaryToDate.toString(dateFormat: dateFormat) + " " + offNoSalaryToPeriod.rawValue
            }
            result += toDate
        } else if let offNoSalaryToDate = offNoSalaryTo.offPaidTo ,
            let offNoSalaryToPeriod = offNoSalaryTo.paidToPeriod {

            result += offNoSalaryToDate.toString(dateFormat: dateFormat) + " " + offNoSalaryToPeriod.rawValue
        }

        return result
    }
}

class RequestDayOffFromModel: BaseModel {

    var offPaidFrom: Date?
    var paidFromPeriod: TimeConventionType?
    var isHaveSalary = true

    private let offPaidFromHaveSalaryKey = "off_paid_from"
    private let paidFromPeriodHaveSalaryKey = "paid_from_period"
    private let offPaidFromNoSalaryKey = "off_from"
    private let paidFromPeriodNoSalaryKey = "off_from_period"

    init(isHaveSalary: Bool, paidFromPeriod: TimeConventionType = .am) {
        self.isHaveSalary = isHaveSalary
        self.paidFromPeriod = paidFromPeriod
    }

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        map.shouldIncludeNilValues = true

        let customDateTransform = WSMDateTransform(formatFromJson: .custom("dd/MM/yyyy"), formatToJson: .custom("dd/MM/yyyy"))

        if map.mappingType == .fromJSON {
            let data = map.JSON
            isHaveSalary = data.keys.contains(offPaidFromHaveSalaryKey)
        }

        offPaidFrom <- (map[isHaveSalary ? offPaidFromHaveSalaryKey : offPaidFromNoSalaryKey], customDateTransform)
        paidFromPeriod <- map[isHaveSalary ? paidFromPeriodHaveSalaryKey : paidFromPeriodNoSalaryKey]
    }

    func toString() -> String {
        return String(format: "%@ %@", offPaidFrom?.toString(dateFormat: AppConstant.onlyDateFormat) ?? "", (paidFromPeriod ?? TimeConventionType.am).rawValue)
    }
}

class RequestDayOffToModel: BaseModel {

    var offPaidTo: Date?
    var paidToPeriod: TimeConventionType?
    var isHaveSalary = false

    private let offPaidToHaveSalaryKey = "off_paid_to"
    private let paidToPeriodHaveSalaryKey = "paid_to_period"
    private let offPaidToNoSalaryKey = "off_to"
    private let paidToPeriodNoSalaryKey = "off_to_period"

    init(isHaveSalary: Bool, paidToPeriod: TimeConventionType = .am) {
        self.isHaveSalary = isHaveSalary
        self.paidToPeriod = paidToPeriod
    }

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        map.shouldIncludeNilValues = true

        let customDateTransform = WSMDateTransform(formatFromJson: .custom("dd/MM/yyyy"), formatToJson: .custom("dd/MM/yyyy"))

        if map.mappingType == .fromJSON {
            let data = map.JSON
            isHaveSalary = data.keys.contains(offPaidToHaveSalaryKey)
        }

        offPaidTo <- (map[isHaveSalary ? offPaidToHaveSalaryKey : offPaidToNoSalaryKey], customDateTransform)
        paidToPeriod <- map[isHaveSalary ? paidToPeriodHaveSalaryKey : paidToPeriodNoSalaryKey]
    }

    func toString() -> String {
        return String(format: "%@ %@", offPaidTo?.toString(dateFormat: AppConstant.onlyDateFormat) ?? "", (paidToPeriod ?? TimeConventionType.am).rawValue)
    }
}

class RequestDayOffTypeModel: BaseModel {

    var id: Int? // "special_dayoff_settings" -> "dayoff_setting_id"
    var specialDayOffSettingId: Int? // "special_dayoff_settings" -> "id"
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
        map.shouldIncludeNilValues = true

        id <- map["special_dayoff_setting_id"]
        specialDayOffSettingId <- map["special_dayoff_setting_id"]
        numberDayOff <- map["number_dayoff"]
        destroy <- map["_destroy"]
    }
}
