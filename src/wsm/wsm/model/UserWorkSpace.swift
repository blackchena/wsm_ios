//
//  UserWorkSpace.swift
//  wsm
//
//  Created by framgia on 9/27/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import ObjectMapper

class UserWorkSpace: BaseModel {
    var id: Int?
    var name: String?
    var shifts = [WorkSpaceShift]()
    var description: String?
    var openTime: String?
    var closeTime: String?
    var image: String?
    var timezone: String?
    var status: Bool?

    init() {}

    required init?(map: Map) {
    }

    public func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        shifts <- map["shifts"]
        description <- map["description"]
        openTime <- map["open_time"]
        closeTime <- map["close_time"]
        image <- map["image"]
        timezone <- map["timezone"]
        status <- map["status"]
    }
}


