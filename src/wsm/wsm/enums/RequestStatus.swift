//
//  RequestStatus.swift
//  wsm
//
//  Created by framgia on 10/6/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import InAppLocalize

enum RequestStatus: String {
    case pending
    case approve
    case discard
    case forward
    case cancel

    func toInt() -> Int {
        switch self {
        case .pending:
            return 0
        case .approve:
            return 1
        case .discard:
            return 2
        case .forward:
            return 3
        case .cancel:
            return 4
        }
    }

    func localizedString() -> String {
        return LocalizationHelper.shared.localized(self.rawValue)
    }

    func getColor() -> UIColor {
        switch self {
        case .pending:
            return UIColor.pendingColor
        case .approve:
            return UIColor.approveColor
        case .discard:
            return UIColor.discardColor
        case .forward:
            return UIColor.forwardColor
        case .cancel:
            return UIColor.cancelColor
        }
    }
}
