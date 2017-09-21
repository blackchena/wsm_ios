//
//  MenuEnum.swift
//  wsm
//
//  Created by framgia on 9/20/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation

enum MenuHeaderEnum: String {
    case UserInfo = "HỒ SƠ CÁ NHÂN"
    case UserData = "DỮ LIỆU CÁ NHÂN"
    case UserRequest = "YÊU CẦU CÁ NHÂN"
}

enum MenuItemEnum: String {
    case UserInfo = "Thông tin cá nhân"
    case UserSetting = "Thiết lập cá nhân"
    case TimeSheet = "Lịch làm việc"
    case CalendarOff = "Lịch ngày nghỉ"
    case UserReport = "Thống kê cá nhân"
    case RequestOt = "Làm ngoài giờ"
    case RequestOff = "Xin nghỉ"
    case OtherRequest = "Khác"
}
