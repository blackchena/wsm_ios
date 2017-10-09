//
//  CreateRequestOtApiOutModel.swift
//  wsm
//
//  Created by framgia on 9/27/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import ObjectMapper

class ListRequestLeaveApiOutModel: ResponseData {
    var listRequestLeaves = [RequestLeaveModel]()

    override func mapping(map: Map) {
        super.mapping(map: map)
        listRequestLeaves <- map["data"]
    }
}
