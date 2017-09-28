//
//  UserWorkSpace.swift
//  wsm
//
//  Created by framgia on 9/27/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import ObjectMapper
import AFDateHelper

class UserWorkSpace: BaseModel {
    var id: Int?
    var name: String?

    required init?(map: Map) {
    }

    public func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
}
