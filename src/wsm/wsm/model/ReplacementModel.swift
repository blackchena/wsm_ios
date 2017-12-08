//
//  TheReplacementModel.swift
//  wsm
//
//  Created by Mac Pro on 12/6/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import ObjectMapper

enum ReplacementContract: String {
    case email = "email"
    case avatar = "avatar"
    case contractDate = "contract_date"
    case workSpaces = "workspaces"
    case startProbationDate = "start_probation_date"
    case endProbationDate = "end_probation_date"
    case staffTypeId = "staff_type_id"
    case id = "id"
    case employeeCode = "employee_code"
    case name = "name"
    case role = "role"
    case positionId = "position_id"
    case status = "status"
    case authenticationToken = "authentication_token"
}

class ReplacementModel: UserProfileModel {
    
    var role: String?
    var positionId: Int?
    var status: String?
    var staffTypeId: Int?
    var authenticationToken: String?
    
    override func mapping(map: Map) {
        let iosDateTransform = WSMDateTransform(
            formatFromJson: DateFormatType.isoDate,
            formatToJson: DateFormatType.isoDate
        )
        
        email <- map[ReplacementContract.email.rawValue]
        contractDate <- (map[ReplacementContract.contractDate.rawValue], iosDateTransform)
        avatar <- map[ReplacementContract.avatar.rawValue]
        workSpaces <- map[ReplacementContract.workSpaces.rawValue]
        startProbationDate <- (map[ReplacementContract.startProbationDate.rawValue], iosDateTransform)
        endProbationDate <- (map[ReplacementContract.endProbationDate.rawValue], iosDateTransform)
        staffTypeId <- map[ReplacementContract.staffTypeId.rawValue]
        id <- map[ReplacementContract.id.rawValue]
        employeeCode <- map[ReplacementContract.employeeCode.rawValue]
        name <- map[ReplacementContract.name.rawValue]
        role <- map[ReplacementContract.role.rawValue]
        positionId <- map[ReplacementContract.positionId.rawValue]
        status <- map[ReplacementContract.status.rawValue]
        authenticationToken <- map[ReplacementContract.authenticationToken.rawValue]
    }
    
    func mapId(map: Map) {
        id <- map["replacement_id"]
    }

}
