//
//  ListRequestOffApiOutModel.swift
//  wsm
//
//  Created by framgia on 10/13/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import ObjectMapper

class ListRequestOffApiOutModel: ResponseData {
    var listRequestOff = [RequestOffModel]()

    override func mapping(map: Map) {
        super.mapping(map: map)
        listRequestOff <- map["data"]
    }
}
