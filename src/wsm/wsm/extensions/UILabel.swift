//
//  UILabel.swift
//  wsm
//
//  Created by framgia on 10/18/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation

extension UILabel {
    func setTextPartBold(boldText: String, normalText: String) {
        let attrs = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 14)]
        let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)
        let normalString = NSMutableAttributedString(string:normalText)
        attributedString.append(normalString)
        self.attributedText = attributedString
    }
}
