//
//  Array.swift
//  wsm
//
//  Created by framgia on 9/21/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation

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
