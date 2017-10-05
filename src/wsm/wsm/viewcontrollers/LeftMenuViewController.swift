//
//  LeftMenuViewController.swift
//  wsm
//
//  Created by framgia on 9/20/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import UIKit
import InAppLocalize

class LeftMenuViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    let rowHeight: CGFloat = 44.0
    let sectionHeight: CGFloat = 44.0
    let sectionNumber = 4
    var menuItems = [MenuItem]()

    let currentUser = UserServices.getLocalUserProfile()
    let isManager = UserServices.getLocalUserLogin()?.isManager ?? false

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        //user
        menuItems.append(MenuItem(image: "ic_personal_information",
                                  title: LocalizationHelper.shared.localized("personal_information"),
                                  group: MenuGroup.userInfo))
        menuItems.append(MenuItem(image: "ic_setup_profile",
                                  title: LocalizationHelper.shared.localized("setup_profile"),
                                  group: MenuGroup.userInfo))
        //manage request
        menuItems.append(MenuItem(image: "ic_overtime",
                                  title: LocalizationHelper.shared.localized("manage_request_overtime"),
                                  group: MenuGroup.manageRequest))
        menuItems.append(MenuItem(image: "ic_day_off",
                                  title: LocalizationHelper.shared.localized("manage_request_day_off"),
                                  group: MenuGroup.manageRequest))
        menuItems.append(MenuItem(image: "ic_clock",
                                  title: LocalizationHelper.shared.localized("manage_request_others"),
                                  group: MenuGroup.manageRequest))
        //user data
        menuItems.append(MenuItem(image: "ic_calendar_timesheet",
                                  title: LocalizationHelper.shared.localized("working_calendar"),
                                  group: MenuGroup.userData))
        menuItems.append(MenuItem(image: "ic_holiday_calendar",
                                  title: LocalizationHelper.shared.localized("holiday_calendar"),
                                  group: MenuGroup.userData))
        menuItems.append(MenuItem(image: "ic_statistic_personal",
                                  title: LocalizationHelper.shared.localized("statistics_of_personal"),
                                  group: MenuGroup.userData))
        //user requset
        menuItems.append(MenuItem(image: "ic_overtime",
                                  title: LocalizationHelper.shared.localized("overtime"),
                                  group: MenuGroup.userRequest))
        menuItems.append(MenuItem(image: "ic_day_off",
                                  title: LocalizationHelper.shared.localized("day_off"),
                                  group: MenuGroup.userRequest))
        menuItems.append(MenuItem(image: "ic_clock",
                                  title: LocalizationHelper.shared.localized("other"),
                                  group: MenuGroup.userRequest))

        if let header = Bundle.main.loadNibNamed("LeftMenuHeaderCell", owner: self, options: nil)?.first
            as? LeftMenuHeaderCell {
            tableView.tableHeaderView = header
            header.logoutAction = { [weak self] in
                    self?.logout()
            }
        }
    }
}

extension LeftMenuViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LeftMenuCell", for: indexPath)
            as? LeftMenuCell else {
                return UITableViewCell()
        }

        let items = self.getMenuItemsForSection(section: indexPath.section)

        if items.count == 0 {
            return UITableViewCell()
        } else {
            cell.updateCell(item: items[indexPath.row])
            return cell
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionNumber
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getMenuItemsForSection(section: section).count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return isManager ? rowHeight : 0.0
        }
        return rowHeight
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return isManager ? sectionHeight : 0.0
        }
        return sectionHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainViewController = sideMenuController!
        let rootViewController = mainViewController.rootViewController
        let timeSheetViewController = UIViewController.getStoryboardController(identifier: "TimeSheetViewController")

        guard let navigationController = rootViewController as? NavigationController else {
            return
        }

        var selectedViewController: UIViewController!

        switch (indexPath.section, indexPath.row) {
        //user profile
        case (0, 0):
            selectedViewController = UIViewController.getStoryboardController(identifier: "UserInfoViewController")
        case (0, 1):
            break
        //manage request
        case (1, 0):
            break
        case (1, 1):
            break
        case (1, 2):
            break
        //user data
        case (2, 0):
            selectedViewController = timeSheetViewController
        case (2, 1):
            break
        case (2, 2):
            break
        //user request
        case (3, 0):
            selectedViewController = UIViewController.getStoryboardController(identifier: "ListReuqestOtViewController")
        case (3, 1):
            break
        case (3, 2):
            selectedViewController = UIViewController.getStoryboardController(identifier: "ListReuqestLeaveViewController")
        default:
            break
        }

        navigationController.setViewControllers(
            [selectedViewController == nil ? timeSheetViewController : selectedViewController], animated: false)
        mainViewController.hideLeftView(animated: true, delay: 0.0, completionHandler: nil)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerCell = Bundle.main.loadNibNamed("LeftMenuSectionCell", owner: self, options: nil)?.first
            as? LeftMenuSectionCell {
            switch section {
            case 0:
                headerCell.headerLabel.text = LocalizationHelper.shared.localized("profile")
            case 1:
                headerCell.headerLabel.text = LocalizationHelper.shared.localized("manage_requests")
            case 2:
                headerCell.headerLabel.text = LocalizationHelper.shared.localized("personal_data")
            case 3:
                headerCell.headerLabel.text = LocalizationHelper.shared.localized("personal_request")
            default:
                headerCell.headerLabel.text = ""
            }
            return headerCell
        } else {
            return UIView()
        }
    }

    private func getMenuItemsForSection(section: Int) -> [MenuItem] {
        var items = [MenuItem]()
        for item in menuItems {
            switch section {
            case 0:
                if item.group == MenuGroup.userInfo {
                    items.append(item)
                }
            case 1:
                if item.group == MenuGroup.manageRequest {
                    items.append(item)
                }
                break
            case 2:
                if item.group == MenuGroup.userData {
                    items.append(item)
                }
            case 3:
                if item.group == MenuGroup.userRequest {
                    items.append(item)
                }
            default:
                break
            }
        }
        return items
    }
}

extension LeftMenuViewController {
    func logout() {
        AlertHelper.showLoading()
        LoginProvider.logout()
            .then{ _ -> Void in
                UserServices.clearAllUserData()
                AppDelegate.showLoginPage()
            }
            .always {
                AlertHelper.hideLoading()
        }
            .catch { error in
                AlertHelper.showError(error: error)
        }
    }
}

struct MenuItem {
    var image: String
    var title: String
    var group: MenuGroup
}
