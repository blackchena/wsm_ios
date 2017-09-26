//
//  Date.swift
//  wsm
//
//  Created by framgia on 9/26/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation

extension Date {

    static let dateTimeFormat = "yyyy/MM/dd hh:mm"

    func toString(dateFormat: String) -> String {
        let formater = DateFormatter()
        formater.dateFormat = dateFormat
        return formater.string(from: self)
    }
}
