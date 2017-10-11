//
//  AppConstant.swift
//  wsm
//
//  Created by Lê Thanh Quang on 10/3/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit

class AppConstant {

    public static let supportLanguages = ["en", "vi"]
    public static let defaultLanguage = "en"
    public static let defaultLocale = Locale(identifier: "en_US")

    public static let debugAPIBaseUrl = "http://edev.framgia.vn"
    public static let productAPIBaseUrl = "http://wsm.framgia.vn"

    public static let DateFormatEEEDisplay = "EEE, d MMM yyyy"
    public static let TimeFormat24HDisplay = "HH:mm"
    public static let requestDateFormat = "yyyy/MM/dd HH:mm"
    public static let onlyDateFormat = "yyyy/MM/dd"
    public static let onlyTimeFormat = "HH:mm"
    public static let monthYearFormat = "MM/yyyy"
    public static let requestDateTimeFormat = "HH:mm - dd/MM/yyyy"
}
