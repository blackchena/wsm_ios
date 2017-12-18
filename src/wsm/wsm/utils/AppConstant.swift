//
//  AppConstant.swift
//  wsm
//
//  Created by Lê Thanh Quang on 10/3/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit

class AppConstant {

    public static let babySpecialTime = 60
    public static let childrenSpecialTime = 15

    public static let supportLanguages = ["en", "vi"]
    public static let defaultLanguage = "en"
    public static let defaultLocale = Locale(identifier: "en_US")

    public static let debugAPIBaseUrl = "https://edev.framgia.vn"
    public static let productAPIBaseUrl = "https://wsm.framgia.vn"
    public static let apiVersion = "/api/v2"

    public static let DateFormatEEEDisplay = "EEE, d MMM yyyy"
    public static let TimeFormat24HDisplay = "HH:mm"
    public static let requestDateFormat = "yyyy/MM/dd - HH:mm"
    public static let onlyDateFormat = "yyyy/MM/dd"
    public static let onlyTimeFormat = "HH:mm"
    public static let monthYearFormat = "MM/yyyy"
    public static let requestDateTimeFormat = "HH:mm - dd/MM/yyyy"

    public static let annualDayOffSettingId = Int(Int32.min) //-2147483647, this number is not conflict with server
    public static let dayOffFormat = "%@ (%.1f %@)"

}

enum NotificationName {

    static let updateRightButtonBadge = Notification.Name(rawValue: "UpdateRightButtonBadge")
    static let reloadNotifications = Notification.Name(rawValue: "ReloadNotifications")

}
