//
//  RequestOtModel.swift
//  wsm
//
//  Created by framgia on 9/26/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import ObjectMapper

public class RequestOtApiInputModel: BaseModel {
    var id: Int?
    var workspaceId: Int?
    var groupId: Int?
    var projectName: String?
    var fromTime: String?
    var endTime: String?
    var reason: String?

    init() {
    }

    required public init?(map: Map) {
    }

    public func mapping(map: Map) {
        workspaceId <- map["workspace_id"]
        groupId <- map["group_id"]
        projectName <- map["project_name"]
        fromTime <- map["from_time"]
        endTime <- map["end_time"]
        reason <- map["reason"]
    }

    func getOtTime() -> String {
        guard let shift = UserServices.getLocalUserProfile()?.workSpaces?.first?.shifts.first,
              let checkinTime = fromTime?.toDate(dateFormat: AppConstant.requestDateFormat),
              let checkoutTime = endTime?.toDate(dateFormat: AppConstant.requestDateFormat) else {
            return ""
        }
        let duration = checkoutTime.timeIntervalSince(checkinTime)
        var otHours = duration / 3600
        if containLunchTime(shift: shift) && otHours > 4 {
            otHours -= 1
        }
        return String(format: "%.2f", otHours)
    }
    
    func isDuringLunchBreak() -> Bool {
        let currentUser = UserServices.getLocalUserProfile()
        if let shift = currentUser?.workSpaces?.first?.shifts.first {
            return containLunchTime(shift: shift) || !inLunchTime(shift: shift)
        }
        return false
    }
    
    private func inLunchTime(shift: WorkSpaceShift) -> Bool {
        if let timeLunch = shift.getTimeLunch(dateInput: fromTime),
            let timeAfternoon = shift.getTimeAfternoon(dateInput: endTime),
            let timeFrom =  fromTime?.toDate(dateFormat: AppConstant.requestDateFormat),
            let timeEnd = endTime?.toDate(dateFormat: AppConstant.requestDateFormat) {
            return timeFrom.compare(.isLater(than: timeLunch)) && timeEnd.compare(.isEarlier(than: timeAfternoon))
        }
        return false
    }
    
    private func containLunchTime(shift: WorkSpaceShift) -> Bool {
        if let timeLunch = shift.getTimeLunch(dateInput: fromTime),
            let timeAfternoon = shift.getTimeAfternoon(dateInput: endTime),
            let timeFrom =  self.fromTime?.toDate(dateFormat: AppConstant.requestDateFormat),
            let timeEnd = self.endTime?.toDate(dateFormat: AppConstant.requestDateFormat) {
            return timeFrom.compare(.isEarlier(than: timeLunch)) && timeEnd.compare(.isLater(than: timeAfternoon))
        }
        return false
    }

    func isValid() -> Bool {
        if (projectName ?? "").isEmpty
            || (fromTime ?? "").isEmpty
            || (endTime ?? "").isEmpty
            || (reason ?? "").isEmpty
            || workspaceId == nil
            || groupId == nil {
            return false
        }
        return true
    }
}
