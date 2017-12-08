//
//  Utils.swift
//  wsm
//
//  Created by nguyen.van.hung on 7/11/17.
//  Copyright © 2017 nguyen.van.hung. All rights reserved.
//

import UIKit

let openSansBold = "OpenSans-Bold"
let openSansBoldItalic = "OpenSans-BoldItalic"
let openSansExtraBold = "OpenSans-ExtraBold"
let openSansExtraBoldItalic = "OpenSans-ExtraBoldItalic"
let openSansItalic = "OpenSans-Italic"
let openSansLight = "OpenSans-Light"
let openSansLightItalic = "OpenSans-LightItalic"
let openSansRegular = "OpenSans"
let openSansSemibold = "OpenSans-Semibold"
let openSansSemiboldItalic = "OpenSans-SemiboldItalic"

final class Utils {
    static let decimalFormatter = NumberFormatter(numberStyle: .decimal)

    static func getPortraitScreenSize() -> CGSize {
        let size = UIScreen.main.bounds
        return CGSize(width: min(size.width, size.height), height: max(size.width, size.height))
    }
}

func getViewController(storyboardName: String = "Main", identifier: String) -> UIViewController {
    let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
    return storyboard.instantiateViewController(withIdentifier: identifier)
}
