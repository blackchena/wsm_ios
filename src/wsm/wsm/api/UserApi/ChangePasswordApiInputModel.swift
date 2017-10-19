//
//  ChangePasswordApiInputModel.swift
//  wsm
//
//  Created by framgia on 10/19/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import ObjectMapper

public class ChangePasswordApiInputModel: BaseModel {
    var currentPassword: String?
    var newPassword: String?
    var confirmPassword: String?

    init() {
    }

    required public init?(map: Map) {
    }

    public func mapping(map: Map) {
        currentPassword <- map["current_password"]
        newPassword <- map["password"]
        confirmPassword <- map["password_confirmation"]
    }
}
