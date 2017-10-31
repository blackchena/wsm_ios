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
        
    var requestType: RequestType
    var manageRequestApiInput = ManageRequestApiInputModel()
    
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
    }
    
    @objc private func pullToRefreshHandler(_: Any) {
        getListManageRequest()
    }
    
    func getListManageRequest(page: Int = 1) {
        if isLoading {
            return
        }
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
                        ManageRequestProvider.shared.leaveRequests.append(contentsOf: apiOutput.leaveRequests)
                        self.tableView.reloadData()
                    }
                } else {
                    ManageRequestProvider.shared.leaveRequests = apiOutput.leaveRequests
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
                        ManageRequestProvider.shared.otRequests.append(contentsOf: apiOutput.overtimeRequests)
                        self.tableView.reloadData()
                    }
                } else {
                    ManageRequestProvider.shared.otRequests = apiOutput.overtimeRequests
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
                        ManageRequestProvider.shared.offRequests.append(contentsOf: apiOutput.offRequests)
                        self.tableView.reloadData()
                    }
                } else {
                    ManageRequestProvider.shared.offRequests = apiOutput.offRequests
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ManageRequestTableViewCell")
        if let cell = cell {
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch requestType {
        case .others:
            return ManageRequestProvider.shared.leaveRequests.count
        case .overTime:
            return ManageRequestProvider.shared.otRequests.count
        case .dayOff:
            return ManageRequestProvider.shared.offRequests.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch requestType {
        case .others:
            if indexPath.row == ManageRequestProvider.shared.leaveRequests.count - 1 {
                getListManageRequest(page: currentPage + 1)
            }
        case .overTime:
            if indexPath.row == ManageRequestProvider.shared.otRequests.count - 1 {
                getListManageRequest(page: currentPage + 1)
            }
        case .dayOff:
            if indexPath.row == ManageRequestProvider.shared.offRequests.count - 1 {
                getListManageRequest(page: currentPage + 1)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let accept = UITableViewRowAction(style: .normal, title: "Accept") { action, index in
            // TODOs: handle accept action later
        }
        accept.backgroundColor = UIColor(hexString: "0x50A298")
        
        let reject = UITableViewRowAction(style: .normal, title: "Reject") { action, index in
            // TODOs: handle reject action later
        }
        reject.backgroundColor = UIColor.red
        
        return [reject, accept]
    }
}
