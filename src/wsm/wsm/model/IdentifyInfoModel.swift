//
//  IdentifyInfoModel.swift
//  wsm
//
//  Created by framgia on 10/19/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import ObjectMapper

class IdentifyInfoModel: BaseModel {

    var id: Int?
    var identifyType: String?
    var dateIssue: Date?
    var dateExpiry: Date?
    var placeIssue: String?
    var code: String?

    required init?(map: Map) {
    }

    public func mapping(map: Map) {
        let iosDateTransform = WSMDateTransform(formatFromJson: DateFormatType.isoDateTimeMilliSec,
                                                formatToJson: DateFormatType.isoDateTimeMilliSec)
        id <- map["id"]
        identifyType <- map["identify_type"]
        dateIssue <- (map["date_issue"], iosDateTransform)
        dateExpiry <- (map["date_expiry"], iosDateTransform)
        placeIssue <- map["place_issue"]
        code <- map["code"]
    }
}
