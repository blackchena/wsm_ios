//
//  TimeSheetDayOffType.swift
//  wsm
//
//  Created by Lê Thanh Quang on 9/27/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit

enum TimeSheetDayOffType: String {

    case none = ""
    case typeP = "P"
    case typeRo = "R"

    var dayOffColor: UIColor? {
        switch self {
        case .typeP:
            return UIColor(hexString: "#a2e796")
        case .typeRo:
            return UIColor(hexString: "#ff875b")
        case .none:
            return nil
        }
    }
}
