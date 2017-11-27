//
//  NotificationTrackingType.swift
//  wsm
//
//  Created by framgia on 10/20/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation

enum NotificationTrackableType: String {

    case requestLeave = "RequestLeave"
    case requestOff = "RequestOff"
    case requestOt = "RequestOt"
    case unidentified = "unidentified"

    func getIcon() -> UIImage? {
        var imageName = ""
        switch self {
        case .requestLeave, .unidentified:
            imageName = "ic_request_leave"
        case .requestOff:
            imageName = "ic_request_off"
        case .requestOt:
            imageName = "ic_request_overtime"
        }

        return UIImage(named: imageName)
    }
}
