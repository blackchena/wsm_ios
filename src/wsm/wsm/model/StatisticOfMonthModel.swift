//
//  StatisticOfMonthModel.swift
//  wsm
//
//  Created by framgia on 10/24/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import ObjectMapper

class StatisticOfMonthModel: BaseModel {

    var numberLeaveTimes: NumberLeaveTimesModel?
    var numberDaysOff: NumberDaysOffModel?
    var numberOtHours: NumberOtHoursModel?
    var numberRemainingDaysOff: NumberRemainingDaysOffModel?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        numberLeaveTimes <- map["number_leave_times"]
        numberDaysOff <- map["number_days_off"]
        numberOtHours <- map["number_ot_hours"]
        numberRemainingDaysOff <- map["number_remaining_days_off"]
    }
}

class NumberLeaveTimesModel: BaseModel {

    var approvedInMonth: Float?
    var rejectedInMonth: Float?
    var approvedInYear: Float?
    var rejectedInYear: Float?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        approvedInMonth <- map["approved_in_month"]
        rejectedInMonth <- map["rejected_in_month"]
        approvedInYear <- map["approved_in_year"]
        rejectedInYear <- map["rejected_in_year"]
    }
}

class NumberDaysOffModel: BaseModel {

    var approvedInMonth: Float?
    var rejectedInMonth: Float?
    var haveSalaryPayByCompanyInMonth: Float?
    var haveSalaryPayByCompanyInYear: Float?
    var noSalaryInMonth: Float?
    var noSalaryInYear: Float?
    var haveSalaryPayByInsuranceInMonth: Float?
    var haveSalaryPayByInsuranceInYear: Float?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        approvedInMonth <- map["approved_in_month"]
        rejectedInMonth <- map["rejected_in_month"]
        haveSalaryPayByCompanyInMonth <- map["have_salary_pay_by_company_in_month"]
        haveSalaryPayByCompanyInYear <- map["have_salary_pay_by_company_in_year"]
        noSalaryInMonth <- map["no_salary_in_month"]
        noSalaryInYear <- map["no_salary_in_year"]
        haveSalaryPayByInsuranceInMonth <- map["have_salary_pay_by_insurance_in_month"]
        haveSalaryPayByInsuranceInYear <- map["have_salary_pay_by_insurance_in_year"]
    }}

class NumberOtHoursModel: BaseModel {

    var approvedInMonth: Float?
    var rejectedInMonth: Float?
    var approvedInYear: Float?
    var rejectedInYear: Float?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        approvedInMonth <- map["approved_in_month"]
        rejectedInMonth <- map["rejected_in_month"]
        approvedInYear <- map["approved_in_year"]
        rejectedInYear <- map["rejected_in_year"]
    }
}

class NumberRemainingDaysOffModel: BaseModel {

    var previousYear: Float?
    var inYear: Float?
    var bonusInYear: Float?
    var totalRemainInYear: Float?

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        previousYear <- map["previous_year"]
        inYear <- map["in_year"]
        bonusInYear <- map["bonus_in_year"]
        totalRemainInYear <- map["total_remain_in_year"]
    }
}
