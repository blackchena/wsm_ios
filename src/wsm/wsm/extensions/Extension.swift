//
//  Extension.swift
//  wsm
//
//  Created by nguyen.van.hung on 7/11/17.
//  Copyright © 2017 nguyen.van.hung. All rights reserved.
//

import Foundation
import UIKit

extension String {
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
}

extension UIColor {
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

extension Dictionary {

    mutating func merge(with dictionary: Dictionary) {
        dictionary.forEach { updateValue($1, forKey: $0) }
    }

    func merged(with dictionary: Dictionary) -> Dictionary {
        var dict = self
        dictionary.forEach { dict.updateValue($1, forKey: $0) }
        return dict
    }
}

extension Array {
    func count(withMatching matcher: ((Any) -> Bool)) -> Int {
        var c = 0
        for object in self {
            if matcher(object) {
                c += 1
            }
        }
        return c
    }
}

extension NumberFormatter {
    convenience init(numberStyle: NumberFormatter.Style) {
        self.init()
        self.numberStyle = numberStyle
    }
}
struct Formatter {
    static let decimal = NumberFormatter(numberStyle: .decimal)
}
extension UITextField {
    var string: String { return text ?? "" }
}

extension String {
    private static var digitsPattern = UnicodeScalar("0")..."9"
    var digits: String {
        return unicodeScalars.filter { String.digitsPattern ~= $0 }.string
    }
    var integer: Int { return Int(self) ?? 0 }
}

extension Sequence where Iterator.Element == UnicodeScalar {
    var string: String { return String(String.UnicodeScalarView(self)) }
}

extension DateFormatter {
    convenience init(format: String) {
        self.init()
        self.dateFormat = format
    }
}

extension UIImageView {
    func downloadImageFrom(link: String, contentMode: UIViewContentMode) {
        if let url = NSURL(string: link) {
            URLSession.shared.dataTask( with: url as URL, completionHandler: {
                (data, _, _) -> Void in
                DispatchQueue.main.async {
                    self.contentMode =  contentMode
                    if let data = data { self.image = UIImage(data: data) }
                }
            }).resume()
        }
    }

    func circleImage() {
        layer.borderWidth = 0.5
        layer.masksToBounds = false
        layer.borderColor = UIColor.gray.cgColor
        layer.cornerRadius = frame.height/2
        clipsToBounds = true
    }
}

extension UIViewController {
    func getStoryboardController(storyboardName: String = "Main", identifier: String) -> UIViewController{
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
}
