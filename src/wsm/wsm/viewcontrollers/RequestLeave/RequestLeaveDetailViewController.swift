//
//  RequestLeaveDetailViewController.swift
//  wsm
//
//  Created by framgia on 10/9/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import InAppLocalize

class RequestLeaveDetailViewController: NoMenuBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deleteButton: LocalizableButton!
    @IBOutlet weak var editButton: LocalizableButton!
    @IBOutlet weak var deleteButtonHeight: NSLayoutConstraint!

    weak var listRequestDelegate: ListRequestDelegte?
    var selectedRequest = RequestLeaveModel()
    var leaveType: LeaveTypeModel?
    var detailItems = [ConfirmRequestItem]()
    let currentUser = UserServices.getLocalUserProfile()
    let compensationRowNumber = 3
    let statusRowNumber = 2
    var statusCellIndex = -1

    override func viewDidLoad() {
        super.viewDidLoad()

        if selectedRequest.status != .pending {
            deleteButtonHeight.constant = 0
            view.layoutIfNeeded()
        }

        appendDefaultItem()
        appendTrackingItem()
        appendStatusItem()
        appendCompensationItem()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension

        statusCellIndex = detailItems.count - statusRowNumber
        if leaveType?.compensationKind == .require {
            statusCellIndex -= compensationRowNumber
        }
    }

    func appendDefaultItem() {

        if let leaveTypes = UserServices.getLocalLeaveTypeSettings(), let i = leaveTypes.index(where: {$0.id == selectedRequest.leaveType?.id}) {
            leaveType = leaveTypes[i]
        }
        detailItems.append(contentsOf: ConfirmRequestItem.getDefaultItem(workSpaceName: selectedRequest.workspace?.name,
                                                                         groupName: selectedRequest.group?.fullName,
                                                                         projectName: selectedRequest.projectName,
                                                                         userProfileModel: selectedRequest.user))

        detailItems.append(ConfirmRequestItem(imageName: "ic_project",
                                               header: LocalizationHelper.shared.localized("type_leave"),
                                               value: leaveType?.name))
        
        detailItems.append(ConfirmRequestItem(imageName: "ic_clock_2",
                                              header: LocalizationHelper.shared.localized("created_at"),
                                              value: selectedRequest.createAt?.toString(dateFormat: AppConstant.requestDateFormat)))
    }

    func appendTrackingItem() {
        if let trackingType = leaveType?.trackingTimeType {
            switch trackingType {
            case .both:
                detailItems.append(ConfirmRequestItem(imageName: "ic_clock_2",
                                                       header: LocalizationHelper.shared.localized("from"),
                                                       value: selectedRequest.checkInTime?.toString(dateFormat: AppConstant.requestDateFormat)))
                detailItems.append(ConfirmRequestItem(imageName: "ic_clock_2",
                                                       header: LocalizationHelper.shared.localized("to"),
                                                       value: selectedRequest.checkOutTime?.toString(dateFormat: AppConstant.requestDateFormat)))
            case .checkOut:
                detailItems.append(ConfirmRequestItem(imageName: "ic_clock_2",
                                                       header: LocalizationHelper.shared.localized("title_forgot_out"),
                                                       value: selectedRequest.checkOutTime?.toString(dateFormat: AppConstant.requestDateFormat)))
            default:
                detailItems.append(ConfirmRequestItem(imageName: "ic_clock_2",
                                                       header: LocalizationHelper.shared.localized("title_forgot_in"),
                                                       value: selectedRequest.checkInTime?.toString(dateFormat: AppConstant.requestDateFormat)))
                break
            }
        }
    }

    func appendStatusItem() {
        detailItems.append(ConfirmRequestItem(imageName: "ic_reason",
                                              header: LocalizationHelper.shared.localized("status"),
                                              value: selectedRequest.status?.localizedString()))
        detailItems.append(ConfirmRequestItem(imageName: "ic_reason",
                                              header: LocalizationHelper.shared.localized("being_handled_by"),
                                              value: selectedRequest.handleByGroupName))
    }

    func appendCompensationItem() {
        if leaveType?.compensationKind == .require {
            detailItems.append(ConfirmRequestItem(imageName: "ic_clock_2",
                                                  header: LocalizationHelper.shared.localized("from"),
                                                  value: selectedRequest.compensation?.compensationFrom?.toString(dateFormat: AppConstant.requestDateFormat)))
            detailItems.append(ConfirmRequestItem(imageName: "ic_clock_2",
                                                  header: LocalizationHelper.shared.localized("to"),
                                                  value: selectedRequest.compensation?.compensationTo?.toString(dateFormat: AppConstant.requestDateFormat)))
            detailItems.append(ConfirmRequestItem(imageName: "ic_reason",
                                                  header: LocalizationHelper.shared.localized("reason"),
                                                  value: selectedRequest.reason))
        }
    }

    @IBAction func deleteButtonClick(_ sender: Any) {
        AlertHelper.showConfirm(message: LocalizationHelper.shared.localized("do_you_want_delete_this_request"),
                                makesureLoadingHidden: true,
                                handler: { (alert) in self.deleteRequest()})
    }

    @IBAction func editButtonClick(_ sender: Any) {
        if let editVc = UIViewController.getStoryboardController(identifier: "CreateRequestLeaveViewController")
            as? CreateRequestLeaveViewController {
            editVc.requestModel = selectedRequest.toApiInputModel()
            self.navigationController?.pushViewController(editVc, animated: true)
        }
    }

    func deleteRequest() {
        guard let id = self.selectedRequest.id else {
            return
        }
        AlertHelper.showLoading()
        RequestLeaveProvider.deleteRequestLeave(id: id)
            .then { apiOutput -> Void in
                if apiOutput.isSucceeded() {
                    AlertHelper.showInfo(message: apiOutput.message, makesureLoadingHidden: true, handler: { (alert) in
                        self.listRequestDelegate?.getListRequests()
                        self.navigationController?.popViewController(animated: true)
                    })
                }
            }.catch { error in
                AlertHelper.showError(error: error)
            }.always {
                AlertHelper.hideLoading()
        }
    }
}

extension RequestLeaveDetailViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmCreateLeaveCell", for: indexPath)
            as? ConfirmCreateRequestCell else {
                return UITableViewCell()
        }

        if indexPath.section == 0 {
            cell.updateCell(item: detailItems[indexPath.row])
            if statusCellIndex == indexPath.row {
                cell.valueLabel.textColor = selectedRequest.status?.getColor()
            }
        } else {
            let startIndex = detailItems.count - compensationRowNumber
            cell.updateCell(item: detailItems[startIndex + indexPath.row])
        }
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if leaveType?.compensationKind == .require {
            return section == 1 ? compensationRowNumber : detailItems.count - compensationRowNumber
        } else {
            return detailItems.count
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return leaveType?.compensationKind == .require ? 2 : 1
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return LocalizationHelper.shared.localized("compensation_time")
        }
        return nil
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.darkGray
        header.backgroundView?.backgroundColor = UIColor.white
    }
}
