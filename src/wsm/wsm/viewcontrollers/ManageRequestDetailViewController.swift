//
//  ManageRequestDetailViewController.swift
//  wsm
//
//  Created by DaoLQ on 1/3/18.
//  Copyright © 2018 framgia. All rights reserved.
//

import UIKit
import InAppLocalize

class ManageRequestDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var updateRequestDelegate: UpdateRequestDelegate?
    var overTimeRequest: RequestOtModel?
    var dayOffRequest: RequestDayOffModel?
    var othersRequest: RequestLeaveModel?
    fileprivate var items = [DetailModel]()
    private var requestType: RequestType

    init(requestType: RequestType) {
        self.requestType = requestType
        super.init(nibName: "ManageRequestDetailViewController", bundle: nil)
        modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.requestType = .others
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch requestType {
        case .overTime:
            initDataForOvertimeRequest()
        case .dayOff:
            initDataForDayOffRequest()
        case .others:
            initDataForOthersRequest()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView?.register(UINib(nibName: "RequestDetailCell", bundle: nil), forCellReuseIdentifier: "RequestDetailCell")
    }
    
    @IBAction func closeButtonClick(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func rejectButtonClick(_ sender: Any) {
        handleAceptRejectRequest(handleRequestType: .rejectSingleRequest)
    }
    
    @IBAction func acceptButtonClick(_ sender: Any) {
        handleAceptRejectRequest(handleRequestType: .approveSingleRequest)
    }
    
    private func handleAceptRejectRequest(handleRequestType: HandleRequestType) {
        guard let requestId = requestType == .overTime ? overTimeRequest?.id : (requestType == .dayOff ? dayOffRequest?.id : othersRequest?.id) else {
            return
        }
        AlertHelper.showLoading()
        ManageRequestProvider.acceptRequest(requestType: self.requestType, handleRequestType: handleRequestType, requestIds: [requestId])
            .then{ apiOutput -> Void in
                self.updateRequestDelegate?.onRequestUpdated()
                AlertHelper.showInfo(message: apiOutput.message, makesureLoadingHidden: true, handler:
                    { (alert) in
                        self.dismiss(animated: false, completion: nil)
                })
            }.catch { error in
                AlertHelper.showError(error: error)
            }.always {
                AlertHelper.hideLoading()
        }
    }
}

// Delegate, DataSource for TableView
extension ManageRequestDetailViewController: UITableViewDelegate, UITableViewDataSource {
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestDetailCell") as! RequestDetailCell
        cell.updateCell(item: items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

// Init Data corresponding request type
extension ManageRequestDetailViewController {
    
    fileprivate func initDataForOvertimeRequest() {
        items.append(DetailModel(imageName: "ic_clock_2",
                                 header: LocalizationHelper.shared.localized("created_at"),
                                 value: overTimeRequest?.createAt?.toString(dateFormat: AppConstant.requestDateFormat)))
        items.append(DetailModel(imageName: "ic_placeholder_user",
                                 header: LocalizationHelper.shared.localized("employee_name"),
                                 value: overTimeRequest?.user?.name))
        items.append(DetailModel(imageName: "ic_id_card",
                                 header: LocalizationHelper.shared.localized("employee_code"),
                                 value: overTimeRequest?.user?.employeeCode))
        if let projectName = overTimeRequest?.projectName {
            if projectName.isNotEmpty {
                items.append(DetailModel(imageName: "ic_project",
                                         header: LocalizationHelper.shared.localized("project_name"),
                                         value: projectName))
            }
        }
        items.append(DetailModel(imageName: "ic_branch",
                                 header: LocalizationHelper.shared.localized("branch"),
                                 value: overTimeRequest?.workSpace?.name))
        items.append(DetailModel(imageName: "ic_group",
                                 header: LocalizationHelper.shared.localized("group"),
                                 value: overTimeRequest?.group?.fullName))
        items.append(DetailModel(imageName: "ic_reason",
                                 header: LocalizationHelper.shared.localized("being_handled_by"),
                                 value: overTimeRequest?.handleBy))
        items.append(DetailModel(imageName: "ic_material_status",
                                 header: LocalizationHelper.shared.localized("status"),
                                 value: overTimeRequest?.status?.localizedString()))
        items.append(DetailModel(imageName: "ic_clock_2",
                                 header: LocalizationHelper.shared.localized("from"),
                                 value: overTimeRequest?.fromTime?.toString(dateFormat: AppConstant.requestDateFormat)))
        items.append(DetailModel(imageName: "ic_clock_2",
                                 header: LocalizationHelper.shared.localized("to"),
                                 value: overTimeRequest?.endTime?.toString(dateFormat: AppConstant.requestDateFormat)))
        items.append(DetailModel(imageName: "ic_clock_2",
                                 header: LocalizationHelper.shared.localized("number_hour"),
                                 value: overTimeRequest?.getDurationTimes()))
        items.append(DetailModel(imageName: "ic_reason",
                                 header: LocalizationHelper.shared.localized("reason"),
                                 value: overTimeRequest?.reason))
    }
    
    fileprivate func initDataForDayOffRequest() {
        items.append(DetailModel(imageName: "ic_clock_2",
                                 header: LocalizationHelper.shared.localized("created_at"),
                                 value: dayOffRequest?.createdAt?.toString(dateFormat: AppConstant.requestDateFormat)))
        items.append(DetailModel(imageName: "ic_placeholder_user",
                                 header: LocalizationHelper.shared.localized("employee_name"),
                                 value: dayOffRequest?.user?.name))
        items.append(DetailModel(imageName: "ic_id_card",
                                 header: LocalizationHelper.shared.localized("employee_code"),
                                 value: dayOffRequest?.user?.employeeCode))
        if let projectName = dayOffRequest?.projectName {
            if projectName.isNotEmpty {
            items.append(DetailModel(imageName: "ic_project",
                                     header: LocalizationHelper.shared.localized("project_name"),
                                     value: projectName))
            }
        }
        items.append(DetailModel(imageName: "ic_branch",
                                 header: LocalizationHelper.shared.localized("branch"),
                                 value: dayOffRequest?.workSpace?.name))
        items.append(DetailModel(imageName: "ic_group",
                                 header: LocalizationHelper.shared.localized("group"),
                                 value: dayOffRequest?.group?.fullName))
        items.append(DetailModel(imageName: "ic_reason",
                                 header: LocalizationHelper.shared.localized("being_handled_by"),
                                 value: dayOffRequest?.handleByGroupName))
        items.append(DetailModel(imageName: "ic_material_status",
                                 header: LocalizationHelper.shared.localized("status"),
                                 value: dayOffRequest?.status?.localizedString()))
        items.append(DetailModel(imageName: "ic_clock_2",
                                     header: LocalizationHelper.shared.localized("time_off"),
                                     value: dayOffRequest?.getRequestTimeString()))
        items.append(DetailModel(imageName: "ic_clock_2",
                                 header: LocalizationHelper.shared.localized("total"),
                                 value: dayOffRequest?.totalDayOff))
        if let userReplacementName = dayOffRequest?.replacement?.name {
            items.append(DetailModel(imageName: "ic_project",
                                     header: LocalizationHelper.shared.localized("replacement"),
                                     value: userReplacementName))
        }
        items.append(DetailModel(imageName: "ic_reason",
                                 header: LocalizationHelper.shared.localized("reason"),
                                 value: dayOffRequest?.reason))
    }
    
    fileprivate func initDataForOthersRequest() {
        items.append(DetailModel(imageName: "ic_clock_2",
                                 header: LocalizationHelper.shared.localized("created_at"),
                                 value: othersRequest?.createAt?.toString(dateFormat: AppConstant.requestDateFormat)))
        items.append(DetailModel(imageName: "ic_placeholder_user",
                                 header: LocalizationHelper.shared.localized("employee_name"),
                                 value: othersRequest?.user?.name))
        items.append(DetailModel(imageName: "ic_id_card",
                                 header: LocalizationHelper.shared.localized("employee_code"),
                                 value: othersRequest?.user?.employeeCode))
        if let projectName = othersRequest?.projectName {
            if projectName.isNotEmpty {
                items.append(DetailModel(imageName: "ic_project",
                                         header: LocalizationHelper.shared.localized("project_name"),
                                         value: projectName))
            }
        }
        items.append(DetailModel(imageName: "ic_branch",
                                 header: LocalizationHelper.shared.localized("branch"),
                                 value: othersRequest?.workspace?.name))
        items.append(DetailModel(imageName: "ic_group",
                                 header: LocalizationHelper.shared.localized("group"),
                                 value: othersRequest?.group?.fullName))
        items.append(DetailModel(imageName: "ic_reason",
                                 header: LocalizationHelper.shared.localized("being_handled_by"),
                                 value: othersRequest?.handleByGroupName))
        items.append(DetailModel(imageName: "ic_material_status",
                                 header: LocalizationHelper.shared.localized("status"),
                                 value: othersRequest?.status?.localizedString()))
        items.append(DetailModel(imageName: "ic_clock_2",
                                 header: LocalizationHelper.shared.localized("time_request"),
                                 value: othersRequest?.getRequestTimeString()))
        items.append(DetailModel(imageName: "ic_project",
                                 header: LocalizationHelper.shared.localized("type_leave"),
                                 value: othersRequest?.leaveType?.name))
        items.append(DetailModel(imageName: "ic_clock_2",
                                 header: LocalizationHelper.shared.localized("compensation_time"),
                                 value: othersRequest?.compensation?.getCompensationTime()))
        items.append(DetailModel(imageName: "ic_reason",
                                 header: LocalizationHelper.shared.localized("reason"),
                                 value: othersRequest?.reason))
    }
}
