//
//  LeftMenuViewController.swift
//  wsm
//
//  Created by framgia on 9/20/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import UIKit

class LeftMenuViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    let rowHeight: CGFloat = 50.0
    var menuItems = [MenuItem]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        menuItems.append(MenuItem(image: "icon_notification", title: .UserInfo, header: .UserInfo))
        menuItems.append(MenuItem(image: "icon_notification", title: .UserSetting, header: .UserInfo))
        menuItems.append(MenuItem(image: "icon_notification", title: .TimeSheet, header: .UserData))
        menuItems.append(MenuItem(image: "icon_notification", title: .CalendarOff, header: .UserData))
        menuItems.append(MenuItem(image: "icon_notification", title: .UserReport, header: .UserData))
        menuItems.append(MenuItem(image: "icon_notification", title: .RequestOt, header: .UserRequest))
        menuItems.append(MenuItem(image: "icon_notification", title: .RequestOff, header: .UserRequest))
        menuItems.append(MenuItem(image: "icon_notification", title: .OtherRequest, header: .UserRequest))

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
        let timeSheetViewController = TimeSheetViewController(nibName: "TimeSheetViewController", bundle: nil)

        guard let navigationController = rootViewController as? NavigationController else {
            return
        }

        var selectedViewController: UIViewController!

        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            selectedViewController = UserInfoViewController(nibName: "UserInfoViewController", bundle: nil)
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
                headerCell.headerLabel.text = MenuHeaderEnum.UserInfo.rawValue
            case 1:
                headerCell.headerLabel.text = MenuHeaderEnum.UserData.rawValue
            case 2:
                headerCell.headerLabel.text = MenuHeaderEnum.UserRequest.rawValue
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
                if item.header == MenuHeaderEnum.UserInfo {
                    items.append(item)
                }
                break
            case 1:
                if item.header == MenuHeaderEnum.UserData {
                    items.append(item)
                }
                break
            case 2:
                if item.header == MenuHeaderEnum.UserRequest {
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
    var title: MenuItemEnum
    var header: MenuHeaderEnum
}
