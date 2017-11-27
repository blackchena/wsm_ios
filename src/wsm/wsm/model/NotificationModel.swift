//
//  NotificationModel.swift
//  wsm
//
//  Created by framgia on 10/20/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import ObjectMapper

class NotificationModel: BaseModel {

    var id: Int?
    var trackableType = NotificationTrackableType.unidentified
    var trackableId: Int?
    var ownerType = NotificationOwnerType.user
    var owner: NotificationOwnerModel?
    var read: Bool?
    var enable: Bool?
    var message: String?
    var createAt: Date?
    var permission: Int?
    var trackableStatus = RequestStatus.forward

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        let iosDateTransform = WSMDateTransform(formatFromJson: DateFormatType.isoDateTimeMilliSec,
                                                formatToJson: DateFormatType.isoDateTimeMilliSec)
        id <- map["id"]
        trackableType <- map["trackable_type"]
        trackableId <- map["trackable_id"]
        ownerType <- map["owner_type"]
        owner <- map["owner_object"]
        read <- map["read"]
        enable <- map["enable"]
        message <- map["message"]
        createAt <- (map["created_at"], iosDateTransform)
        permission <- map["permission"]
        trackableStatus <- map["trackableStatus"]
    }
}

class NotificationOwnerModel: BaseModel {
    var id: Int?
    var name: String?
    var gender: String?
    var role: String?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        gender <- map["gender"]
        role <- map["role"]
    }
}
