//
//  ManageRequestInputApi.swift
//  wsm
//
//  Created by DaoLQ on 10/31/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import ObjectMapper

public class ManageRequestApiInputModel: BaseModel {
    var page: Int = 1
    var keyword: String?
    var status: Int? = 0
    var timeFrom: String?
    var timeTo: String?
    
    init() {
    }
    
    public required init?(map: Map) {
    }
    
    public func mapping(map: Map) {        
        page <- map["page"]
        keyword <- map["q[user_name_cont]"]
        status <- map["q[status_eq]"]
        timeFrom <- map["q[off_have_salary_from][off_paid_from]"]
        timeTo <- map["q[off_have_salary_from][off_paid_to]"]
    }
}
