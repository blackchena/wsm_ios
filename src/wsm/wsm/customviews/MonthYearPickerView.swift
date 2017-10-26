//
//  MonthYearPickerView.swift
//  wsm
//
//  Created by framgia on 10/9/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation

class MonthYearPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {

    var months = [String]()
    var years = [Int]()
    let startYear = 2000

    var month: Int = 0 {
        didSet {
            selectRow(month-1, inComponent: 0, animated: false)
        }
    }

    var year: Int = 0 {
        didSet {
            if let index = years.index(of: year) {
                selectRow(index, inComponent: 1, animated: true)
            }
        }
    }

    var onDateSelected: ((_ month: Int, _ year: Int) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonSetup()
    }

    func commonSetup() {
        // population years
        let currentYear = Date().getComponent(.year)
        var years = [Int]()
        if years.count == 0 {
            for year in startYear...currentYear + 1 {
                years.append(year)
            }
        }
        self.years = years

        //locale date formatter
        let dateFormater = DateFormatter()
        if let langCode = Locale.current.languageCode,
            !AppConstant.supportLanguages.contains(langCode) {
            dateFormater.locale = AppConstant.defaultLocale
        }

        // population months with localized names
        var months = [String]()
        for index in 0...11 {
            months.append(dateFormater.monthSymbols[index].capitalized)
        }
        self.months = months
        self.delegate = self
        self.dataSource = self

        selectCurrentWorkingMonth()
    }

    func selectCurrentMonth() {
        let currentMonth = Date().getComponent(.month)
        let currentYear = Date().getComponent(.year)
        self.selectRow(currentMonth - 1, inComponent: 0, animated: false)
        self.selectRow(currentYear - startYear, inComponent: 1, animated: false)
        self.year = currentYear
        self.month = currentMonth
    }

    func selectCurrentWorkingMonth() {
        var today = Date()
        let dayOfToday = Calendar.current.component(.day, from: today)
        if let cutOffDate = UserServices.getLocalUserProfile()?.company?.cutOffDate,
            dayOfToday > cutOffDate {
            today = today.dateFor(.startOfMonth).adjust(.month, offset: 1)
        }

        let currentMonth = today.getComponent(.month)
        let currentYear = today.getComponent(.year)

        self.selectRow(currentMonth - 1, inComponent: 0, animated: false)
        self.selectRow(currentYear - startYear, inComponent: 1, animated: false)
        self.year = currentYear
        self.month = currentMonth
    }

    func getMonthYearSelectedString() -> String {
        return String(format: "%02d/%d", month, year)
    }

    // Mark: UIPicker Delegate / Data Source

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return months[row]
        case 1:
            return "\(years[row])"
        default:
            return nil
        }
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return months.count
        case 1:
            return years.count
        default:
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let month = self.selectedRow(inComponent: 0) + 1
        let year = years[self.selectedRow(inComponent: 1)]
        onDateSelected?(month, year)

        self.month = month
        self.year = year
    }
}
