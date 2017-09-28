//
//  ConfirmCreateRequestOtViewController.swift
//  wsm
//
//  Created by framgia on 9/26/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import InAppLocalize
import ObjectMapper

class ConfirmCreateRequestOtViewController: NoMenuBaseViewController {

    @IBOutlet weak var tableView: UITableView!

    fileprivate var confirmReqOtItems = [ConfirmRequestOtItem]()
    var requestModel = RequestOtApiInputModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension

        guard let currentUser = UserServices.getLocalUserProfile() else {
            return
        }

        var branchName = ""
        if let branches = currentUser.workSpaces, let i = branches.index(where: {$0.id == requestModel.workspaceId}) {
            branchName = branches[i].name ?? ""
        }
        var groupName = ""
        if let groups = currentUser.groups, let i = groups.index(where: {$0.id == requestModel.groupId}) {
            groupName = groups[i].fullName ?? ""
        }

        confirmReqOtItems.append(ConfirmRequestOtItem(imageName: "ic_placeholder_user",
                                                  header: LocalizationHelper.shared.localized("employee_name"),
                                                  value: currentUser.name))
        confirmReqOtItems.append(ConfirmRequestOtItem(imageName: "ic_id_card",
                                                  header: LocalizationHelper.shared.localized("employee_code"),
                                                  value: currentUser.employeeCode))
        confirmReqOtItems.append(ConfirmRequestOtItem(imageName: "ic_branch",
                                                  header: LocalizationHelper.shared.localized("branch"),
                                                  value: branchName))
        confirmReqOtItems.append(ConfirmRequestOtItem(imageName: "ic_group",
                                                  header: LocalizationHelper.shared.localized("group"),
                                                  value: groupName))
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
                                                  value: requestModel.getOtTime()))
        confirmReqOtItems.append(ConfirmRequestOtItem(imageName: "ic_reason",
                                                  header: LocalizationHelper.shared.localized("reason"),
                                                  value: requestModel.reason))
    }

    @IBAction func submitBtnClick(_ sender: Any) {
        submitRequestOt(requestModel: requestModel)
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

extension ConfirmCreateRequestOtViewController: ConfirmCreateRequestOtViewControllerType {
    
    func didSubmitRequestSuccess() {
        navigationController?.popToRootViewController(animated: true)
    }
}

struct ConfirmRequestOtItem {
    var imageName: String
    var header: String
    var value: String?
}
