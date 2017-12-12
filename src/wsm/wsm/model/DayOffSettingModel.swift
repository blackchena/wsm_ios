//
//  DateOffModel.swift
//  wsm
//
//  Created by Lê Thanh Quang on 9/25/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import ObjectMapper
import InAppLocalize

class DayOffSettingModel: BaseModel {

    var id: Int?
    var code: String?
    var companyId: String?
    var dayOffSettingId: Int?
    var amount: Float?
    var unit: String?
    var limitTimes: Float?
    var loopType: String?
    var payType: DateOffType = .noSalary
    var name: String?
    var description: String?
    var remaining: Float?
    var isAnnualLeave: Bool = false

    private enum DayOffType: String {

        case leaveForMarriage = "KH"
        case leaveForChildsMarriage = "KHC"
        case funeralLeave = "TG"
        case maternityLeave = "TS"
        case leaveForSickChild = "CO"
        case wifesLaborLeave = "VS"
        case miscarriageLeave = "ST"
        case pregnancyExaminationLeave = "KT"
        case sickLeave = "O"

        var dayOffFormat: String {
            switch self {
            case .leaveForMarriage: return LocalizationHelper.shared.localized("leave_for_marriage")
            case .leaveForChildsMarriage: return LocalizationHelper.shared.localized("leave_for_child_marriage")
            case .funeralLeave: return LocalizationHelper.shared.localized("funeral_leave")
            case .maternityLeave: return LocalizationHelper.shared.localized("maternity_leave")
            case .leaveForSickChild: return LocalizationHelper.shared.localized("leave_for_care_of_sick_child")
            case .wifesLaborLeave: return LocalizationHelper.shared.localized("wife_labor_leave")
            case .miscarriageLeave: return LocalizationHelper.shared.localized("miscarriage_leave")
            case .pregnancyExaminationLeave: return LocalizationHelper.shared.localized("pregnancy_examination_leave")
            case .sickLeave: return LocalizationHelper.shared.localized("sick_leave")
            }
        }

    }

    init(id: Int?, code: String?,
         companyId: String?,
         dayOffSettingId: Int?, amount: Float?,
         unit: String?, limitTimes: Float?,
         loopType: String?, payType: DateOffType,
         name: String?, description: String?,
         remaining: Float?, isAnnualLeave: Bool) {

        self.id = id
        self.code = code
        self.companyId = companyId
        self.dayOffSettingId = dayOffSettingId
        self.amount = amount
        self.unit = unit
        self.limitTimes = limitTimes
        self.loopType = loopType
        self.payType = payType
        self.name = name
        self.description = description
        self.remaining = remaining
        self.isAnnualLeave = isAnnualLeave
    }

    var dayOffAsString: String {
        guard let code = self.code, let dayOffType = DayOffType(rawValue: code) else {
            return String(format: AppConstant.dayOffFormat, name ?? "N/A", remaining ?? 0.0, unit ?? "N/A")
        }
        return String(format: dayOffType.dayOffFormat, remaining ?? 0.0)
    }

    required init?(map: Map) {
    }

    func mapping(map: Map) {
        id <- map["id"]
        code <- map["code"]
        companyId <- map["company_id"]
        dayOffSettingId <- map["dayoff_setting_id"]
        amount <- map["amount"]
        unit <- map["unit"]
        limitTimes <- map["limit_times"]
        loopType <- map["loop_type"]
        payType <- map["pay_type"]
        name <- map["name"]
        description <- map["description"]
        remaining <- map["remaining"]
    }
}
