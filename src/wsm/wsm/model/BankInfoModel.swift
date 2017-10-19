//
//  BankInfoModel.swift
//  wsm
//
//  Created by framgia on 10/19/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import ObjectMapper

class BankInfoModel: BaseModel {

    var id: Int?
    var accountType: String?
    var bankname: String?
    var accountId: String?
    var taxCode: String?

    required init?(map: Map) {
    }

    public func mapping(map: Map) {
        id <- map["id"]
        accountType <- map["account_type"]
        bankname <- map["bank_name"]
        accountId <- map["account_id"]
        taxCode <- map["tax_code"]
    }
}
