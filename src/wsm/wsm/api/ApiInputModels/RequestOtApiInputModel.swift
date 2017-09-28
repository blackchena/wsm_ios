//
//  RequestOtModel.swift
//  wsm
//
//  Created by framgia on 9/26/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import ObjectMapper

class RequestOtApiInputModel: BaseModel {
    var workspaceId: Int?
    var groupId: Int?
    var projectName: String?
    var fromTime: String?
    var endTime: String?
    var reason: String?

    init() {
    }

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

    func getOtTime() -> String {
        if let from = endTime?.toDate(dateFormat: Date.dateTimeFormat),
            let to = fromTime?.toDate(dateFormat: Date.dateTimeFormat)
        {
            let duration = from.timeIntervalSince(to)
            return String(format: "%.2f", duration / 3600)
        }
        return ""
    }

    func isValid() -> Bool {
        if (projectName ?? "").isEmpty
            || (fromTime ?? "").isEmpty
            || (endTime ?? "").isEmpty
            || (reason ?? "").isEmpty
            || workspaceId == nil
            || groupId == nil {
            return false
        }
        return true
    }
}
