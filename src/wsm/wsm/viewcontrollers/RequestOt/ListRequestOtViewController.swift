//
//  ListRequestOtViewController.swift
//  wsm
//
//  Created by framgia on 9/25/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import Floaty

class ListRequestOtViewController: BaseViewController, FloatyDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var filterView: RequestFilterView!
    
    private let floaty = Floaty()
    private let refreshControl = UIRefreshControl()
    lazy fileprivate var spiner: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        indicatorView.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: self.tableView.bounds.width, height: CGFloat(44))
        indicatorView.color = UIColor.appBarTintColor
        indicatorView.startAnimating()
        return indicatorView
    }()
    
    fileprivate var currentPage = 1
    private var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "RequestOTCell", bundle: nil), forCellReuseIdentifier: "RequestOTCell")
        tableView.tableFooterView?.isHidden = false
        
        // Add Refresh control to TableView
        refreshControl.addTarget(self, action: #selector(pullToRefreshHandler(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor.appBarTintColor
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        getListRequestOts();
        
        createRequestButton()
        
        filterView.filterAction = { [weak self] in
            self?.getListRequestOts()
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
        let createOtVc = UIViewController.getStoryboardController(identifier: "CreateRequestOtViewController")
        self.navigationController?.pushViewController(createOtVc, animated: true)
    }
    
    func getListRequestOts(page: Int = 1) {
        if isLoading {
            return
        }
        print("Load requests")
        AlertHelper.showLoading()
        isLoading = true
        RequestOtProvider.getListRequestOts(page: page, month: self.filterView.getMonthYearSelectedString(), status: self.filterView.getStatusSelected())
            .then {
                    apiOutput -> Void in
                if page > 1 {
                    if apiOutput.listRequestOts.count > 0 {
                        RequestOtProvider.shared.listRequestOts.append(contentsOf: apiOutput.listRequestOts)
                        self.tableView.reloadData()
                    }
                } else {
                    RequestOtProvider.shared.listRequestOts = apiOutput.listRequestOts
                    self.tableView.reloadData()
                }
                self.currentPage = page
            }.recover { error in
                AlertHelper.showError(error: error)
            }.always {
                AlertHelper.hideLoading()
                self.refreshControl.endRefreshing()
                self.isLoading = false
                self.tableView.tableFooterView = nil
        }
    }
    
    @objc private func pullToRefreshHandler(_: Any) {
        getListRequestOts()
    }
}

extension ListRequestOtViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestOTCell", for: indexPath)
        if let cell = cell as? RequestOTCell {
            cell.updateCell(request: RequestOtProvider.shared.listRequestOts[indexPath.row])
        }
        return cell;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RequestOtProvider.shared.listRequestOts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == RequestOtProvider.shared.listRequestOts.count - 1 {
            self.tableView.tableFooterView = spiner
            getListRequestOts(page: currentPage + 1)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRequest = RequestOtProvider.shared.listRequestOts[indexPath.row]
        if let otRequestDetailVc = UIViewController.getStoryboardController(identifier: "OtRequestDetailViewController") as? OtRequestDetailViewController {
            otRequestDetailVc.otRequest = selectedRequest
            otRequestDetailVc.listRequestDelegate = self
            self.navigationController?.pushViewController(otRequestDetailVc, animated: true)
        }
    }
}

extension ListRequestOtViewController: ListRequestDelegte {
    func getListRequests() {
        getListRequestOts()
    }

    func didCreateRequest() {
        filterView.resetConditions()
        getListRequestOts()
    }
}
