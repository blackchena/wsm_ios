//
//  NotificationProvider.swift
//  wsm
//
//  Created by framgia on 10/20/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import Result
import Moya
import ObjectMapper
import SwiftyUserDefaults
import PromiseKit

fileprivate enum NotificationApiEndPoint: BaseApiTargetType {
    case getListNotifications(page: Int)

    public var path: String {
        switch self {
        case .getListNotifications:
            return "/api/dashboard/notifications"
        }
    }

    var parameters: [String : Any]? {
        switch self {
        case .getListNotifications(let page):
            return ["page" : page]
        }
    }
}

final class NotificationProvider {

    static let shared = NotificationProvider()
    var listNotifications = [NotificationModel]()
    var badgeValue: String?

    static func getListNotifications(page: Int) -> Promise<ListNotificatinApiOutputModel> {
        return ApiProvider.shared.requestPromise(target: MultiTarget(NotificationApiEndPoint.getListNotifications(page: page)))
    }
}
