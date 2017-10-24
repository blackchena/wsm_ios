//
//  NotificationViewController.swift
//  wsm
//
//  Created by framgia on 10/20/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation

class NotificationViewController: NoMenuBaseViewController {

    @IBOutlet weak var tableView: UITableView!

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

        //read all notifications button
        let rightButton = UIButton(type: .custom)
        rightButton.setImage(UIImage(named: "ic_read_all"), for: .normal)
        rightButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        rightButton.addTarget(self, action: #selector(self.readAllNotifications), for: .touchUpInside)
        let rightBarButton = UIBarButtonItem(customView: rightButton)
        navigationItem.rightBarButtonItem = rightBarButton


        //setup tableview
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView?.isHidden = false

        // Add Refresh Control to Table View
        refreshControl.addTarget(self, action: #selector(pullToRefreshHandler(_:)), for: .valueChanged)
        refreshControl.tintColor = .appBarTintColor
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
    }

    @objc private func readAllNotifications() {
        print("read all")
    }


    @objc private func pullToRefreshHandler(_: Any) {
        getListNotifications()
    }

    func getListNotifications(page: Int = 1) {
        if isLoading {
            return
        }
        isLoading = true
        NotificationProvider.getListNotifications(page: page)
            .then { apiOutput -> Void in
                if page > 1 {
                    if apiOutput.listNotifications.count > 0 {
                        NotificationProvider.shared.listNotifications.append(contentsOf: apiOutput.listNotifications)
                        self.tableView.reloadData()
                    }
                } else {
                    UserServices.saveNotificationData(noticaitions: apiOutput)
                    NotificationProvider.shared.listNotifications = apiOutput.listNotifications
                    self.tableView.reloadData()
                }
                if let unreadCount = apiOutput.unreadCount {
                    NotificationProvider.shared.badgeValue = "\(unreadCount)"
                }
                self.currentPage = page
            }.catch { error in
                AlertHelper.showError(error: error)
            }.always {
                self.refreshControl.endRefreshing()
                self.isLoading = false
                self.tableView.tableFooterView = nil
        }
    }
}


extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        cell.updateCell(notification: NotificationProvider.shared.listNotifications[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NotificationProvider.shared.listNotifications.count
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == NotificationProvider.shared.listNotifications.count - 1 {
            self.tableView.tableFooterView = spinner
            getListNotifications(page: currentPage + 1)
        }
    }
}
