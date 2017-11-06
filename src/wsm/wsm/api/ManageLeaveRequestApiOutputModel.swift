//
//  ManageRequestApiOutputModel.swift
//  wsm
//
//  Created by DaoLQ on 10/31/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import ObjectMapper

class ManageLeaveRequestApiOutputModel: ResponseData {
    var leaveRequests = [RequestLeaveModel]()
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        leaveRequests <- map["data"]
    }
}
