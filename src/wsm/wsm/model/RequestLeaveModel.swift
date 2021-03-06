//
//  RequestOtModel.swift
//  wsm
//
//  Created by framgia on 9/27/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import ObjectMapper
import InAppLocalize

class RequestLeaveModel: BaseModel {

    var id: Int?
    var user: UserProfileModel?
    var group: UserGroup?
    var company: CompanyModel?
    var workspace: UserWorkSpace?
    var checkInTime: Date?
    var checkOutTime: Date?
    var reason: String?
    var status: RequestStatus?
    var projectName: String?
    var leaveType: LeaveTypeModel?
    var compensation: CompensationAttribute?
    var createAt: Date?
    var handleByGroupName: String?
    var canApproveRejectRequest: Bool?

    init() {
    }

    required init?(map: Map) {

    }
    
    public func mapping(map: Map) {
        let iosDateTransform = WSMDateTransform(formatFromJson: DateFormatType.isoDateTimeMilliSec,
                                                formatToJson: DateFormatType.isoDateTimeMilliSec)

        id <- map["id"]
        user <- map["user"]
        group <- map["group"]
        company <- map["company"]
        workspace <- map["workspace"]
        checkInTime <- (map["checkin_time"], iosDateTransform)
        checkOutTime <- (map["checkout_time"], iosDateTransform)
        reason <- map["reason"]
        status <- map["status"]
        projectName <- map["project_name"]
        leaveType <- map["leave_type"]
        compensation <- map["compensation"]
        createAt <- (map["created_at"], iosDateTransform)
        handleByGroupName <- map["handle_by_group_name"]
        canApproveRejectRequest <- map["can_approve_reject_request"]
    }

    func getRequestTimeString() -> String? {
        guard let leaveType = UserServices.findLocalLeaveTypeSetting(id: leaveType?.id) else {
            return nil
        }

        let dateFormat = LocalizationHelper.shared.localized("date_time_format")

        switch leaveType.trackingTimeType {
        case .both:
            if let checkInTime = checkInTime, let checkOutTime = checkOutTime {
                return "\(checkInTime.toString(dateFormat: dateFormat)) - \(checkOutTime.toString(dateFormat: AppConstant.onlyTimeFormat))"
            }
        case .checkIn,
             .checkInM,
             .checkInA:
            if let checkInTime = checkInTime {
                return checkInTime.toString(dateFormat: dateFormat)
            }
        case .checkOut:
            if let checkOutTime = checkOutTime {
                return checkOutTime.toString(dateFormat: dateFormat)
            }
        }

        return nil
    }

    func toApiInputModel() -> RequestLeaveApiInputModel {
        let model = RequestLeaveApiInputModel()
        model.id = id
        model.workspaceId = workspace?.id
        model.groupId = group?.id
        model.projectName = projectName
        model.leaveTypeId = leaveType?.id
        model.checkinTime = checkInTime?.toString(dateFormat: AppConstant.requestDateFormat)
        model.checkoutTime = checkOutTime?.toString(dateFormat: AppConstant.requestDateFormat)
        model.compensationAttributes = compensation ?? CompensationAttribute()
        model.reason = reason
        model.group = group
        model.leaveType = leaveType
        model.workspace = workspace
        return model
    }
}
