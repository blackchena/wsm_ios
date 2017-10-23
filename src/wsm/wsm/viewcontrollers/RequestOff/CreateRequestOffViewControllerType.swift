//
//  CreateRequestOffViewControllerType.swift
//  wsm
//
//  Created by Lê Thanh Quang on 10/9/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import InAppLocalize
import PromiseKit

protocol CreateRequestOffViewControllerType {
}

protocol ConfirmCreateRequestOffViewControllerType {
    func didSubmitRequestSuccess()
}

extension ConfirmCreateRequestOffViewControllerType where Self: UIViewController {
    func submitCreateRequestOff(requestOffDetailApiInputModel: RequestOffDetailApiInputModel) {
        let requestApiInput = RequestOffApiInputModel(requestOffDetail: requestOffDetailApiInputModel)

        AlertHelper.showLoading()

        RequestOffProvider.createRequestOff(requestModel: requestApiInput).then { result -> Void in
            //save
            RequestOffProvider.shared.listRequests.append(result)

            self.didSubmitRequestSuccess()
            }.catch { error in
                AlertHelper.showError(error: error)
            }.always {
                AlertHelper.hideLoading()
        }
    }

    func submitEditRequestOff(id: Int, requestOffDetailApiInputModel: RequestOffDetailApiInputModel) {
        let requestApiInput = RequestOffApiInputModel(requestOffDetail: requestOffDetailApiInputModel)

        AlertHelper.showLoading()

        RequestOffProvider.editRequestOff(id: id, requestModel: requestApiInput).then { result -> Void in
            //save
            self.didSubmitRequestSuccess()
            }.catch { error in
                AlertHelper.showError(error: error)
            }.always {
                AlertHelper.hideLoading()
        }

    }
}

extension CreateRequestOffViewControllerType where Self: UIViewController {
    func getRequestDayOffTypes(byDateOffType dateOffType: DateOffType) -> [DayOffSettingModel]? {

        guard let dayOffSettingResult = UserServices.getLocalDayOffSettings(),
            let listDayOffSetting = dayOffSettingResult.listDayOffSetting else {
                return nil
        }

        var settings = listDayOffSetting.filter({ x in x.payType == dateOffType})

        if dateOffType == .haveSalaryCompanyPay {

            let annualDayOff = DayOffSettingModel(id: AppConstant.annualDayOffSettingId, code: nil, companyId: nil,
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

    func generateDayOffTypeAttributes(dayOffSettingBindedValue: [Int: (Float, Bool, DayOffSettingModel)]) -> [RequestDayOffTypeModel] {

        var result = [RequestDayOffTypeModel]()

        guard let listDayOffSetting = UserServices.getLocalDayOffSettings()?.listDayOffSetting else {
            return result
        }

        for setting in listDayOffSetting {
            if let settingId = setting.id,
                !setting.isAnnualLeave {

                let numberDayOffBySetting: Float? = dayOffSettingBindedValue[settingId]?.0

                result.append(RequestDayOffTypeModel(id: nil, //setting.dayOffSettingId
                                                     specialDayOffSettingId: setting.id,
                                                     numberDayOff: numberDayOffBySetting,
                                                     destroy: !((numberDayOffBySetting ?? 0) > 0)  )) //have value && > 0 -> false, else true
            }
        }
        
        return result
    }
}
