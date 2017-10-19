//
//  GeneralInfoModel.swift
//  wsm
//
//  Created by framgia on 10/19/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import ObjectMapper

class GeneralInfoModel: BaseModel {

    var id: Int?
    var gender: String?
    var birthday: Date?
    var personalMail: String?
    var homePhoneNumber: String?
    var nationality: String?
    var marriedStatus: String?
    var numberOfChildrent: Int?

    required init?(map: Map) {
    }

    public func mapping(map: Map) {
        let iosDateTransform = WSMDateTransform(formatFromJson: DateFormatType.isoDateTimeMilliSec,
                                                formatToJson: DateFormatType.isoDateTimeMilliSec)
        id <- map["id"]
        gender <- map["gender"]
        birthday <- (map["birthday"], iosDateTransform)
        personalMail <- map["personal_mail"]
        homePhoneNumber <- map["home_phone_number"]
        nationality <- map["nationality"]
        marriedStatus <- map["married_status"]
        numberOfChildrent <- map["number_of_childrent"]
    }
}
