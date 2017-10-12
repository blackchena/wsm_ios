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
    var compensationFrom: Date?
    var compensationTo: Date?

    init() {
    }

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        let iosDateTransform = WSMDateTransform(formatFromJson: DateFormatType.isoDateTimeMilliSec,
                                                formatToJson: DateFormatType.custom(AppConstant.requestDateFormat))
        id <- map["id"]
        compensationFrom <- (map["compensation_from"], iosDateTransform)
        compensationTo <- (map["compensation_to"], iosDateTransform)
    }
}
