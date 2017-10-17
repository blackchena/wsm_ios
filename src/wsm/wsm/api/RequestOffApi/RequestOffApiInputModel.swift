//
//  RequestOffApiInputModel.swift
//  wsm
//
//  Created by Lê Thanh Quang on 10/9/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import ObjectMapper

class RequestOffApiInputModel: BaseModel {

    var requestOffDetail: RequestOffDetailApiInputModel?

    required public init?(map: Map) {
    }

    public func mapping(map: Map) {
        requestOffDetail <- map["request_off"]
    }
}

class RequestOffDetailApiInputModel: BaseModel {

    var projectName: String?
    var positionName: String?
    var workSpaceId: Int = 0
    var groupId: Int = 0
    var numberDayOffNormal: Float = 0

    /**
     * Must convert all value on "special_dayoff_settings" to this with "key" is "special_dayoff_settings" -> "id"
    */
    var requestDayOffTypesAttributes: [RequestDayOffTypeModel]?

    var offHaveSalaryFrom = RequestDayOffFromModel()
    var offHaveSalaryTo = RequestDayOffToModel()

    var offNoSalaryFrom = RequestDayOffFromModel()
    var offNoSalaryTo = RequestDayOffToModel()

    var reason: String = ""

    init() {}

    required public init?(map: Map) {
    }

    public func mapping(map: Map) {
        projectName <- map["project_name"]
        positionName <- map["position_name"]
        workSpaceId <- map["workspace_id"]
        groupId <- map["group_id"]
        numberDayOffNormal <- map["number_dayoff_normal"]
        requestDayOffTypesAttributes <- map["request_dayoff_types_attributes"]

        offHaveSalaryFrom <- map["off_have_salary_from"]
        offHaveSalaryTo <- map["off_have_salary_to"]
        offNoSalaryFrom <- map["off_no_salary_from"]
        offNoSalaryTo <- map["off_no_salary_to"]

        reason <- map["reason"]
    }

}
