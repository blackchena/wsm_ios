//
//  ManageRequestListViewController.swift
//  wsm
//
//  Created by DaoLQ on 10/26/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import InAppLocalize

class ManageRequestListViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterView: ManagerRequestFilterView!
    
    var requestType: RequestType
    var manageRequestApiInput = ManageRequestApiInputModel()
    
    fileprivate var leaveRequests = [RequestLeaveModel]()
    fileprivate var overtimeRequests = [RequestOtModel]()
    fileprivate var dayOffRequests = [RequestDayOffModel]()
    
    fileprivate var currentPage = 1
    fileprivate var isLoading = false
    fileprivate let refreshControl = UIRefreshControl()
    
    
    required init(type: RequestType) {
        self.requestType = type
        super.init(nibName: "ManageRequestListViewController", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = requestType.title
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView?.register(UINib(nibName: "ManageRequestTableViewCell", bundle: nil), forCellReuseIdentifier: "ManageRequestTableViewCell")
        
        // Add Refresh Control to Table View
        refreshControl.addTarget(self, action: #selector(pullToRefreshHandler(_:)), for: .valueChanged)
        refreshControl.tintColor = .appBarTintColor
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        getListManageRequest(page: currentPage)
        filterView.filterAction = { [weak self] in
            self?.getListManageRequest()
        }
    }
    
    @objc private func pullToRefreshHandler(_: Any) {
        getListManageRequest()
    }
    
    func getListManageRequest(page: Int = 1) {
        if isLoading {
            return
        }
        manageRequestApiInput.requestType = requestType
        manageRequestApiInput.page = currentPage
        manageRequestApiInput.timeFrom = filterView.timeFromTextField.text
        manageRequestApiInput.timeTo = filterView.timeToTextField.text
        manageRequestApiInput.keyword = filterView.memberNameTextFiled.text
        manageRequestApiInput.status = filterView.getStatusSelected()
        AlertHelper.showLoading()
        isLoading = true
        switch requestType {
        case .others:
            getLeaveRequests(page: page)
        case .overTime:
            getOvertimeRequests(page: page)
        case .dayOff:
            getDayOffRequests(page: page)
        }
        
    }
    
    private func getLeaveRequests(page: Int) {
        ManageRequestProvider.getListManageLeaveRequest(requestType: requestType, manageRequestApiInput: manageRequestApiInput)
            .then {apiOutput -> Void in
                if page > 1 {
                    if apiOutput.leaveRequests.count > 0 {
                        self.leaveRequests.append(contentsOf: apiOutput.leaveRequests)
                        self.tableView.reloadData()
                    }
                } else {
                    self.leaveRequests = apiOutput.leaveRequests
                    self.tableView.reloadData()
                }
                self.currentPage = page
            }.catch { error in
                AlertHelper.showError(error: error)
            }.always {
                AlertHelper.hideLoading()
                self.refreshControl.endRefreshing()
                self.isLoading = false
        }
    }
    
    private func getOvertimeRequests(page: Int) {
        ManageRequestProvider.getListManageOverTimeRequest(requestType: requestType, manageRequestApiInput: manageRequestApiInput)
            .then {apiOutput -> Void in
                if page > 1 {
                    if apiOutput.overtimeRequests.count > 0 {
                        self.overtimeRequests.append(contentsOf: apiOutput.overtimeRequests)
                        self.tableView.reloadData()
                    }
                } else {
                    self.overtimeRequests = apiOutput.overtimeRequests
                    self.tableView.reloadData()
                }
                self.currentPage = page
            }.catch { error in
                AlertHelper.showError(error: error)
            }.always {
                AlertHelper.hideLoading()
                self.refreshControl.endRefreshing()
                self.isLoading = false
        }
    }
    
    private func getDayOffRequests(page: Int) {
        ManageRequestProvider.getListManageOffRequest(requestType: requestType, manageRequestApiInput: manageRequestApiInput)
            .then {apiOutput -> Void in
                if page > 1 {
                    if apiOutput.offRequests.count > 0 {
                        self.dayOffRequests.append(contentsOf: apiOutput.offRequests)
                        self.tableView.reloadData()
                    }
                } else {
                    self.dayOffRequests = apiOutput.offRequests
                    self.tableView.reloadData()
                }
                self.currentPage = page
            }.catch { error in
                AlertHelper.showError(error: error)
            }.always {
                AlertHelper.hideLoading()
                self.refreshControl.endRefreshing()
                self.isLoading = false
        }
    }
}

extension ManageRequestListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ManageRequestTableViewCell") as! ManageRequestTableViewCell
        switch requestType {
        case .others:
            cell.updateLeaveRequestCell(leaveRequest: leaveRequests[indexPath.row])
        case .overTime:
            cell.updateOvertimeRequestCell(overtimeRequest: overtimeRequests[indexPath.row])
        case .dayOff:
            cell.updateOffRequestCell(offRequest: dayOffRequests[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch requestType {
        case .others:
            return self.leaveRequests.count
        case .overTime:
            return self.overtimeRequests.count
        case .dayOff:
            return self.dayOffRequests.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch requestType {
        case .others:
            if indexPath.row == self.leaveRequests.count - 1 {
                getListManageRequest(page: currentPage + 1)
            }
        case .overTime:
            if indexPath.row == self.overtimeRequests.count - 1 {
                getListManageRequest(page: currentPage + 1)
            }
        case .dayOff:
            if indexPath.row == self.dayOffRequests.count - 1 {
                getListManageRequest(page: currentPage + 1)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        var isVisibleHandleRequest : Bool?
        switch self.requestType {
        case .others:
            isVisibleHandleRequest = leaveRequests[indexPath.row].canApproveRejectRequest
        case .overTime:
            isVisibleHandleRequest = overtimeRequests[indexPath.row].canApproveRejectRequest
        case .dayOff:
            isVisibleHandleRequest = dayOffRequests[indexPath.row].canApproveRejectRequest
        }
        if let isVisibleHandleRequest = isVisibleHandleRequest {
            return isVisibleHandleRequest
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var requestId : Int?
        var requestIds = [Int]()
        switch self.requestType {
        case .others:
            requestId = self.leaveRequests[indexPath.row].id
        case .overTime:
            requestId = self.overtimeRequests[indexPath.row].id
        case .dayOff:
            requestId = self.dayOffRequests[indexPath.row].id
        }
        if let requestId = requestId {
            requestIds = [requestId]
        }
        
        let accept = UITableViewRowAction(style: .normal, title: LocalizationHelper.shared.localized("accept")) { action, index in
            self.handleAceptRejectRequest(handleRequestType: .approveSingleRequest , requestIds: requestIds)
        }
        accept.backgroundColor = UIColor(hexString: "0x50A298")
        
        let reject = UITableViewRowAction(style: .normal, title: LocalizationHelper.shared.localized("reject")) { action, index in
            self.handleAceptRejectRequest(handleRequestType: .rejectSingleRequest, requestIds: requestIds)
        }
        reject.backgroundColor = UIColor.red
        
        return [reject, accept]
    }
    
    private func handleAceptRejectRequest(handleRequestType: HandleRequestType ,requestIds: [Int]) {
        AlertHelper.showLoading()
        self.isLoading = true
        ManageRequestProvider.acceptRequest(requestType: self.requestType, handleRequestType: handleRequestType, requestIds: requestIds)
            .then{apiOutput -> Void in
                self.isLoading = false
                AlertHelper.showInfo(message: apiOutput.message, makesureLoadingHidden: true, handler:
                    { (alert) in
                        self.navigationController?.popViewController(animated: true)
                })
                self.getListManageRequest()
            }.catch { error in
                    AlertHelper.showError(error: error)
            }.always {
                AlertHelper.hideLoading()
                self.isLoading = false
        }
    }
}
