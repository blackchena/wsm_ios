//
//  CreateRequestOffViewControllerType.swift
//  wsm
//
//  Created by Lê Thanh Quang on 10/9/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import InAppLocalize

protocol CreateRequestOffViewControllerType {
    func didSubmitRequestSuccess()
}

extension CreateRequestOffViewControllerType  where Self: UIViewController {
    func getRequestDayOffTypes(byDateOffType dateOffType: DateOffType) -> [DayOffSettingModel]? {

        guard let dayOffSettingResult = UserServices.getLocalDayOffSettings(),
            let listDayOffSetting = dayOffSettingResult.listDayOffSetting else {
            return nil
        }

        var settings = listDayOffSetting.filter({ x in x.payType == dateOffType})

        if dateOffType == .haveSalaryCompanyPay {

            let annualDayOff = DayOffSettingModel(id: nil, code: nil, companyId: nil,
                                                  dayOffSettingId: nil, amount: nil, unit: nil,
                                                  limitTimes: nil, loopType: nil,
                                                  payType: .haveSalaryCompanyPay,
                                                  name: LocalizationHelper.shared.localized("annual_leave_detail"),
                                                  description: LocalizationHelper.shared.localized("annual_leave_detail"),
                                                  remaining: dayOffSettingResult.remainingDayOff,
                                                  isAnnualLeave: true)

            settings.insert(annualDayOff, at: 0)
        }

        return settings
    }

    func generateDayOffTypeAttributes(dayOffSettingBindedValue: [Int: (Float, Bool)]) -> [RequestDayOffTypeModel] {

        var result = [RequestDayOffTypeModel]()

        guard let listDayOffSetting = UserServices.getLocalDayOffSettings()?.listDayOffSetting else {
            return result
        }

        for setting in listDayOffSetting {
            if let settingId = setting.id,
                !setting.isAnnualLeave {

                let numberDayOffBySetting: Float? = dayOffSettingBindedValue[settingId]?.0

                result.append(RequestDayOffTypeModel(id: setting.id,
                                                     specialDayOffSettingId: setting.dayOffSettingId,
                                                     numberDayOff: numberDayOffBySetting,
                                                     destroy: !((numberDayOffBySetting ?? 0) > 0)  )) //have value && > 0 -> false, else true
            }
        }

        return result
    }
}
