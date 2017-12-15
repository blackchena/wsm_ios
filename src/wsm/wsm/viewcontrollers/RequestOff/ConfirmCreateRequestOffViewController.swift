//
//  ConformCreateRequestOffViewController.swift
//  wsm
//
//  Created by Lê Thanh Quang on 10/17/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import InAppLocalize

public enum SectionType {
    case defaultItems
    case haveSalaryCompanyPayItems
    case haveSalaryInsuranceCoverageItems
    case haveSalaryDateTimeItems
    case noSalaryDateTimeItems
    case reason
    case replacement
}

class ConfirmCreateRequestOffViewController: NoMenuBaseViewController {

    //MARK: IBOutlet
    @IBOutlet weak var tableView: UITableView!

    public var requestOffInputDetailModel = RequestOffDetailApiInputModel()
    public var dayOffSettingBindedValues = [Int: (numberDayOff: Float, isBinded: Bool, dayOfSettingModel: DayOffSettingModel)]()
    fileprivate var confirmDefaultItems = [DetailModel]()
    fileprivate var confirmHaveSalaryCompanyPayItems = [DetailModel]()
    fileprivate var confirmHaveSalaryInsuranceCoverageItems = [DetailModel]()
    fileprivate var confirmHaveSalaryDateTimeItems = [DetailModel]()

    fileprivate var confirmNoSalaryItems = [DetailModel]()
    fileprivate var sectionTypes = [SectionType]()
    weak var listRequestDelegate: ListRequestDelegte?

    fileprivate let confirmCreateRequestOffCellKey = "ConfirmCreateRequestOffCell"
    fileprivate let replacementStringKey = "replacement"
    fileprivate let replacementIconKey = "ic_reason"
    fileprivate let numberOffReplacementRow = 1
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if requestOffInputDetailModel.id != nil {
            title = LocalizationHelper.shared.localized("confirm_edit_day_off_request")
        }

        appendDefaultItems()
        appendHaveSalaryCompanyPayItems()
        appendHaveSalaryInsuranceCoverageItems()
        appendHaveSalaryDateTimeItems()
        appendNoSalaryItems()
        createSectionData()

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

        if confirmHaveSalaryDateTimeItems.count > 0 {
            sectionTypes.append(.haveSalaryDateTimeItems)
        }

        if confirmNoSalaryItems.count > 0 {
            sectionTypes.append(.noSalaryDateTimeItems)
        }

        //reason section
        sectionTypes.append(.reason)
        sectionTypes.append(.replacement)
    }

    func appendDefaultItems() {
        confirmDefaultItems.append(contentsOf: DetailModel.getDefaultItem(workSpaceId: requestOffInputDetailModel.workSpaceId,
                                                                                 groupId: requestOffInputDetailModel.groupId,
                                                                                 positionName: requestOffInputDetailModel.positionName,
                                                                                 projectName: requestOffInputDetailModel.projectName))
    }

    func appendHaveSalaryCompanyPayItems() {

        confirmHaveSalaryCompanyPayItems.removeAll()

        if let listIdDayOffSetting = getRequestDayOffTypes(byDateOffType: .haveSalaryCompanyPay)?.filter({ f -> Bool in return f.id != nil }).map({ o -> Int in return o.id! }) {
            let listDayOffSettingBinded = dayOffSettingBindedValues.filter({ s -> Bool in return listIdDayOffSetting.contains(s.key) })

            for dayOffSettingBinded in listDayOffSettingBinded {
                confirmHaveSalaryCompanyPayItems.append(DetailModel(imageName: "", header: dayOffSettingBinded.value.2.dayOffAsString, value: "\(dayOffSettingBinded.value.0)"))
            }
        }
    }

    func appendHaveSalaryInsuranceCoverageItems() {

        confirmHaveSalaryInsuranceCoverageItems.removeAll()

        if let listIdDayOffSetting = getRequestDayOffTypes(byDateOffType: .haveSalaryInsuranceCoverage)?.filter({ f -> Bool in return f.id != nil }).map({ o -> Int in return o.id! }) {
            let listDayOffSettingBinded = dayOffSettingBindedValues.filter({ s -> Bool in return listIdDayOffSetting.contains(s.key) })

            for dayOffSettingBinded in listDayOffSettingBinded {
                confirmHaveSalaryInsuranceCoverageItems.append(DetailModel(imageName: "", header: dayOffSettingBinded.value.2.dayOffAsString, value: "\(dayOffSettingBinded.value.0)"))
            }
        }
    }

    func appendHaveSalaryDateTimeItems() {
        confirmHaveSalaryDateTimeItems.removeAll()

        if let _ = requestOffInputDetailModel.offHaveSalaryFrom.offPaidFrom,
            let _ = requestOffInputDetailModel.offHaveSalaryFrom.paidFromPeriod {
            confirmHaveSalaryDateTimeItems.append(DetailModel(imageName: "ic_clock_2", header: LocalizationHelper.shared.localized("off_have_salary_from"), value: self.requestOffInputDetailModel.offHaveSalaryFrom.toString()))
        }

        if let _ = requestOffInputDetailModel.offHaveSalaryTo.offPaidTo,
            let _ = requestOffInputDetailModel.offHaveSalaryTo.paidToPeriod {
            confirmHaveSalaryDateTimeItems.append(DetailModel(imageName: "ic_clock_2", header: LocalizationHelper.shared.localized("off_have_salary_to"), value: self.requestOffInputDetailModel.offHaveSalaryTo.toString()))
        }
    }

    func appendNoSalaryItems() {

        confirmNoSalaryItems.removeAll()

        if let _ = requestOffInputDetailModel.offNoSalaryFrom.offPaidFrom,
            let _ = requestOffInputDetailModel.offNoSalaryFrom.paidFromPeriod {
            confirmNoSalaryItems.append(DetailModel(imageName: "ic_clock_2", header: LocalizationHelper.shared.localized("off_no_salary_from"), value: self.requestOffInputDetailModel.offNoSalaryFrom.toString()))
        }

        if let _ = requestOffInputDetailModel.offNoSalaryTo.offPaidTo,
            let _ = requestOffInputDetailModel.offNoSalaryTo.paidToPeriod {
            confirmNoSalaryItems.append(DetailModel(imageName: "ic_clock_2", header: LocalizationHelper.shared.localized("off_no_salary_to"), value: self.requestOffInputDetailModel.offNoSalaryTo.toString()))
        }
    }

    @IBAction func submitButtonClicked(_ sender: Any) {
        if let id = self.requestOffInputDetailModel.id {

            //must set those properties for edit right here
            self.requestOffInputDetailModel.requestDayoffType = self.requestOffInputDetailModel.requestDayOffTypesAttributes?.filter({ attr in attr.id != nil })

            self.requestOffInputDetailModel.requestDayOffTypesAttributes = self.requestOffInputDetailModel.requestDayOffTypesAttributes?.map({ attr in
                if (attr.destroy ?? true) {
                    return RequestDayOffTypeModel(id: attr.id, specialDayOffSettingId: attr.specialDayOffSettingId, numberDayOff: 0, destroy: attr.destroy)
                }

                return attr
            })

            self.submitEditRequestOff(id: id, requestOffDetailApiInputModel: self.requestOffInputDetailModel)
        } else {
            self.submitCreateRequestOff(requestOffDetailApiInputModel: self.requestOffInputDetailModel)
        }
    }

    func popToListRequestOffIfNeeded() {
        if !(navigationController?.viewControllers.first is ListRequestOffViewController) {
            let newRootViewController = getViewController(identifier: "ListRequestOffViewController")
            navigationController?.replaceRootViewController(by: newRootViewController)
        }
        navigationController?.popToRootViewController(animated: true)
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
                cell.updateCell(item: confirmHaveSalaryDateTimeItems[indexPath.row])
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
                let item = DetailModel(imageName: "ic_reason", header: LocalizationHelper.shared.localized("reason"), value: self.requestOffInputDetailModel.reason)

                cell.updateCell(item: item)
            }
            return cell
        case .replacement:
            let cell = tableView.dequeueReusableCell(withIdentifier: confirmCreateRequestOffCellKey, for: indexPath)
            if let cell = cell as? ConfirmCreateRequestOffCell {
                let item = DetailModel(
                    imageName: replacementIconKey,
                    header: LocalizationHelper.shared.localized(replacementStringKey),
                    value: self.requestOffInputDetailModel.replacement?.name
                )
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
        case .haveSalaryDateTimeItems:
            return confirmHaveSalaryDateTimeItems.count
        case .noSalaryDateTimeItems:
            return confirmNoSalaryItems.count
        case .reason:
            return 1
        case .replacement:
            return numberOffReplacementRow
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
        case .replacement:
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
        if self.isEditingRequest() {
            self.listRequestDelegate?.getListRequests()
        } else {
            self.listRequestDelegate?.didCreateRequest()
        }
        popToListRequestOffIfNeeded()
    }

    private func isEditingRequest() -> Bool {
        return self.requestOffInputDetailModel.id != nil
    }
}
