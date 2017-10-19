//
//  VehicleInfoModel.swift
//  wsm
//
//  Created by framgia on 10/19/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import ObjectMapper

class VehicleInfoModel: BaseModel {

    var id: Int?
    var vehicleType: String?
    var licensePlate: String?

    required init?(map: Map) {
    }

    public func mapping(map: Map) {
        id <- map["id"]
        vehicleType <- map["vehicle_type"]
        licensePlate <- map["license_plate"]
    }
}
