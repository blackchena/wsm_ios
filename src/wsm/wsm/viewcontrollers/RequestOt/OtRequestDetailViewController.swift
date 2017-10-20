//
//  OtRequestDetailViewController.swift
//  wsm
//
//  Created by DaoLQ on 10/17/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import InAppLocalize

class OtRequestDetailViewController : NoMenuBaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deleteButton: LocalizableButton!
    @IBOutlet weak var editButton: LocalizableButton!
    @IBOutlet weak var deleteButtonHeight: NSLayoutConstraint!

    weak var listRequestDelegate: ListRequestDelegte?
    var otRequest = RequestOtModel()
    fileprivate var detailItems = [ConfirmRequestItem]()
    fileprivate var statusCellIndex = -1
    private let currentUser = UserServices.getLocalUserProfile()
    private let statusRowNumber = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if otRequest.status != RequestStatus.pending {
            deleteButtonHeight.constant = 0
        }
        
        appendDefaultItems()
        appendTrackingItems()
        appendStatusItems()
        
        statusCellIndex = detailItems.count - statusRowNumber
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private func appendDefaultItems() {
        detailItems.append(ConfirmRequestItem(imageName: "ic_placeholder_user", header: LocalizationHelper.shared.localized("employee_name"),
                                              value: currentUser?.name))
        detailItems.append(ConfirmRequestItem(imageName: "ic_id_card",
                                              header: LocalizationHelper.shared.localized("employee_code"),
                                              value: currentUser?.employeeCode))
        detailItems.append(ConfirmRequestItem(imageName: "ic_branch",
                                              header: LocalizationHelper.shared.localized("branch"),
                                              value: otRequest.workSpace?.name))
        detailItems.append(ConfirmRequestItem(imageName: "ic_group",
                                              header: LocalizationHelper.shared.localized("group"),
                                              value: otRequest.group?.fullName))
        detailItems.append(ConfirmRequestItem(imageName: "ic_project",
                                              header: LocalizationHelper.shared.localized("project_name"),
                                              value: otRequest.projectName))
    }
    
    private func appendTrackingItems() {
        detailItems.append(ConfirmRequestItem(imageName: "ic_clock_2",
                                              header: LocalizationHelper.shared.localized("from"),
                                              value: otRequest.fromTime?.toString(dateFormat: AppConstant.requestDateFormat)))
        detailItems.append(ConfirmRequestItem(imageName: "ic_clock_2",
                                              header: LocalizationHelper.shared.localized("to"),
                                              value: otRequest.endTime?.toString(dateFormat: AppConstant.requestDateFormat)))
        if let numberHours = otRequest.getNumberHours() {
            detailItems.append(ConfirmRequestItem(imageName: "ic_clock_2",
                                                  header: LocalizationHelper.shared.localized("number_hour"),
                                                  value: String(format: "%.2f", numberHours)))
        }
        detailItems.append(ConfirmRequestItem(imageName: "ic_reason",
                                              header: LocalizationHelper.shared.localized("reason"),
                                              value: otRequest.reason))
    }
    
    private func appendStatusItems() {
        detailItems.append(ConfirmRequestItem(imageName: "ic_reason",
                                              header: LocalizationHelper.shared.localized("status"),
                                              value: otRequest.status?.localizedString()))
        detailItems.append(ConfirmRequestItem(imageName: "ic_reason",
                                              header: LocalizationHelper.shared.localized("being_handled_by"),
                                              value: otRequest.handleBy))
    }
}

extension OtRequestDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmCreateRequestCell", for: indexPath) as? ConfirmCreateRequestCell else { return UITableViewCell() }
        cell.updateCell(item: detailItems[indexPath.row])
        if statusCellIndex == indexPath.row {
            cell.valueLabel.textColor = otRequest.status?.getColor()
        } else {
            cell.valueLabel.textColor = UIColor.black
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailItems.count
    }
}
