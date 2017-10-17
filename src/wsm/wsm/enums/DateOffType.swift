//
//  DateOffType.swift
//  wsm
//
//  Created by Lê Thanh Quang on 10/6/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import InAppLocalize

enum DateOffType: String {
    case haveSalaryCompanyPay = "company"
    case haveSalaryInsuranceCoverage = "insurance"
    case noSalary

    func toLocalizeString() -> String {
        switch self {
        case .haveSalaryCompanyPay:
            return LocalizationHelper.shared.localized("off_have_salary_company_pay")
        case .haveSalaryInsuranceCoverage:
            return LocalizationHelper.shared.localized("off_have_salary_insurance_coverage")
        case .noSalary:
            return LocalizationHelper.shared.localized("off_no_salary")
        }
    }
}
