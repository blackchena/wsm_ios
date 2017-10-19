//
//  AddressModel.swift
//  wsm
//
//  Created by framgia on 10/19/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import ObjectMapper

class AddressModel: BaseModel {

    var id: Int?
    var distanceFromOffice: Float?
    var placeOfBirth: String?
    var currentAddress: String?
    var permanentAddress: String?

    required init?(map: Map) {
    }

    public func mapping(map: Map) {
        id <- map["id"]
        distanceFromOffice <- map["distance_from_office"]
        placeOfBirth <- map["place_of_birth"]
        currentAddress <- map["current_address"]
        permanentAddress <- map["permanent_address"]
    }
}
