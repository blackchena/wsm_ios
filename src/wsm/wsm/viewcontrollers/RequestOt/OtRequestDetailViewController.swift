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
    fileprivate var detailItems = [DetailModel]()
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
    
    @IBAction func deleteRequestButtonClicked(_ sender: Any) {
        AlertHelper.showConfirm(message: LocalizationHelper.shared.localized("do_you_want_delete_this_request"),
                                makesureLoadingHidden: true,
                                handler: { (alert) in self.deleteRequest()})
    }
    
    @IBAction func editRequestButtonClicked(_ sender: Any) {
        if let editVc = getViewController(identifier: "CreateRequestOtViewController")
            as? CreateRequestOtViewController {
            editVc.requestModel = otRequest.toApiInputMode()
            editVc.listRequestDelegate = self.listRequestDelegate
            self.navigationController?.pushViewController(editVc, animated: true)
        }
    }
    
    private func appendDefaultItems() {
        detailItems.append(contentsOf: DetailModel.getDefaultItem(workSpaceName: otRequest.workSpace?.name,
                                                                         groupName: otRequest.group?.fullName,
                                                                         projectName: otRequest.projectName,
                                                                         userProfileModel: otRequest.user))
    }
    
    private func appendTrackingItems() {
        detailItems.append(DetailModel(imageName: "ic_clock_2",
                                              header: LocalizationHelper.shared.localized("from"),
                                              value: otRequest.fromTime?.toString(dateFormat: AppConstant.requestDateFormat)))
        detailItems.append(DetailModel(imageName: "ic_clock_2",
                                              header: LocalizationHelper.shared.localized("to"),
                                              value: otRequest.endTime?.toString(dateFormat: AppConstant.requestDateFormat)))
        if let otHours = otRequest.otHours {
            detailItems.append(DetailModel(imageName: "ic_clock_2",
                                                  header: LocalizationHelper.shared.localized("number_hour"),
                                                  value: String(format: "%.2f", otHours)))
        }
        detailItems.append(DetailModel(imageName: "ic_reason",
                                              header: LocalizationHelper.shared.localized("reason"),
                                              value: otRequest.reason))
    }
    
    private func appendStatusItems() {
        detailItems.append(DetailModel(imageName: "ic_reason",
                                              header: LocalizationHelper.shared.localized("status"),
                                              value: otRequest.status?.localizedString()))
        detailItems.append(DetailModel(imageName: "ic_reason",
                                              header: LocalizationHelper.shared.localized("being_handled_by"),
                                              value: otRequest.handleBy))
    }
    
    private func deleteRequest() {
        guard let id = self.otRequest.id else {
            return
        }
        AlertHelper.showLoading()
        RequestOtProvider.deleteOtRequest(id: id)
            .then { apiOutput -> Void in
                self.listRequestDelegate?.getListRequests()
                AlertHelper.showInfo(message: apiOutput.message, makesureLoadingHidden: true, handler: { (alert) in
                    self.navigationController?.popViewController(animated: true)
                })
            }.catch { error in
                AlertHelper.showError(error: error)
            }.always {
                AlertHelper.hideLoading()
        }
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
