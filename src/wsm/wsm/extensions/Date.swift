//
//  Date.swift
//  wsm
//
//  Created by framgia on 9/26/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation

extension Date {
    
    init?(dateString: String?) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = AppConstant.requestDateFormat
        if let dateString = dateString {
            if let d = dateStringFormatter.date(from: dateString) {
                self.init(timeInterval: 0, since: d)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }

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
        let dateString = ("\(self.toString(dateFormat: AppConstant.onlyDateFormat)) - \(date.getComponent(.hour)):\(date.getComponent(.minute))")
        return dateString.toDate(dateFormat: AppConstant.requestDateFormat)
    }

    func zeroSecond() -> Date? {
        let calender = Calendar.current
        let dateComponents = calender.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        return calender.date(from: dateComponents)
    }
    
    func getDurationWithSpecificTime(date : Date?) -> Float {
        let requestedComponent: Set<Calendar.Component> = [.hour,.minute,.second]
        var result = Float(0)
        if let dateCompare = date {
            let timeDifferent = Calendar.current.dateComponents(requestedComponent, from: self, to: dateCompare)
            if let hour = timeDifferent.hour {
                result += Float(hour)
            }
            if let hourPercent = timeDifferent.minute {
                result += Float(hourPercent)/60
            }
        }
        return result
    }
}
