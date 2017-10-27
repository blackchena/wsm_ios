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

    var requestModel = RequestOtApiInputModel()
    weak var listRequestDelegate: ListRequestDelegte?
    fileprivate var confirmReqOtItems = [DetailModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension

        confirmReqOtItems.append(contentsOf: DetailModel.getDefaultItem(workSpaceId: requestModel.workspaceId,
                                                                               groupId: requestModel.groupId,
                                                                               projectName: requestModel.projectName))


        confirmReqOtItems.append(DetailModel(imageName: "ic_clock_2",
                                                  header: LocalizationHelper.shared.localized("from"),
                                                  value: requestModel.fromTime))
        confirmReqOtItems.append(DetailModel(imageName: "ic_clock_2",
                                                  header: LocalizationHelper.shared.localized("to"),
                                                  value: requestModel.endTime))
        confirmReqOtItems.append(DetailModel(imageName: "ic_clock",
                                                  header: LocalizationHelper.shared.localized("number_of_overtime"),
                                                  value: requestModel.getOtTime()))
        confirmReqOtItems.append(DetailModel(imageName: "ic_reason",
                                                  header: LocalizationHelper.shared.localized("reason"),
                                                  value: requestModel.reason))
    }

    @IBAction func submitBtnClick(_ sender: Any) {
        AlertHelper.showLoading()
        if let id = self.requestModel.id {
            updateRequest(id: id)
        } else {
            createRequest()
        }
    }
    
    private func updateRequest(id: Int) {
        RequestOtProvider.updateOTRequest(id: id, requestModel: requestModel)
            .then { apiOutput -> Void in
                self.listRequestDelegate?.getListRequests()
                self.navigationController?.popToRootViewController(animated: true)
            }.catch { error in
                AlertHelper.showError(error: error)
            }.always {
                AlertHelper.hideLoading()
        }
    }
    
    private func createRequest() {
        RequestOtProvider.createOTRequest(requestModel: requestModel)
            .then { apiOutput -> Void in
                self.listRequestDelegate?.didCreateRequest()
                self.navigationController?.popToRootViewController(animated: true)
            }.catch { error in
                AlertHelper.showError(error: error)
            }.always {
                AlertHelper.hideLoading()
        }
    }
}

extension ConfirmCreateRequestOtViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmCreateOtCell", for: indexPath)
            as? ConfirmCreateRequestCell else {
                return UITableViewCell()
        }

        cell.updateCell(item: confirmReqOtItems[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return confirmReqOtItems.count
    }
}
