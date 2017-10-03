//
//  WSMDateTransform.swift
//  wsm
//
//  Created by Lê Thanh Quang on 9/21/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import ObjectMapper
//import AFDateHelper

public class WSMDateTransform: TransformType {
    public typealias Object = Date
    public typealias JSON = String

    private var formatFromJsonType: DateFormatType = .isoDateTimeMilliSec
    private var formatToJsonType: DateFormatType = .isoDateTimeMilliSec

    public init() {}

    public init(formatFromJson formatFromJsonType: DateFormatType, formatToJson formatToJsonType: DateFormatType) {
        self.formatFromJsonType = formatFromJsonType
        self.formatToJsonType = formatToJsonType
    }

    open func transformFromJSON(_ value: Any?) -> Date? {
        if let dateAsString = value as? String {
//            return Date(fromString: dateAsString, format: formatFromJsonType)
            return Date(fromString: dateAsString, format: formatToJsonType, timeZone: .useOfCurrentCalendar)
        }

        return nil
    }

    open func transformToJSON(_ value: Date?) -> String? {
        if let date = value {
            return date.toString(format: formatToJsonType, timeZone: .utc)
        }
        return nil
    }
}
