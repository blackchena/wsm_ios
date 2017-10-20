//
//  DetailModel.swift
//  wsm
//
//  Created by Lê Thanh Quang on 10/18/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import InAppLocalize

struct ConfirmRequestItem/*DetailModel*/ {
    var imageName: String
    var header: String
    var value: String?
}

extension ConfirmRequestItem {
    public static func getDefaultItem(workSpaceId: Int?, groupId: Int?, projectName: String?) -> [ConfirmRequestItem] {
        let currentUser = UserServices.getLocalUserProfile()
        var branchName = ""
        if let branches = currentUser?.workSpaces, let i = branches.index(where: {$0.id == workSpaceId}) {
            branchName = branches[i].name ?? ""
        }
        var groupName = ""
        if let groups = currentUser?.groups, let i = groups.index(where: {$0.id == groupId}) {
            groupName = groups[i].fullName ?? ""
        }

        var confirmItems = [ConfirmRequestItem]()

        confirmItems.append(ConfirmRequestItem(imageName: "ic_placeholder_user",
                                               header: LocalizationHelper.shared.localized("employee_name"),
                                               value: currentUser?.name))
        confirmItems.append(ConfirmRequestItem(imageName: "ic_id_card",
                                               header: LocalizationHelper.shared.localized("employee_code"),
                                               value: currentUser?.employeeCode))
        confirmItems.append(ConfirmRequestItem(imageName: "ic_branch",
                                               header: LocalizationHelper.shared.localized("branch"),
                                               value: branchName))
        confirmItems.append(ConfirmRequestItem(imageName: "ic_group",
                                               header: LocalizationHelper.shared.localized("group"),
                                               value: groupName))
        confirmItems.append(ConfirmRequestItem(imageName: "ic_project",
                                               header: LocalizationHelper.shared.localized("project_name"),
                                               value: projectName))

        return confirmItems
    }
}
