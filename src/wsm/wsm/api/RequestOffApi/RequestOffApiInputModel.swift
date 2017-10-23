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

    init(requestOffDetail: RequestOffDetailApiInputModel) {
        self.requestOffDetail = requestOffDetail
    }

    required public init?(map: Map) {

    }

    public func mapping(map: Map) {
        map.shouldIncludeNilValues = true
        requestOffDetail <- map["request_off"]
    }
}

class RequestOffDetailApiInputModel: BaseModel {

    var id: Int?
    var projectName: String?
    var positionName: String?
    var workSpaceId: Int = 0
    var groupId: Int = 0
    var numberDayOffNormal: Float = 0

    /**
     * Must convert all value on "special_dayoff_settings" to this with "key" is "special_dayoff_settings" -> "id"
    */
    var requestDayOffTypesAttributes: [RequestDayOffTypeModel]?

    //This property use for EDIT request
    var requestDayoffType: [RequestDayOffTypeModel]?

    var offHaveSalaryFrom = RequestDayOffFromModel(isHaveSalary: true)
    var offHaveSalaryTo = RequestDayOffToModel(isHaveSalary: true)

    var offNoSalaryFrom = RequestDayOffFromModel(isHaveSalary: false)
    var offNoSalaryTo = RequestDayOffToModel(isHaveSalary: false)

    var reason: String = ""

    init() {}

    required public init?(map: Map) {

    }

    public func mapping(map: Map) {
        map.shouldIncludeNilValues = true
        id <- map["id"]
        projectName <- map["project_name"]
        positionName <- map["position_name"]
        workSpaceId <- map["workspace_id"]
        groupId <- map["group_id"]
        numberDayOffNormal <- map["number_dayoff_normal"]

        requestDayOffTypesAttributes <- map["request_dayoff_types_attributes"]

        requestDayoffType <- map["request_dayoff_type"]

        offHaveSalaryFrom <- map["off_have_salary_from"]
        offHaveSalaryTo <- map["off_have_salary_to"]

        offNoSalaryFrom <- map["off_no_salary_from"]
        offNoSalaryTo <- map["off_no_salary_to"]

        reason <- map["reason"]
    }

}
