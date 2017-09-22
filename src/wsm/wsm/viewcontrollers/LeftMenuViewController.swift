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
    var menuItems = [MenuItem]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        menuItems.append(MenuItem(image: "ic_personal_information",
                                  title: LocalizationHelper.shared.localized("personal_information"),
                                  header: LocalizationHelper.shared.localized("profile"),
                                  group: MenuGroup.userInfo))
        menuItems.append(MenuItem(image: "ic_setup_profile",
                                  title: LocalizationHelper.shared.localized("setup_profile"),
                                  header: LocalizationHelper.shared.localized("profile"),
                                  group: MenuGroup.userInfo))
        menuItems.append(MenuItem(image: "ic_calendar_timesheet",
                                  title: LocalizationHelper.shared.localized("working_calendar"),
                                  header: LocalizationHelper.shared.localized("personal_data"),
                                  group: MenuGroup.userData))
        menuItems.append(MenuItem(image: "ic_holiday_calendar",
                                  title: LocalizationHelper.shared.localized("holiday_calendar"),
                                  header: LocalizationHelper.shared.localized("personal_data"),
                                  group: MenuGroup.userData))
        menuItems.append(MenuItem(image: "ic_statistic_personal",
                                  title: LocalizationHelper.shared.localized("statistics_of_personal"),
                                  header: LocalizationHelper.shared.localized("personal_data"),
                                  group: MenuGroup.userData))
        menuItems.append(MenuItem(image: "ic_overtime",
                                  title: LocalizationHelper.shared.localized("overtime"),
                                  header: LocalizationHelper.shared.localized("personal_request"),
                                  group: MenuGroup.userRequest))
        menuItems.append(MenuItem(image: "ic_day_off",
                                  title: LocalizationHelper.shared.localized("day_off"),
                                  header: LocalizationHelper.shared.localized("personal_request"),
                                  group: MenuGroup.userRequest))
        menuItems.append(MenuItem(image: "ic_clock",
                                  title: LocalizationHelper.shared.localized("other"),
                                  header: LocalizationHelper.shared.localized("personal_request"),
                                  group: MenuGroup.userRequest))

        if let header = Bundle.main.loadNibNamed("LeftMenuHeaderCell", owner: self, options: nil)?.first
            as? LeftMenuHeaderCell {
            tableView.tableHeaderView = header
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
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getMenuItemsForSection(section: section).count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return rowHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mainViewController = sideMenuController!
        let rootViewController = mainViewController.rootViewController
        let timeSheetViewController = getStoryboardController(identifier: "TimeSheetViewController")

        guard let navigationController = rootViewController as? NavigationController else {
            return
        }

        var selectedViewController: UIViewController!

        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            selectedViewController = getStoryboardController(identifier: "UserInfoViewController")
        case (0, 1):
            break
        case (1, 0):
            selectedViewController = timeSheetViewController
        case (1, 1):
            break
        case (1, 2):
            break
        case (2, 0):
            break
        case (2, 1):
            break
        case (2, 2):
            break
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
                headerCell.headerLabel.text = LocalizationHelper.shared.localized("personal_data")
            case 2:
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
                break
            case 1:
                if item.group == MenuGroup.userData {
                    items.append(item)
                }
                break
            case 2:
                if item.group == MenuGroup.userRequest {
                    items.append(item)
                }
                break
            default:
                break
            }
        }
        return items
    }
}

struct MenuItem {
    var image: String
    var title: String
    var header: String
    var group: MenuGroup
}
