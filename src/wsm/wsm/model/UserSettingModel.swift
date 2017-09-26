//
//  UserSettingModel.swift
//  wsm
//
//  Created by Lê Thanh Quang on 9/25/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import ObjectMapper
import AFDateHelper

class UserSettingModel: BaseModel {

    var id: Int?
    var userId: Int?
    var workSpaceDefault: Int?
    var groupDefault: Int?
    var notificationSetting: NotifySettingModel?
    var emailSetting: NotifySettingModel?
    var language: String?
    var createdAt: Date?
    var updateAt: Date?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        let iosDateTransform = WSMDateTransform(formatFromJson: DateFormatType.isoDate,
                                                formatToJson: DateFormatType.isoDate)

        id <- map["id"]
        userId <- map["user_id"]
        workSpaceDefault <- map["workspace_default"]
        groupDefault <- map["group_default"]
        notificationSetting <- map["notification_setting"]
        emailSetting <- map["email_setting"]
        language <- map["language"]
        createdAt <- (map["created_at"], iosDateTransform)
        updateAt <- (map["updated_at"], iosDateTransform)
    }
}
