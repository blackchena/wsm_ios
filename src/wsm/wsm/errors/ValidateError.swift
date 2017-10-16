//
//  ValidateError.swift
//  wsm
//
//  Created by Lê Thanh Quang on 10/9/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import InAppLocalize

enum ValidateError: Error, LocalizedError {
    case custom(withLocalizeKey: String)
    case invalid(message: String)

    var errorDescription: String? {
        switch self {
        case .custom(let withLocalizeKey):
            return LocalizationHelper.shared.localized(withLocalizeKey)
        case .invalid(let message):
            return message
        }

    }
}
