//
//  NotificationOuputApiModel.swift
//  wsm
//
//  Created by framgia on 10/20/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import ObjectMapper

class ListNotificatinApiOutputModel: ResponseData {

    var listNotifications = [NotificationModel]()
    var unreadCount: Int?

    override func mapping(map: Map) {
        super.mapping(map: map)
        listNotifications <- map["data.notifications"]
        unreadCount <- map["data.count_unread_notifications"]
    }
}
