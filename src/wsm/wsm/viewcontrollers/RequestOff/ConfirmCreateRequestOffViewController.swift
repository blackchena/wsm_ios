//
//  ConformCreateRequestOffViewController.swift
//  wsm
//
//  Created by Lê Thanh Quang on 10/17/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import InAppLocalize

fileprivate enum SectionType {
    case defaultItems
    case haveSalaryCompanyPayItems
    case haveSalaryInsuranceCoverageItems
    case haveSalaryDateTimeItems
    case noSalaryDateTimeItems
    case reason
}

class ConfirmCreateRequestOffViewController: NoMenuBaseViewController {

    //MARK: IBOutlet
    @IBOutlet weak var tableView: UITableView!

    public var requestOffInputDetailModel = RequestOffDetailApiInputModel()
    public var dayOffSettingBindedValues = [Int: (Float, Bool, DayOffSettingModel)]()
    fileprivate var confirmDefaultItems = [ConfirmRequestItem]()
    fileprivate var confirmHaveSalaryCompanyPayItems = [ConfirmRequestItem]()
    fileprivate var confirmHaveSalaryInsuranceCoverageItems = [ConfirmRequestItem]()
    fileprivate var confirmNoSalaryItems = [ConfirmRequestItem]()
    fileprivate var sectionTypes = [SectionType]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if requestOffInputDetailModel.id != nil {
            title = LocalizationHelper.shared.localized("confirm_edit_others_request")
        }

        createSectionData()
        appendDefaultItems()
        appendHaveSalaryCompanyPayItems()
        appendHaveSalaryInsuranceCoverageItems()
        appendNoSalaryItems()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    func createSectionData() {
        //minimun is 3 sections
        //first section is defaultItem

        sectionTypes.removeAll()

        if confirmDefaultItems.count > 0 {
            sectionTypes.append(.defaultItems)
        }

        if confirmHaveSalaryCompanyPayItems.count > 0 {
            sectionTypes.append(.haveSalaryCompanyPayItems)
        }

        if confirmHaveSalaryInsuranceCoverageItems.count > 0 {
            sectionTypes.append(.haveSalaryInsuranceCoverageItems)
        }

        if confirmHaveSalaryCompanyPayItems.count > 0 || confirmHaveSalaryInsuranceCoverageItems.count > 0 {
            sectionTypes.append(.haveSalaryDateTimeItems)
        }

        if confirmNoSalaryItems.count > 0 {
            sectionTypes.append(.noSalaryDateTimeItems)
        }

        //reason section
        sectionTypes.append(.reason)
    }

    func appendDefaultItems() {
        confirmDefaultItems.append(contentsOf: ConfirmRequestItem.getDefaultItem(workSpaceId: requestOffInputDetailModel.workSpaceId, groupId: requestOffInputDetailModel.groupId, projectName: requestOffInputDetailModel.projectName))
    }

    func appendHaveSalaryCompanyPayItems() {

        confirmHaveSalaryCompanyPayItems.removeAll()

        if let listIdDayOffSetting = getRequestDayOffTypes(byDateOffType: .haveSalaryCompanyPay)?.filter({ f -> Bool in return f.id != nil }).map({ o -> Int in return o.id! }) {
            let listDayOffSettingBinded = dayOffSettingBindedValues.filter({ s -> Bool in return listIdDayOffSetting.contains(s.key) })

            for dayOffSettingBinded in listDayOffSettingBinded {
                confirmHaveSalaryCompanyPayItems.append(ConfirmRequestItem(imageName: "", header: dayOffSettingBinded.value.2.dayOffAsString, value: "\(dayOffSettingBinded.value.0)"))
            }
        }
    }

    func appendHaveSalaryInsuranceCoverageItems() {

        confirmHaveSalaryInsuranceCoverageItems.removeAll()

        if let listIdDayOffSetting = getRequestDayOffTypes(byDateOffType: .haveSalaryInsuranceCoverage)?.filter({ f -> Bool in return f.id != nil }).map({ o -> Int in return o.id! }) {
            let listDayOffSettingBinded = dayOffSettingBindedValues.filter({ s -> Bool in return listIdDayOffSetting.contains(s.key) })

            for dayOffSettingBinded in listDayOffSettingBinded {
                confirmHaveSalaryInsuranceCoverageItems.append(ConfirmRequestItem(imageName: "", header: dayOffSettingBinded.value.2.dayOffAsString, value: "\(dayOffSettingBinded.value.0)"))
            }
        }
    }

    func appendNoSalaryItems() {

        confirmNoSalaryItems.removeAll()

        if self.requestOffInputDetailModel.offNoSalaryFrom.offPaidFrom != nil && self.requestOffInputDetailModel.offNoSalaryTo.offPaidTo != nil {
            confirmNoSalaryItems.append(ConfirmRequestItem(imageName: "ic_clock_2", header: LocalizationHelper.shared.localized("off_no_salary_from"), value: self.requestOffInputDetailModel.offNoSalaryFrom.toString()))


            confirmNoSalaryItems.append(ConfirmRequestItem(imageName: "ic_clock_2", header: LocalizationHelper.shared.localized("off_no_salary_to"), value: self.requestOffInputDetailModel.offNoSalaryTo.toString()))
        }
    }

    @IBAction func submitButtonClicked(_ sender: Any) {
        self.submitRequestOff(requestOffDetailApiInputModel: self.requestOffInputDetailModel)
    }

}

extension ConfirmCreateRequestOffViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch sectionTypes[indexPath.section] {
        case .defaultItems:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmCreateRequestOffCell", for: indexPath)
            if let cell = cell as? ConfirmCreateRequestOffCell {
                cell.updateCell(item: self.confirmDefaultItems[indexPath.row])
            }
            return cell
        case .haveSalaryCompanyPayItems:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmCreateRequestOffDayOffSettingCell", for: indexPath)
            if let cell = cell as? ConfirmCreateRequestOffDayOffSettingCell {
                cell.updateCell(item: confirmHaveSalaryCompanyPayItems[indexPath.row])
            }
            return cell
        case .haveSalaryInsuranceCoverageItems:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmCreateRequestOffDayOffSettingCell", for: indexPath)
            if let cell = cell as? ConfirmCreateRequestOffDayOffSettingCell {
                cell.updateCell(item: confirmHaveSalaryInsuranceCoverageItems[indexPath.row])
            }
            return cell
        case .haveSalaryDateTimeItems:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmCreateRequestOffCell", for: indexPath)
            if let cell = cell as? ConfirmCreateRequestOffCell {
                var item: ConfirmRequestItem
                if indexPath.row == 0 {
                    item = ConfirmRequestItem(imageName: "ic_clock_2", header: LocalizationHelper.shared.localized("off_have_salary_from"), value: self.requestOffInputDetailModel.offHaveSalaryFrom.toString())
                } else {
                    item = ConfirmRequestItem(imageName: "ic_clock_2", header: LocalizationHelper.shared.localized("off_have_salary_to"), value: self.requestOffInputDetailModel.offHaveSalaryTo.toString())
                }

                cell.updateCell(item: item)
            }
            return cell
        case .noSalaryDateTimeItems:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmCreateRequestOffCell", for: indexPath)
            if let cell = cell as? ConfirmCreateRequestOffCell {
                cell.updateCell(item: confirmNoSalaryItems[indexPath.row])
            }
            return cell
        case .reason:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ConfirmCreateRequestOffCell", for: indexPath)
            if let cell = cell as? ConfirmCreateRequestOffCell {
                let item = ConfirmRequestItem(imageName: "ic_reason", header: LocalizationHelper.shared.localized("reason"), value: self.requestOffInputDetailModel.reason)

                cell.updateCell(item: item)
            }
            return cell
        }
    }



    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTypes.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch sectionTypes[section] {
        case .defaultItems:
            return confirmDefaultItems.count
        case .haveSalaryCompanyPayItems:
            return confirmHaveSalaryCompanyPayItems.count
        case .haveSalaryInsuranceCoverageItems:
            return confirmHaveSalaryInsuranceCoverageItems.count
        case .haveSalaryDateTimeItems,
             .noSalaryDateTimeItems:
            return 2
        case .reason:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        switch sectionTypes[section] {
        case .defaultItems:
            return nil
        case .haveSalaryCompanyPayItems:
            return LocalizationHelper.shared.localized("off_have_salary_company_pay")
        case .haveSalaryInsuranceCoverageItems:
            return LocalizationHelper.shared.localized("off_have_salary_insurance_coverage")
        case .haveSalaryDateTimeItems:
            return nil
        case .noSalaryDateTimeItems:
            return LocalizationHelper.shared.localized("off_no_salary")
        case .reason:
            return nil
        }
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.darkGray
        header.backgroundView?.backgroundColor = UIColor.white
    }
}

extension ConfirmCreateRequestOffViewController: CreateRequestOffViewControllerType, ConfirmCreateRequestOffViewControllerType {
    func didSubmitRequestSuccess() {
        _ = navigationController?.popToRootViewController(animated: true)
    }
}
