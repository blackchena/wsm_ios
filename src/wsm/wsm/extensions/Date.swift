//
//  Date.swift
//  wsm
//
//  Created by framgia on 9/26/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation

extension Date {

    func toString(dateFormat: String) -> String {
        let formater = DateFormatter()
        formater.dateFormat = dateFormat
        return formater.string(from: self)
    }

    func getComponent(_ component: Calendar.Component) -> Int {
        let calendar = Calendar.current
        return calendar.component(component, from: self)
    }

    func createDateFromTimeOf(date: Date) -> Date? {
        let dateString = ("\(self.toString(dateFormat: AppConstant.onlyDateFormat)) \(date.getComponent(.hour)):\(date.getComponent(.minute))")
        return dateString.toDate(dateFormat: AppConstant.requestDateFormat)
    }
}
