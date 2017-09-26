//
//  Date.swift
//  wsm
//
//  Created by framgia on 9/26/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation

extension Date {
    func toString(_ stringFormat: String) -> String{
        let formater = DateFormatter()
        formater.dateFormat = stringFormat
        return formater.string(from: self)
    }
}
