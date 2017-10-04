//
//  UserSettingApiOutputModel.swift
//  wsm
//
//  Created by Lê Thanh Quang on 9/25/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import ObjectMapper

class UserSettingApiOutputModel: ResponseData {

    var userSetting: UserSettingModel?

    override func mapping(map: Map) {
        super.mapping(map: map)
        userSetting <- map["data"]
    }
}
