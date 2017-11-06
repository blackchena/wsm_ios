//
//  ManageOffRequestApiOutputModel.swift
//  wsm
//
//  Created by DaoLQ on 11/2/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import ObjectMapper

class ManageOffRequestApiOutputModel: ResponseData {
    var offRequests = [RequestDayOffModel]()
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        offRequests <- map["data"]
    }
}
