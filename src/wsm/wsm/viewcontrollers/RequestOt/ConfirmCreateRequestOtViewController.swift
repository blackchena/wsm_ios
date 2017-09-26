//
//  ConfirmCreateRequestOtViewController.swift
//  wsm
//
//  Created by framgia on 9/26/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import InAppLocalize

class ConfirmCreateRequestOtViewController: NoMenuBaseViewController {

    @IBOutlet weak var tableView: UITableView!

    fileprivate var confirmReqOtItems = [ConfirmRequestOtItem]()
    var requestModel = RequestOtModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension

        guard let currentUser = UserServices.getLocalUserProfile() else {
            return
        }

        confirmReqOtItems.append(ConfirmRequestOtItem(imageName: "ic_placeholder_user",
                                                  header: LocalizationHelper.shared.localized("employee_name"),
                                                  value: currentUser.name))
        confirmReqOtItems.append(ConfirmRequestOtItem(imageName: "ic_id_card",
                                                  header: LocalizationHelper.shared.localized("employee_code"),
                                                  value: currentUser.employeeCode))
        confirmReqOtItems.append(ConfirmRequestOtItem(imageName: "ic_branch",
                                                  header: LocalizationHelper.shared.localized("branch"),
                                                  value: "\(String(describing: requestModel.workspaceId))"))
        confirmReqOtItems.append(ConfirmRequestOtItem(imageName: "ic_group",
                                                  header: LocalizationHelper.shared.localized("group"),
                                                  value: "\(String(describing: requestModel.groupId))"))
        confirmReqOtItems.append(ConfirmRequestOtItem(imageName: "ic_project",
                                                  header: LocalizationHelper.shared.localized("project_name"),
                                                  value: requestModel.projectName))
        confirmReqOtItems.append(ConfirmRequestOtItem(imageName: "ic_clock_2",
                                                  header: LocalizationHelper.shared.localized("from"),
                                                  value: requestModel.fromTime))
        confirmReqOtItems.append(ConfirmRequestOtItem(imageName: "ic_clock_2",
                                                  header: LocalizationHelper.shared.localized("to"),
                                                  value: requestModel.endTime))
        confirmReqOtItems.append(ConfirmRequestOtItem(imageName: "ic_clock",
                                                  header: LocalizationHelper.shared.localized("number_of_overtime"),
                                                  value: "3,00"))//dummy
        confirmReqOtItems.append(ConfirmRequestOtItem(imageName: "ic_reason",
                                                  header: LocalizationHelper.shared.localized("reason"),
                                                  value: requestModel.reason))
    }
}

extension ConfirmCreateRequestOtViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmCreateOtCell", for: indexPath)
            as? ConfirmCreateOtCell else {
                return UITableViewCell()
        }

        cell.updateCell(item: confirmReqOtItems[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return confirmReqOtItems.count
    }
}

struct ConfirmRequestOtItem {
    var imageName: String
    var header: String
    var value: String?
}
