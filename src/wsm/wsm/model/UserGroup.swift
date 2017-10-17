//
//  UserGroup.swift
//  wsm
//
//  Created by framgia on 9/27/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import ObjectMapper

class UserGroup: BaseModel {
    var id: Int?
    var name: String?
    var fullName: String?
    var description: String?
    var closestParentId: Int?
    var parentPath: [Int]?
    var groupType: String?
    var image: String?

    required init?(map: Map) {
    }

    init() {}

    public func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        fullName <- map["full_name"]
        description <- map["description"]
        closestParentId <- map["closest_parent_id"]
        parentPath <- map["parent_path"]
        groupType <- map["group_type"]
        image <- map["image"]
    }
}
