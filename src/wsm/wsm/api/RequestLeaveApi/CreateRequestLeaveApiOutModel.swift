//
//  CreateRequestOtApiOutModel.swift
//  wsm
//
//  Created by framgia on 9/27/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import ObjectMapper

class CreateRequestLeaveApiOutModel: ResponseData {
    var requestModel: RequestLeaveModel?

    override func mapping(map: Map) {
        super.mapping(map: map)
        requestModel <- map["data"]
    }
}
