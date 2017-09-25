//
//  UserApiOutputModel.swift
//  wsm
//
//  Created by Lê Thanh Quang on 9/22/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import ObjectMapper

class UserApiOutputModel: ResponseData {
    var userData: UserModel?

    override func mapping(map: Map) {
        super.mapping(map: map)
        userData <- map["data"]
    }
}
