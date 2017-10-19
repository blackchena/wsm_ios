//
//  UserNationModel.swift
//  wsm
//
//  Created by framgia on 10/19/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import ObjectMapper

class UserNationModel: BaseModel {

    var id: Int?
    var userId: Int?
    var nationId: Int?
    var code: String?
    var name: String?

    required init?(map: Map) {
    }

    public func mapping(map: Map) {
        id <- map["id"]
        userId <- map["user_id"]
        nationId <- map["nation_id"]
        code <- map["code"]
        name <- map["name"]
    }
}
