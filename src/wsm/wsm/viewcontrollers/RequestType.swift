//
//  RequestType.swift
//  wsm
//
//  Created by DaoLQ on 10/30/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import InAppLocalize

enum RequestType {
    case others
    case overTime
    case dayOff
    
    var title: String? {
        switch self {
        case .others:
            return LocalizationHelper.shared.localized("manage_request_others")
        case .overTime:
            return LocalizationHelper.shared.localized("manage_request_overtime")
        case .dayOff:
            return LocalizationHelper.shared.localized("manage_request_day_off")
        }
    }
}
