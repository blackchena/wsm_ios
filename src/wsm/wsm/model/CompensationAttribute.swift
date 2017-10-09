//
//  CompensationAttribute.swift
//  wsm
//
//  Created by framgia on 10/6/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import ObjectMapper

class CompensationAttribute: BaseModel {
    var id: Int?
    var compensationFrom: String?
    var compensationTo: String?

    init() {
    }

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        id <- map["id"]
        compensationFrom <- map["compensation_from"]
        compensationTo <- map["compensation_to"]
    }
}
