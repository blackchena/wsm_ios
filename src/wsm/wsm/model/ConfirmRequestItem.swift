//
//  DetailModel.swift
//  wsm
//
//  Created by Lê Thanh Quang on 10/18/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import InAppLocalize

class DetailModel {
    var imageName: String
    var header: String
    var value: String?
    var valueColor: UIColor?

    init(imageName: String, header: String, value: String?, valueColor: UIColor? = nil) {
        self.imageName = imageName
        self.header = header
        self.value = value
        self.valueColor = valueColor
    }
}

extension DetailModel {
    public static func getDefaultItem(workSpaceId: Int?, groupId: Int?, positionName: String? = nil, projectName: String?, userProfileModel: UserProfileModel? = nil) -> [DetailModel] {

        let currentUser = userProfileModel ?? UserServices.getLocalUserProfile()

        var branchName = ""
        if let branches = ((currentUser?.workSpaces?.count ?? 0) > 0 ? currentUser?.workSpaces : UserServices.getLocalUserProfile()?.workSpaces),
            let i = branches.index(where: {$0.id == workSpaceId}) {
            branchName = branches[i].name ?? ""
        }

        var groupName = ""
        if let groups = ((currentUser?.groups?.count ?? 0) > 0 ? currentUser?.groups : UserServices.getLocalUserProfile()?.groups),
            let i = groups.index(where: {$0.id == groupId}) {
            groupName = groups[i].fullName ?? ""
        }

        var confirmItems = [DetailModel]()

        confirmItems.append(DetailModel(imageName: "ic_placeholder_user",
                                               header: LocalizationHelper.shared.localized("employee_name"),
                                               value: currentUser?.name))
        confirmItems.append(DetailModel(imageName: "ic_id_card",
                                               header: LocalizationHelper.shared.localized("employee_code"),
                                               value: currentUser?.employeeCode))

        if (positionName ?? "").isNotEmpty {
            confirmItems.append(DetailModel(imageName: "ic_position",
                                                   header: LocalizationHelper.shared.localized("position_name"),
                                                   value: positionName))
        }

        confirmItems.append(DetailModel(imageName: "ic_branch",
                                               header: LocalizationHelper.shared.localized("branch"),
                                               value: branchName))
        confirmItems.append(DetailModel(imageName: "ic_group",
                                               header: LocalizationHelper.shared.localized("group"),
                                               value: groupName))
        confirmItems.append(DetailModel(imageName: "ic_project",
                                               header: LocalizationHelper.shared.localized("project_name"),
                                               value: projectName))

        return confirmItems
    }

    public static func getDefaultItem(workSpaceName: String?, groupName: String?, positionName: String? = nil, projectName: String? = nil, userProfileModel: UserProfileModel? = nil) -> [DetailModel] {
        
        let currentUser = userProfileModel ?? UserServices.getLocalUserProfile()

        var confirmItems = [DetailModel]()

        confirmItems.append(DetailModel(imageName: "ic_placeholder_user",
                                               header: LocalizationHelper.shared.localized("employee_name"),
                                               value: currentUser?.name))
        confirmItems.append(DetailModel(imageName: "ic_id_card",
                                               header: LocalizationHelper.shared.localized("employee_code"),
                                               value: currentUser?.employeeCode))

        if (positionName ?? "").isNotEmpty {
            confirmItems.append(DetailModel(imageName: "ic_position",
                                                   header: LocalizationHelper.shared.localized("position_name"),
                                                   value: positionName))
        }

        confirmItems.append(DetailModel(imageName: "ic_branch",
                                               header: LocalizationHelper.shared.localized("branch"),
                                               value: workSpaceName))
        confirmItems.append(DetailModel(imageName: "ic_group",
                                               header: LocalizationHelper.shared.localized("group"),
                                               value: groupName))
        confirmItems.append(DetailModel(imageName: "ic_project",
                                               header: LocalizationHelper.shared.localized("project_name"),
                                               value: projectName))
        
        return confirmItems
    }
}
