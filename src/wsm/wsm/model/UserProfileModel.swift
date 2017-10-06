//  UserProfile.swift
//  wsm
//
//  Created by framgia on 9/19/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import ObjectMapper
//import AFDateHelper

class UserProfileModel: BaseModel {

    var email: String?
    var gender: String?
    var birthday: Date?
    var company: CompanyModel?
    var contractDate: Date?
    var avatar: String?
    var workSpaces: [UserWorkSpace]?
    var groups: [UserGroup]?
    var startProbationDate: Date?
    var endProbationDate: Date?
    var individualCode: String?
    var namePosition: String?
    var nameStaffType: String?
    var id: Int?
    var employeeCode: String?
    var name: String?
    var special = UserSpecial.normal

    var isManager: Bool?

    required init?(map: Map) {
    }

    public func mapping(map: Map) {

        let defaultDateTransform = WSMDateTransform()
        let iosDateTransform = WSMDateTransform(formatFromJson: DateFormatType.isoDate,
                                                formatToJson: DateFormatType.isoDate)

        email <- map["email"]
        gender <- map["gender"]
        birthday <- (map["birthday"], defaultDateTransform)
        company <- map["company"]
        contractDate <- (map["contract_date"], iosDateTransform)
        avatar <- map["avatar"]
        workSpaces <- map["workspaces"]
        groups <- map["groups"]
        startProbationDate <- (map["start_probation_date"], iosDateTransform)
        endProbationDate <- (map["end_probation_date"], iosDateTransform)
        individualCode <- map["individual_code"]
        namePosition <- map["name_position"]
        nameStaffType <- map["name_staff_type"]
        special <- map["special"]
        id <- map["id"]
        employeeCode <- map["employee_code"]
        name <- map["name"]
    }

    func getAvatarURL() -> URL? {
        if let avatarUrl = avatar {
            return URL(string: ApiProvider.baseURLString + avatarUrl)
        }
        return nil
    }
}
