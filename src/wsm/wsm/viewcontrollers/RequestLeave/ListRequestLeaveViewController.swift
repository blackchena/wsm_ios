//
//  ListRequestLeaveViewController.swift
//  wsm
//
//  Created by framgia on 9/28/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import Floaty

class ListReuqestLeaveViewController: BaseViewController, FloatyDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterView: RequestFilterView!

    fileprivate let floaty = Floaty()
    fileprivate var currentPage = 1
    fileprivate var isLoading = false
    fileprivate let refreshControl = UIRefreshControl()
    fileprivate lazy var spinner: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        indicatorView.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: self.tableView.bounds.width, height: CGFloat(44))
        indicatorView.color = UIColor.appBarTintColor
        indicatorView.startAnimating()
        return indicatorView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "RequestLeaveCell", bundle: nil), forCellReuseIdentifier: "RequestLeaveCell")
        tableView.tableFooterView?.isHidden = false

        // Add Refresh Control to Table View
        refreshControl.addTarget(self, action: #selector(pullToRefreshHandler(_:)), for: .valueChanged)
        refreshControl.tintColor = .appBarTintColor
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }

        getListRequests(page: currentPage)
        createRequestButton()

        filterView.filterAction = { [weak self] in
            self?.getListRequests()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func createRequestButton() {
        floaty.paddingX = floaty.paddingY
        floaty.fabDelegate = self
        floaty.buttonColor = UIColor.appBarTintColor
        floaty.buttonImage = UIImage(named: "ic_add")
        self.view.addSubview(floaty)
    }

    func emptyFloatySelected(_ floaty: Floaty) {
        let createOtVc = UIViewController.getStoryboardController(identifier: "CreateRequestLeaveViewController")
        self.navigationController?.pushViewController(createOtVc, animated: true)
    }

    @objc private func pullToRefreshHandler(_: Any) {
        getListRequests()
    }

    func getListRequests(page: Int = 1) {
        if isLoading {
            return
        }
        print("Load requests")
        AlertHelper.showLoading()
        isLoading = true
        RequestLeaveProvider.getListRequestLeaves(page: page,
                                                  month: self.filterView.getMonthYearSelectedString(),
                                                  status: self.filterView.getStatusSelected())
            .then { apiOutput -> Void in
                if page > 1 {
                    if apiOutput.listRequestLeaves.count > 0 {
                        RequestLeaveProvider.shared.listRequests.append(contentsOf: apiOutput.listRequestLeaves)
                        self.tableView.reloadData()
                    }
                } else {
                    RequestLeaveProvider.shared.listRequests = apiOutput.listRequestLeaves
                    self.tableView.reloadData()
                }
                self.currentPage = page
            }.catch { error in
                AlertHelper.showError(error: error)
            }.always {
                AlertHelper.hideLoading()
                self.refreshControl.endRefreshing()
                self.isLoading = false
                self.tableView.tableFooterView = nil
        }
    }
}

extension ListReuqestLeaveViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestLeaveCell", for: indexPath) as! RequestLeaveCell
        cell.updateRequestLeaveCell(request: RequestLeaveProvider.shared.listRequests[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RequestLeaveProvider.shared.listRequests.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == RequestLeaveProvider.shared.listRequests.count - 1 {
            self.tableView.tableFooterView = spinner
            getListRequests(page: currentPage + 1)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRequest = RequestLeaveProvider.shared.listRequests[indexPath.row]
        if let detailtVc = UIViewController.getStoryboardController(identifier: "RequestLeaveDetailViewController")
                as? RequestLeaveDetailViewController {
            detailtVc.selectedRequest = selectedRequest
            detailtVc.listRequestDelegate = self
            self.navigationController?.pushViewController(detailtVc, animated: true)
        }
    }
}

extension ListReuqestLeaveViewController: ListRequestDelegte {
    func getListRequests() {
        getListRequests()
    }

    func didCreateRequest() {
        filterView.resetConditions()
        getListRequests()
    }
}
