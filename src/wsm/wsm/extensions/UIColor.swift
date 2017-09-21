//
//  UIColor.swift
//  wsm
//
//  Created by framgia on 9/21/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation

extension UIColor {
    static let appBarTintColor = UIColor(red: 0, green: 150/255, blue: 136/255, alpha: 1)
    static let appTintColor = UIColor.white

    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red)/CGFloat(255.0),
                  green: CGFloat(green)/CGFloat(255.0),
                  blue: CGFloat(blue)/CGFloat(255.0), alpha: 1.0)
    }

    convenience init(gray: Int) {
        self.init(red: CGFloat(gray)/CGFloat(255.0),
                  green: CGFloat(gray)/CGFloat(255.0),
                  blue: CGFloat(gray)/CGFloat(255.0), alpha: 1.0)
    }

    convenience init(hexString: String) {
        let hexString = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)

        if hexString.hasPrefix("#") {
            scanner.scanLocation = 1
        }

        var color: UInt32 = 0
        scanner.scanHexInt32(&color)

        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask

        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0

        self.init(red:red, green:green, blue:blue, alpha:1)
    }
}
