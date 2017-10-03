//
//  CompanyModel.swift
//  wsm
//
//  Created by Lê Thanh Quang on 9/29/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import ObjectMapper

class CompanyModel: BaseModel {

    var id: Int?
    var name: String?
    var status: String?
    var cutOffDate: Int?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        status <- map["status"]
        cutOffDate <- map["cutoff_date"]
    }
}
