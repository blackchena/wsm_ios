//
//  ManageOvertimeRequestApiOutputModel.swift
//  wsm
//
//  Created by DaoLQ on 11/2/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import ObjectMapper

class ManageOvertimeRequestApiOutputModel: ResponseData {
    var overtimeRequests = [RequestOtModel]()
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        overtimeRequests <- map["data"]
    }
}
