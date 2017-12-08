//
//  RequestOffDetailViewController.swift
//  wsm
//
//  Created by framgia on 10/13/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import InAppLocalize

class RequestOffDetailViewController: NoMenuBaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var deleteButton: LocalizableButton!
    @IBOutlet weak var editButton: LocalizableButton!
    @IBOutlet weak var deleteButtonHeight: NSLayoutConstraint!

    weak var listRequestDelegate: ListRequestDelegte?
    var selectedRequest = RequestDayOffModel()
    public var dayOffSettingBindedValues = [Int: (Float, Bool, DayOffSettingModel)]()

    fileprivate var confirmDefaultItems = [DetailModel]()
    fileprivate var confirmHaveSalaryCompanyPayItems = [DetailModel]()
    fileprivate var confirmHaveSalaryInsuranceCoverageItems = [DetailModel]()
    fileprivate var confirmHaveSalaryDateTimeItems = [DetailModel]()

    fileprivate var confirmNoSalaryItems = [DetailModel]()
    fileprivate var sectionTypes = [SectionType]()
    
    fileprivate let detailCreateRequestOffCellKey = "DetailCreateRequestOffCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        if selectedRequest.status != .pending {
            deleteButtonHeight.constant = 0
            view.layoutIfNeeded()
        }

        fetchDayOffData()

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

    func fetchDayOffData() {

        var listDayOffSetting = getRequestDayOffTypes(byDateOffType: .haveSalaryCompanyPay)
        if let insuranceCoverage = getRequestDayOffTypes(byDateOffType: .haveSalaryInsuranceCoverage) {
            listDayOffSetting?.append(contentsOf: insuranceCoverage)
        }

        if let noSalary = getRequestDayOffTypes(byDateOffType: .noSalary) {
            listDayOffSetting?.append(contentsOf: noSalary)
        }

        //append annualDayOff if have value
        if let numberDayOffNormal = selectedRequest.numberDayOffNormal,
            numberDayOffNormal > 0,
            let annualDayOffSetting = listDayOffSetting?.first(where: { s in AppConstant.annualDayOffSettingId == s.id }) {

            dayOffSettingBindedValues[AppConstant.annualDayOffSettingId] = (numberDayOffNormal, true, annualDayOffSetting)
        }


        //append special dayoff if have value
        if let dayOffAttribute = selectedRequest.requestDayOffTypes {
            for bindedValue in dayOffAttribute {
                if let dayOffSettingId = bindedValue.specialDayOffSettingId,
                    let dayOffSettingModel = listDayOffSetting?.first(where: { s in dayOffSettingId == s.id }),
                    let value = bindedValue.numberDayOff,
                    value > 0 {

                    dayOffSettingBindedValues[dayOffSettingId] = (value, true, dayOffSettingModel)
                }
            }
        }
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

        if confirmHaveSalaryDateTimeItems.count > 0{
            sectionTypes.append(.haveSalaryDateTimeItems)
        }

        if confirmNoSalaryItems.count > 0 {
            sectionTypes.append(.noSalaryDateTimeItems)
        }

        //reason section
        sectionTypes.append(.reason)
        sectionTypes.append(.replacement)
    }


    private func appendDefaultItems() {

        confirmDefaultItems.removeAll()

        confirmDefaultItems.append(contentsOf: DetailModel.getDefaultItem(workSpaceName: selectedRequest.workSpace?.name,
                                                                                 groupName: selectedRequest.group?.fullName,
                                                                                 positionName: selectedRequest.positionName,
                                                                                 projectName: selectedRequest.projectName,
                                                                                 userProfileModel: selectedRequest.user))


        //append "status" cell
        confirmDefaultItems.append(DetailModel(imageName: "ic_status",
                                                      header: LocalizationHelper.shared.localized("status"),
                                                      value: selectedRequest.status?.localizedString(),
                                                      valueColor: selectedRequest.status?.getColor()))

        //append "being_handle_by" cell
        confirmDefaultItems.append(DetailModel(imageName: "ic_being_handled_by",
                                                      header: LocalizationHelper.shared.localized("being_handled_by"),
                                                      value: selectedRequest.handleByGroupName))
    }

    func appendHaveSalaryCompanyPayItems() {

        confirmHaveSalaryCompanyPayItems.removeAll()

        if let listIdDayOffSetting = getRequestDayOffTypes(byDateOffType: .haveSalaryCompanyPay)?.filter({ f -> Bool in return f.id != nil }).map({ o -> Int in return o.id! }) {
            let listDayOffSettingBinded = dayOffSettingBindedValues.filter({ s -> Bool in return listIdDayOffSetting.contains(s.key) })

            for dayOffSettingBinded in listDayOffSettingBinded {
                confirmHaveSalaryCompanyPayItems.append(DetailModel(imageName: "",
                                                                           header: dayOffSettingBinded.value.2.dayOffAsString,
                                                                           value: "\(dayOffSettingBinded.value.0)"))
            }
        }
    }

    func appendHaveSalaryInsuranceCoverageItems() {

        confirmHaveSalaryInsuranceCoverageItems.removeAll()

        if let listIdDayOffSetting = getRequestDayOffTypes(byDateOffType: .haveSalaryInsuranceCoverage)?.filter({ f -> Bool in return f.id != nil }).map({ o -> Int in return o.id! }) {
            let listDayOffSettingBinded = dayOffSettingBindedValues.filter({ s -> Bool in return listIdDayOffSetting.contains(s.key) })

            for dayOffSettingBinded in listDayOffSettingBinded {
                confirmHaveSalaryInsuranceCoverageItems.append(DetailModel(imageName: "",
                                                                                  header: dayOffSettingBinded.value.2.dayOffAsString,
                                                                                  value: "\(dayOffSettingBinded.value.0)"))
            }
        }
    }

    func appendHaveSalaryDateTimeItems() {
        confirmHaveSalaryDateTimeItems.removeAll()

        if let haveSalaryFrom = selectedRequest.offHaveSalaryFrom,
            let _ = haveSalaryFrom.offPaidFrom,
            let _ = haveSalaryFrom.paidFromPeriod {
            confirmHaveSalaryDateTimeItems.append(DetailModel(imageName: "ic_clock_2",
                                                                     header: LocalizationHelper.shared.localized("off_have_salary_from"),
                                                                     value: haveSalaryFrom.toString()))
        }

        if  let haveSalaryTo = selectedRequest.offHaveSalaryTo,
            let _ = haveSalaryTo.offPaidTo,
            let _ = haveSalaryTo.paidToPeriod {
            confirmHaveSalaryDateTimeItems.append(DetailModel(imageName: "ic_clock_2",
                                                                     header: LocalizationHelper.shared.localized("off_have_salary_to"),
                                                                     value: haveSalaryTo.toString()))
        }
    }

    func appendNoSalaryItems() {

        confirmNoSalaryItems.removeAll()

        if let _ = selectedRequest.offNoSalaryFrom.offPaidFrom,
            let _ = selectedRequest.offNoSalaryFrom.paidFromPeriod {
            confirmNoSalaryItems.append(DetailModel(imageName: "ic_clock_2",
                                                           header: LocalizationHelper.shared.localized("off_no_salary_from"),
                                                           value: self.selectedRequest.offNoSalaryFrom.toString()))
        }

        if let _ = selectedRequest.offNoSalaryTo.offPaidTo,
            let _ = selectedRequest.offNoSalaryTo.paidToPeriod {
            confirmNoSalaryItems.append(DetailModel(imageName: "ic_clock_2",
                                                           header: LocalizationHelper.shared.localized("off_no_salary_to"),
                                                           value: self.selectedRequest.offNoSalaryTo.toString()))
        }
    }

    func getCurrentDateOffType() -> DateOffType {
        let isNoSalary = confirmNoSalaryItems.count > 0
        let isHaveSalaryInsuranceCoverage  = confirmHaveSalaryInsuranceCoverageItems.count > 0
        return isNoSalary ? .noSalary : (isHaveSalaryInsuranceCoverage ? .haveSalaryInsuranceCoverage : .haveSalaryCompanyPay)
    }
    
    @IBAction func editButtonClicked(_ sender: Any) {
        if let createOffVc = getViewController(identifier: "CreateRequestOffViewController") as? CreateRequestOffViewController {

            createOffVc.editRequestOff(request: self.selectedRequest, dayOffSettingBindedValues: self.dayOffSettingBindedValues)
            createOffVc.listRequestDelegate = self.listRequestDelegate
            createOffVc.currentDateOffType = getCurrentDateOffType()
            self.navigationController?.pushViewController(createOffVc, animated: true)
        }

    }

    @IBAction func deleteButtunClick(_ sender: Any) {
        AlertHelper.showConfirm(message: LocalizationHelper.shared.localized("do_you_want_delete_this_request"),
                                makesureLoadingHidden: true,
                                handler: { (alert) in self.deleteRequest()})
    }

    func deleteRequest() {
        guard let id = self.selectedRequest.id else {
            return
        }
        AlertHelper.showLoading()
        RequestOffProvider.deleteRequestOff(id: id)
            .then { apiOutput -> Void in
                if apiOutput.isSucceeded() {
                    AlertHelper.showInfo(message: apiOutput.message, makesureLoadingHidden: true, handler: { (alert) in
                        self.listRequestDelegate?.getListRequests()
                        self.navigationController?.popViewController(animated: true)
                    })
                }
            }.catch { error in
                AlertHelper.showError(error: error)
            }.always {
                AlertHelper.hideLoading()
        }
    }
}

extension RequestOffDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch sectionTypes[indexPath.section] {
        case .defaultItems:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCreateRequestOffCell", for: indexPath)
            if let cell = cell as? ConfirmCreateRequestOffCell {
                cell.updateCell(item: self.confirmDefaultItems[indexPath.row])
            }
            return cell
        case .haveSalaryCompanyPayItems:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCreateRequestOffDayOffSettingCell", for: indexPath)
            if let cell = cell as? ConfirmCreateRequestOffDayOffSettingCell {
                cell.updateCell(item: confirmHaveSalaryCompanyPayItems[indexPath.row])
            }
            return cell
        case .haveSalaryInsuranceCoverageItems:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCreateRequestOffDayOffSettingCell", for: indexPath)
            if let cell = cell as? ConfirmCreateRequestOffDayOffSettingCell {
                cell.updateCell(item: confirmHaveSalaryInsuranceCoverageItems[indexPath.row])
            }
            return cell
        case .haveSalaryDateTimeItems:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCreateRequestOffCell", for: indexPath)
            if let cell = cell as? ConfirmCreateRequestOffCell {
                cell.updateCell(item: confirmHaveSalaryDateTimeItems[indexPath.row])
            }
            return cell
        case .noSalaryDateTimeItems:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCreateRequestOffCell", for: indexPath)
            if let cell = cell as? ConfirmCreateRequestOffCell {
                cell.updateCell(item: confirmNoSalaryItems[indexPath.row])
            }
            return cell
        case .reason:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCreateRequestOffCell", for: indexPath)
            if let cell = cell as? ConfirmCreateRequestOffCell {
                let item = DetailModel(imageName: "ic_reason",
                                              header: LocalizationHelper.shared.localized("reason"),
                                              value: self.selectedRequest.reason)

                cell.updateCell(item: item)
            }
            return cell
        case .replacement:
            return tableView.dequeueReusableCell(withIdentifier: detailCreateRequestOffCellKey, for: indexPath)
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

extension RequestOffDetailViewController: CreateRequestOffViewControllerType {
}
