//
//  ListRequestOTApiOutModel.swift
//  wsm
//
//  Created by DaoLQ on 10/10/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import ObjectMapper

class ListRequestOTApiOutModel: ResponseData {
    var listRequestOts = [RequestOtModel]()
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        listRequestOts <- map["data"]
    }
}
