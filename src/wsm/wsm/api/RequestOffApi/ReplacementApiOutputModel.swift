//
//  File.swift
//  wsm
//
//  Created by Mac Pro on 12/4/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import ObjectMapper

class ReplacementApiOutputModel: ResponseData {
    
    var replacements: [ReplacementModel]?
    private let dataKey = "data"
    override func mapping(map: Map) {
        super.mapping(map: map)
        replacements <- map[dataKey]
    }
}
