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
    case readSingleNotification(id: Int)
    case readAllNotifications

    public var path: String {
        switch self {
        case .getListNotifications:
            return "/api/dashboard/notifications"
        case .readSingleNotification, .readAllNotifications:
            return "/api/dashboard/set_notifications"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getListNotifications:
            return .get
        case .readSingleNotification, .readAllNotifications:
            return .put
        }
    }

    var parameters: [String : Any]? {
        switch self {
        case .getListNotifications(let page):
            return ["page" : page]
        case .readSingleNotification(let id):
            return [
                "id": id,
                "read": true
            ]
        case .readAllNotifications:
            return ["read_all": true]
        }
    }

}

final class NotificationProvider {

    static let shared = NotificationProvider()
    var listNotifications = [NotificationModel]()
    var badgeValue: String? {
        didSet {
            let badgeNumber = Int(badgeValue ?? "0") ?? 0
            Utils.updateBadgeNumber(badgeNumber)
            NotificationCenter.default.post(name: NotificationName.updateRightButtonBadge, object: nil)
        }
    }

    static func getListNotifications(page: Int) -> Promise<ListNotificatinApiOutputModel> {
        let target = MultiTarget(NotificationApiEndPoint.getListNotifications(page: page))
        return ApiProvider.shared.requestPromise(target: target)
    }

    static func readSingleNotification(id: Int) -> Promise<ResponseData> {
        let target = MultiTarget(NotificationApiEndPoint.readSingleNotification(id: id))
        return ApiProvider.shared.requestPromise(target: target)
    }

    static func readAllNotifications() -> Promise<ResponseData> {
        return ApiProvider.shared.requestPromise(target: MultiTarget(NotificationApiEndPoint.readAllNotifications))
    }

}
