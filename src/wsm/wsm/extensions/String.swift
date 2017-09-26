//
//  String.swift
//  wsm
//
//  Created by framgia on 9/21/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation

extension String {
    private static var digitsPattern = UnicodeScalar("0")..."9"
    var digits: String {
        return unicodeScalars.filter { String.digitsPattern ~= $0 }.string
    }
    var integer: Int { return Int(self) ?? 0 }

    func appendingPathComponent(_ component: String) -> String {
        let str = self as NSString
        return str.appendingPathComponent(component)
    }

    func urlEncoded() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? self
    }

    func urlDecoded() -> String {
        return self.removingPercentEncoding ?? self
    }

    func toDate(dateFormat: String) -> Date? {
        let formater = DateFormatter()
        formater.dateFormat = dateFormat
        return formater.date(from: self)
    }
}
