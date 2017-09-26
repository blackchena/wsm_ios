//
//  RequestOtModel.swift
//  wsm
//
//  Created by framgia on 9/26/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import ObjectMapper

class RequestOtModel: BaseModel {
    var workspaceId: Int?
    var groupId: Int?
    var projectName: String?
    var fromTime: String?
    var endTime: String?
    var reason: String?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        workspaceId <- map["workspace_id"]
        groupId <- map["group_id"]
        projectName <- map["project_name"]
        fromTime <- map["from_time"]
        endTime <- map["end_time"]
        reason <- map["reason"]
    }
}
