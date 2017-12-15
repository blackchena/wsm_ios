//
//  HelpObject.swift
//  wsm
//
//  Created by Mac Pro on 12/4/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import InAppLocalize

class  HelpObject {
    
    var helpObjects: [Help]
    
    init() {
        helpObjects = [Help]()
        let currentDayIcon = UIImage(named: "ic_current_day")
        let overtimeIcon = UIImage(named: "ic_overtime_2")
        helpObjects.append(Help(color: nil,
                                image: currentDayIcon,
                                title: LocalizationHelper.shared.localized("current_day")))
        helpObjects.append(Help(color: "#B22222",
                                image: nil,
                                title: LocalizationHelper.shared.localized("il_lo_le_forgot_card_forgot_checkin_checkout")))
        helpObjects.append(Help(color: "#FF4081",
                                image: nil,
                                title: LocalizationHelper.shared.localized("wo_il_le_lo_enough_compensation_time")))
        helpObjects.append(Help(color: "#32CD32",
                                image: nil,
                                title: LocalizationHelper.shared.localized("no_data_not_enough_working_time")))
        helpObjects.append(Help(color: "#13217F",
                                image: overtimeIcon,
                                title: LocalizationHelper.shared.localized("overtime")))
        helpObjects.append(Help(color: "#ff875b",
                                image: nil,
                                title: LocalizationHelper.shared.localized("ro_unpaid_leave_of_absence")))
        helpObjects.append(Help(color: "#a2e796",
                                image: nil,
                                title: LocalizationHelper.shared.localized("p_paid_leave_of_absence")))
        helpObjects.append(Help(color: "#FFD700",
                                image: nil,
                                title: LocalizationHelper.shared.localized("holiday")))
        helpObjects.append(Help(color: "#F5BE80",
                                image: nil,
                                title: LocalizationHelper.shared.localized("compensation")))
    }
}
