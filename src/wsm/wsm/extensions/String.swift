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

    subscript (i: Int) -> Character {
        return self.isEmpty ? Character("") : self[self.characters.index(self.startIndex, offsetBy: i)]
    }

    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }

    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return self[start..<end]
    }

    subscript (r: ClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return self[start...end]
    }

    func removeEmptyLines() -> String {
        var linesArray: [String] = []
        self.enumerateLines { line, _ in linesArray.append(line) }
        return linesArray.filter{!$0.isEmpty}.joined(separator: "\n")
    }

    static func setNullOrEmptyStringHolder(string: String?, holder: String) -> String{
        if let str = string, !str.isEmpty {
            return str
        }
        return holder
    }
}
