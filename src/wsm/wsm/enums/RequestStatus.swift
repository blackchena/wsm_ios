//
//  RequestStatus.swift
//  wsm
//
//  Created by framgia on 10/6/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation

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
}
