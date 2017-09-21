//
//  Sequence.swift
//  wsm
//
//  Created by framgia on 9/21/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation

extension Sequence where Iterator.Element == UnicodeScalar {
    var string: String {
        return String(String.UnicodeScalarView(self))
    }
}
