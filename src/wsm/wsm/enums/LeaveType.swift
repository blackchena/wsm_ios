//
//  LeaveType.swift
//  wsm
//
//  Created by framgia on 9/28/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation

public enum TrackingTimeType: String {
    case checkInM = "checkin_morning"
    case checkInA = "checkin_afternoon"
    case checkIn = "checkin"
    case checkOut = "checkout"
    case both = "both"
}

public enum CompensationKind: String {
    case require = "is_require"
    case notRequire = "not_require"
}

public enum TrackingCheckOutTypeId: Int {
    case leaveEarlyM = 2
    case leaveEarlyA = 14
    case leaveEarlyWomanM = 16
    case leaveEarlyWomanA = 17
}

