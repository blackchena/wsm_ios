//
//  ProfileDetailViewController.swift
//  wsm
//
//  Created by framgia on 10/17/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import InAppLocalize
import Floaty

class ProfileDetailViewController: BaseViewController, FloatyDelegate {

    @IBOutlet weak var tableView: UITableView!

    fileprivate var profileData = [ConfirmRequestItem]()
    fileprivate var otherData = [ConfirmRequestItem]()
    private let currentUser = UserServices.getLocalUserProfile()

    override func viewDidLoad() {
        super.viewDidLoad()

        initProfileData()

        //table header view
        let headerView = ProfileHeaderView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.width, height: 170))
        headerView.changePasswordButtonAction = { [weak self] in
            let vc = UIViewController.getStoryboardController(identifier: "ChangePasswordViewController")
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        tableView.tableHeaderView = headerView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension

        //table footer view
        let footerButton = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: tableView.frame.width, height: 44))
        footerButton.setTitle(LocalizationHelper.shared.localized("more"), for: .normal)
        footerButton.setTitleColor(.appBarTintColor, for: .normal)
        footerButton.addTarget(self, action: #selector(moreButtonClick), for: .touchUpInside)
        tableView.tableFooterView = footerButton
    }

    func moreButtonClick(sender: UIButton!) {
        initOtherData()
        tableView.tableFooterView = nil
        tableView.reloadData()
        addGoTopButton()
    }

    func addGoTopButton() {
        let floaty = Floaty()
        floaty.paddingX = floaty.paddingY
        floaty.fabDelegate = self
        floaty.buttonColor = UIColor.appBarTintColor
        floaty.buttonImage = UIImage(named: "ic_go_top")
        self.view.addSubview(floaty)
    }

    func emptyFloatySelected(_ floaty: Floaty) {
        tableView.setContentOffset(CGPoint.zero, animated: true)
    }

    func initProfileData() {
        profileData.append(ConfirmRequestItem(imageName: "ic_placeholder_user",
                                              header: LocalizationHelper.shared.localized("employee_code"),
                                              value: currentUser?.employeeCode
                                                ?? LocalizationHelper.shared.localized("empty_information")))
        profileData.append(ConfirmRequestItem(imageName: "ic_contract",
                                              header: LocalizationHelper.shared.localized("company"),
                                              value: currentUser?.company?.name
                                                ?? LocalizationHelper.shared.localized("empty_information")))
        profileData.append(ConfirmRequestItem(imageName: "ic_holiday_calendar",
                                              header: LocalizationHelper.shared.localized("start_probation_date"),
                                              value: currentUser?.startProbationDate?.toString(dateFormat: LocalizationHelper.shared.localized("date_format"))
                                                ?? LocalizationHelper.shared.localized("empty_information")))
        profileData.append(ConfirmRequestItem(imageName: "ic_holiday_calendar",
                                              header: LocalizationHelper.shared.localized("end_probation_date"),
                                              value: currentUser?.endProbationDate?.toString(dateFormat: LocalizationHelper.shared.localized("date_format"))
                                                ?? LocalizationHelper.shared.localized("empty_information")))
        profileData.append(ConfirmRequestItem(imageName: "ic_holiday_calendar",
                                              header: LocalizationHelper.shared.localized("contract_date"),
                                              value: currentUser?.contractDate?.toString(dateFormat: LocalizationHelper.shared.localized("date_format"))
                                                ?? LocalizationHelper.shared.localized("empty_information")))
        profileData.append(ConfirmRequestItem(imageName: "ic_position",
                                              header: LocalizationHelper.shared.localized("position_name"),
                                              value: currentUser?.namePosition
                                                ?? LocalizationHelper.shared.localized("empty_information")))
        profileData.append(ConfirmRequestItem(imageName: "ic_id_card",
                                              header: LocalizationHelper.shared.localized("individual_code"),
                                              value: currentUser?.individualCode
                                                ?? LocalizationHelper.shared.localized("empty_information")))
        profileData.append(ConfirmRequestItem(imageName: "ic_star",
                                              header: LocalizationHelper.shared.localized("staff_type"),
                                              value: currentUser?.nameStaffType
                                                ?? LocalizationHelper.shared.localized("empty_information")))
        profileData.append(ConfirmRequestItem(imageName: "ic_branch",
                                              header: LocalizationHelper.shared.localized("branch"),
                                              value: getWorkspaceData()))
        profileData.append(ConfirmRequestItem(imageName: "ic_group",
                                              header: LocalizationHelper.shared.localized("group"),
                                              value: getGroupData()))
    }

    func initOtherData() {
        otherData.append(ConfirmRequestItem(imageName: "ic_identity",
                                            header: LocalizationHelper.shared.localized("identification_passport"),
                                            value: emptyHolderStringIfNeeded(string: currentUser?.identifyInfo?.code)))
        otherData.append(ConfirmRequestItem(imageName: "ic_personal_email",
                                            header: LocalizationHelper.shared.localized("personal_email"),
                                            value: emptyHolderStringIfNeeded(string: currentUser?.generalInfo?.personalMail)))
        otherData.append(ConfirmRequestItem(imageName: "ic_place_of_birth",
                                            header: LocalizationHelper.shared.localized("place_of_birth"),
                                            value: emptyHolderStringIfNeeded(string: currentUser?.address?.placeOfBirth)))
        otherData.append(ConfirmRequestItem(imageName: "ic_current_address",
                                            header: LocalizationHelper.shared.localized("current_address"),
                                            value: emptyHolderStringIfNeeded(string: currentUser?.address?.currentAddress)))
        otherData.append(ConfirmRequestItem(imageName: "ic_permanent_address",
                                            header: LocalizationHelper.shared.localized("permanent_address"),
                                            value: emptyHolderStringIfNeeded(string: currentUser?.address?.permanentAddress)))
        otherData.append(ConfirmRequestItem(imageName: "ic_distance_from_office",
                                            header: LocalizationHelper.shared.localized("distance_from_office"),
                                            value: "\(currentUser?.address?.distanceFromOffice ?? 0) \(LocalizationHelper.shared.localized("km"))"))
        otherData.append(ConfirmRequestItem(imageName: "ic_home_phone",
                                            header: LocalizationHelper.shared.localized("home_phone"),
                                            value: emptyHolderStringIfNeeded(string: currentUser?.generalInfo?.homePhoneNumber)))
        otherData.append(ConfirmRequestItem(imageName: "ic_material_status",
                                            header: LocalizationHelper.shared.localized("marital_status"),
                                            value: emptyHolderStringIfNeeded(string: currentUser?.generalInfo?.marriedStatus)))
        otherData.append(ConfirmRequestItem(imageName: "ic_number_of_child",
                                            header: LocalizationHelper.shared.localized("number_of_child"),
                                            value: "\(currentUser?.generalInfo?.numberOfChildrent ?? 0)"))
        otherData.append(ConfirmRequestItem(imageName: "ic_vehecil",
                                            header: LocalizationHelper.shared.localized("vehicle"),
                                            value: emptyHolderStringIfNeeded(string: currentUser?.vehicleInfo?.vehicleType)))
        otherData.append(ConfirmRequestItem(imageName: "ic_licsense_plate",
                                            header: LocalizationHelper.shared.localized("license_plate"),
                                            value: emptyHolderStringIfNeeded(string: currentUser?.vehicleInfo?.licensePlate)))
        otherData.append(ConfirmRequestItem(imageName: "ic_bank_info",
                                            header: LocalizationHelper.shared.localized("bank_info"),
                                            value: emptyHolderStringIfNeeded(string: currentUser?.bankInfo?.bankname)))
        otherData.append(ConfirmRequestItem(imageName: "ic_account_id",
                                            header: LocalizationHelper.shared.localized("account_id"),
                                            value: emptyHolderStringIfNeeded(string: currentUser?.bankInfo?.taxCode)))
    }

    func emptyHolderStringIfNeeded(string: String?) -> String {
        return String.setNullOrEmptyStringHolder(string: string, holder: LocalizationHelper.shared.localized("empty_information"))
    }

    func getWorkspaceData() -> String? {
        if let workspaces = currentUser?.workSpaces {
            var workspacesString = ""
            for w in workspaces {
                if let name = w.name {
                    workspacesString += "▪︎ " + name + "\n"
                }
            }
            return workspacesString.removeEmptyLines()
        }
        return nil
    }

    func getGroupData() -> String? {
        if let groups = currentUser?.groups {
            var groupString = ""
            for g in groups {
                if let name = g.name {
                    groupString += "▪︎ " + name + "\n"
                }
            }
            return groupString.removeEmptyLines()
        }
        return nil
    }
}

extension ProfileDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmCreateRequestCell", for: indexPath)
            as? ConfirmCreateRequestCell else {
                return UITableViewCell()
        }
        cell.updateCell(item: indexPath.section == 0 ? profileData[indexPath.row] : otherData[indexPath.row])
        return cell
    } 

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? profileData.count : otherData.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return otherData.count > 0 ? 2 : 1
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
        header.backgroundView?.backgroundColor = UIColor.white
        header.textLabel?.layer.backgroundColor = UIColor.sectionColor.cgColor
        header.textLabel?.layer.cornerRadius = 2
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return LocalizationHelper.shared.localized(section == 0 ? "work_information" : "other_information")
    }
}
