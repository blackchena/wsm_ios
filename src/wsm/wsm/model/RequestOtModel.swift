//
//  RequestOtModel.swift
//  wsm
//
//  Created by framgia on 9/27/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import ObjectMapper

class RequestOtModel: BaseModel {
    
    var id: Int?
    var projectName:String?
    var fromTime: Date?
    var endTime: Date?
    var reason: String?
    var user: UserProfileModel?
    var group: UserGroup?
    var workSpace: UserWorkSpace?
    var approver: UserProfileModel?
    var createAt: Date?
    var status: RequestStatus?
    var handleBy: String?
    var canApproveRejectRequest: Bool?
    
    init() {
    }

    required init?(map: Map) {

    }
    
    public func mapping(map: Map) {
        let iosDateTransform = WSMDateTransform(formatFromJson: DateFormatType.isoDateTimeMilliSec,
                                                formatToJson: DateFormatType.isoDateTimeMilliSec)
        
        id <- map["id"]
        projectName <- map["project_name"]
        fromTime <- (map["from_time"],iosDateTransform)
        endTime <- (map["end_time"],iosDateTransform)
        reason <- map["reason"]
        user <- map["user"]
        group <- map["group"]
        workSpace <- map["workspace"]
        approver <- map["approver"]
        createAt <- (map["created_at"],iosDateTransform)
        status <- map["status"]
        handleBy <- map["handle_by_group_name"]
        canApproveRejectRequest <- map["can_approve_reject_request"]
    }
    
    func getTimeOtString() -> String? {
        if let fromTime = fromTime, let endTime = endTime {
            return (fromTime.toString(dateFormat: AppConstant.requestDateTimeFormat) + " → " + endTime.toString(dateFormat: AppConstant.requestDateTimeFormat))
        }
        return nil
    }
    
    func getTimeCreatedString() -> String? {
        if let createAtTime = createAt {
            return createAtTime.toString(dateFormat: AppConstant.requestDateTimeFormat)
        }
        return nil
    }
    
    func getStatusImage() -> UIImage? {
        guard let status = status else {
            return nil
        }
        var imageName = ""
        switch status {
        case .pending:
            imageName = "ic_status_pending"
        case .approve:
            imageName = "ic_accept_circle"
        case .discard:
            imageName = "ic_reject_red"
        case .forward:
            imageName = "ic_status_forwards"
        case .cancel:
            imageName = "ic_status_cancel"
        }
        return UIImage(named: imageName)
    }
    
    func getNumberHours() -> Float? {
        return fromTime?.getDurationWithSpecificTime(date: endTime)
    }
}
