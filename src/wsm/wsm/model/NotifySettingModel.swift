//
//  NotifySettingModel.swift
//  wsm
//
//  Created by Lê Thanh Quang on 9/25/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import ObjectMapper

class NotifySettingModel: BaseModel {

    var workSpace: Bool?
    var group: Bool?
    var userSpecialType: Bool?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        workSpace <- map["Workspace"]
        group <- map["Group"]
        userSpecialType <- map["UserSpecialType"]
    }
}
