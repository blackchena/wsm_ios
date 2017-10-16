//
//  RequestOffDetailViewController.swift
//  wsm
//
//  Created by framgia on 10/13/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import InAppLocalize

class RequestOffDetailViewController: NoMenuBaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deleteButton: LocalizableButton!
    @IBOutlet weak var editButton: LocalizableButton!
    @IBOutlet weak var deleteButtonHeight: NSLayoutConstraint!

    var selectedRequest = RequestOffModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        if selectedRequest.status != .pending {
            deleteButtonHeight.constant = 0
            view.layoutIfNeeded()
        }

        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    @IBAction func deleteButtunClick(_ sender: Any) {
        AlertHelper.showConfirm(message: LocalizationHelper.shared.localized("do_you_want_delete_this_request"),
                                makesureLoadingHidden: true,
                                handler: { (alert) in self.deleteRequest()})
    }

    func deleteRequest() {
        guard let id = self.selectedRequest.id else {
            return
        }
        AlertHelper.showLoading()
        RequestOffProvider.deleteRequestOff(id: id)
            .then { apiOutput -> Void in
                if apiOutput.isSucceeded() {
                    AlertHelper.showInfo(message: apiOutput.message, makesureLoadingHidden: true, handler: { (alert) in
                        RequestLeaveProvider.shared.isNeedRefreshList = true
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
