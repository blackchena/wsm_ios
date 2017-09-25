//
//  LoginUser.swift
//  wsm
//
//  Created by nguyen.van.hung on 6/30/17.
//  Copyright © 2017 nguyen.van.hung. All rights reserved.
//

import Foundation
import ObjectMapper

final class LoginModel: BaseModel {

    var authenToken: String?
    var isManager: Bool?
    var userId: Int?

    required init?(map: Map) {

    }

    public func mapping(map: Map) {
        authenToken <- map["authen_token"]
        isManager <- map["is_manager"]
        userId <- map["user_info.id"]
    }
}
