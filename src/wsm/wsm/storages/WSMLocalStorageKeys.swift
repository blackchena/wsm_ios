//
//  WSMLocalStorageKeys.swift
//  wsm
//
//  Created by Lê Thanh Quang on 9/21/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

extension DefaultsKeys {
    static let authToken = DefaultsKey<String?>("WSM-AUTH-TOKEN")
    static let currentLocale = DefaultsKey<String?>("WSM-LOCALE")
}
