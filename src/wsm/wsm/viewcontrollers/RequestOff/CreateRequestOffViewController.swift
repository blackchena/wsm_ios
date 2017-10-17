//
//  CreateRequestOffViewController.swift
//  wsm
//
//  Created by Lê Thanh Quang on 10/4/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import Validator
import InAppLocalize

class CreateRequestOffViewController: RequestBaseViewController {

    //MARK: IBOutlet

    fileprivate let offTypePicker = UIPickerView()

    fileprivate let ofTypeList: [DateOffType] = [.haveSalaryCompanyPay, .haveSalaryInsuranceCoverage, .noSalary]

    fileprivate var currentRequestOffModel = RequestOffDetailApiInputModel()
    fileprivate var currentDateOffType: DateOffType = .haveSalaryCompanyPay

    fileprivate var fromDate: Date?
    fileprivate var fromTimeConvention: TimeConventionType = .am
    fileprivate var toDate: Date?
    fileprivate var toTimeConvention: TimeConventionType = .am
    fileprivate var reasonText: String?
    fileprivate var isValidating = false

    fileprivate let dayOffSectionIndex = 1
    fileprivate var dayOffSettingBindedValues = [Int: (Float, Bool)]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        offTypePicker.delegate = self

        self.tableView?.register(UINib(nibName: "RequestTextFieldCell", bundle: nil), forCellReuseIdentifier: "RequestTextFieldCell")
        self.tableView?.delegate = self
        self.tableView?.dataSource = self

        self.tableView?.estimatedRowHeight = 44
    }

    func bindDataToModel() {
        currentRequestOffModel.workSpaceId = basicInfoHeaderView.selectedWorkSpace.id ?? 0
        currentRequestOffModel.groupId = basicInfoHeaderView.selectedGroup.id ?? 0
        currentRequestOffModel.projectName = basicInfoHeaderView.projectName
        //        currentRequestOffModel.positionName = basicInfoHeaderView.


        currentRequestOffModel.offHaveSalaryFrom = RequestDayOffFromModel()
        currentRequestOffModel.offHaveSalaryTo = RequestDayOffToModel()

        switch currentDateOffType {
        case .noSalary:
            currentRequestOffModel.offNoSalaryFrom.offPaidFrom = fromDate
            currentRequestOffModel.offNoSalaryFrom.paidFromPeriod = fromTimeConvention

            currentRequestOffModel.offNoSalaryTo.offPaidTo = toDate
            currentRequestOffModel.offNoSalaryTo.paidToPeriod = toTimeConvention
        default:
            currentRequestOffModel.offNoSalaryFrom.offPaidFrom = fromDate
            currentRequestOffModel.offNoSalaryFrom.paidFromPeriod = fromTimeConvention

            currentRequestOffModel.offNoSalaryTo.offPaidTo = toDate
            currentRequestOffModel.offNoSalaryTo.paidToPeriod = toTimeConvention
        }

        currentRequestOffModel.requestDayOffTypesAttributes = generateDayOffTypeAttributes(dayOffSettingBindedValue: dayOffSettingBindedValues)

        currentRequestOffModel.reason = reasonText ?? ""
    }

    @objc fileprivate func onOffTypeSelected() {
        self.view.endEditing(true)

        //        collectDataFromDayOffSettingFields()

        self.currentDateOffType = ofTypeList[offTypePicker.selectedRow(inComponent: 0)]
        //TODOs: update UI
        isValidating = false

        self.tableView?.reloadData()
    }

    fileprivate func onFromDaySelected(sender: CreateRequestOffTimeCell, date: Date) -> Bool {
        fromDate = date
        toDate = nil

        self.tableView?.reloadData()
        self.tableView?.scrollToRow(at: IndexPath.init(row: 0, section: 2), at: .middle, animated: false)
        return true
    }

    fileprivate func onFromTimeConventionSelected(convention: TimeConventionType) -> Bool {
        self.fromTimeConvention = convention
        return true
    }

    fileprivate func onToDaySelected(sender: CreateRequestOffTimeCell, date: Date) -> Bool {
        if fromDate == nil {
            AlertHelper.showInfo(message: LocalizationHelper.shared.localized("you_have_to_choose_start_date"))
            return false
        }
        else if fromDate?.compare(.isLater(than: date)) ?? false {
            AlertHelper.showInfoWithPromise(message: LocalizationHelper.shared.localized("end_date_must_greater_than_start_day")).always {
                _ = sender.toDayTextField.becomeFirstResponder()
            }

            return false
        } else {
            self.toDate = date
        }
        return true
    }

    fileprivate func onToTimeConventionSelected(convention: TimeConventionType) -> Bool {
        self.toTimeConvention = convention
        return true
    }

    fileprivate func validateDayOffField() {

        var isValid = false

        var firstRowIndexOfInvalidateDayOffCell = -1

        isValidating = true
        //if .noSalary -> just fill time from & to
        // else must fill atleast 1 valid field
        if currentDateOffType != .noSalary {

            for dayOff in dayOffSettingBindedValues {
                isValid = dayOff.value.0 > 0 && dayOff.value.1

                if !isValid && firstRowIndexOfInvalidateDayOffCell == -1,
                   let index = self.indexCellForDayOffSetting(byDayOffSettingId: dayOff.key) {
                    firstRowIndexOfInvalidateDayOffCell = index
                }
            }
        } else {
            isValid = true
        }

        let isTimeCellValid = fromDate != nil && toDate != nil && (reasonText?.isNotEmpty ?? false)

        //if timeCell is valid but the dayoff is invalid, show error dialog
        if isTimeCellValid && !isValid {
            AlertHelper.showError(message: LocalizationHelper.shared.localized("the_number_of_days_allowed"))
        }

        isValid = isTimeCellValid && isValid

        if isValid {
            bindDataToModel()
        } else if !isTimeCellValid {
            self.tableView?.reloadData()
            //focus to invalidate CreateRequestOffTimeCell cell
            self.tableView?.scrollToRow(at: IndexPath.init(row: 0, section: 2), at: .bottom, animated: false)
        } else if firstRowIndexOfInvalidateDayOffCell != -1 {
            self.tableView?.scrollToRow(at: IndexPath.init(row: firstRowIndexOfInvalidateDayOffCell, section: dayOffSectionIndex), at: .middle, animated: false)
        }
    }

    @IBAction func nextButtonClicked(_ sender: Any) {
        validateDayOffField()
    }

    fileprivate func reasonChanged(reason: String?) {
        reasonText = reason
    }

    fileprivate func onDayOffValueChange(cell: RequestTextFieldCell, bindingContext: Any?, value: String?) {
        if let cellDayOffSetting = bindingContext as? DayOffSettingModel,
            let dayOffSettingBindedValue = Float.init(cell.textField.text ?? "") {
            if let cellDayOffSettingId = cellDayOffSetting.id {
                dayOffSettingBindedValues[cellDayOffSettingId] = (dayOffSettingBindedValue, cell.textField.validate().isValid)
            }

            if cellDayOffSetting.isAnnualLeave {
                currentRequestOffModel.numberDayOffNormal = dayOffSettingBindedValue
            }
        }
    }


}

extension CreateRequestOffViewController: UITableViewDelegate, UITableViewDataSource {

    func indexCellForDayOffSetting(byDayOffSettingId id: Int?) -> Int? {
        if let dayOffSettingList = getRequestDayOffTypes(byDateOffType: self.currentDateOffType),
            let setting = dayOffSettingList.index(where: { s in s.id == id }) {
            return setting
        }
        return nil
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case dayOffSectionIndex:
            return getRequestDayOffTypes(byDateOffType: self.currentDateOffType)?.count ?? 0
        default:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (2, 0):
            return UITableViewAutomaticDimension
        default:
            return RequestTextFieldCell.cellHeight //default height for a textfield cell
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RequestTextFieldCell", for: indexPath)
            if let cell = cell as? RequestTextFieldCell {
                self.setupPickerOffType(cell: cell)
            }
            return cell
        case dayOffSectionIndex:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RequestTextFieldCell", for: indexPath)
            if let cell = cell as? RequestTextFieldCell {
                if let dayOffSettingFofCell = getRequestDayOffTypes(byDateOffType: self.currentDateOffType)?[indexPath.row] {
                    self.setupDayOffTextField(cell: cell, bySetting: dayOffSettingFofCell)
                }
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CreateRequestOffTimeCell", for: indexPath)
            if let cell = cell as? CreateRequestOffTimeCell {
                self.setUpTimeCell(cell: cell)
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? RequestTextFieldCell {
            cell.validateDataOfCell()
        } else if let cell = cell as? CreateRequestOffTimeCell,
            isValidating {
            _ = cell.validateData()//try to re-validate
        }
    }
}

// MARK: setup for section of dayOff type picker
extension CreateRequestOffViewController {
    func setupPickerOffType(cell: RequestTextFieldCell) {
        cell.textField.placeholder = LocalizationHelper.shared.localized("off_type")
        cell.textField.setupPicker(picker: self.offTypePicker,
                                   selector: #selector(onOffTypeSelected),
                                   currentValue: self.currentDateOffType.toLocalizeString())
        //TODOs: set value if edit
    }

    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView === self.offTypePicker ? self.ofTypeList.count : super.pickerView(pickerView, numberOfRowsInComponent: component)
    }

    override func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerView === self.offTypePicker ? self.ofTypeList[row].toLocalizeString() : super.pickerView(pickerView, titleForRow: row, forComponent: component)
    }
}

// MARK: setup for section of dayoff textfields
extension CreateRequestOffViewController {

    func setupDayOffTextField(cell: RequestTextFieldCell, bySetting setting: DayOffSettingModel?) {
        if let setting = setting {
            cell.textField.placeholder = setting.dayOffAsString
            cell.textField.keyboardType = .numberPad
            cell.bindingContext = setting
            cell.onTextChanged = self.onDayOffValueChange

            var validateRules = ValidationRuleSet<String>()

            let compareValidator = FloatCompareValidator(min: 0,
                                                         max: setting.remaining ?? 0,
                                                         isRequired: false,
                                                         error: ValidateError.invalid(message: String(format:LocalizationHelper.shared.localized("off_type_limit_error"),                                                                                                                                                                                                                                                                                                                                                           setting.remaining ?? 0,                                                                                                                                                                               setting.unit ?? "null")))

            validateRules.add(rule: compareValidator)

            cell.setValidatorRules(rules: validateRules)

            var existingValue = ""

            if setting.isAnnualLeave {
                existingValue = currentRequestOffModel.numberDayOffNormal == 0 ? "" : "\(currentRequestOffModel.numberDayOffNormal)"
            } else if let settingId = setting.id {
                if let val = dayOffSettingBindedValues[settingId],
                    val.0 > 0 {
                    existingValue = "\(val.0)"
                } else {
                    existingValue = ""
                }
            }

            cell.textField.text = existingValue

            cell.mustValidateWhenLoaded = self.isValidating || existingValue.isNotEmpty
        }
    }
}

// MARK: setup for section of time picker & Reason textfield
extension CreateRequestOffViewController {
    func setUpTimeCell(cell: CreateRequestOffTimeCell) {
        // TODOs: set Date value if edit
        cell.setFromDate(date: self.fromDate)
        cell.setToDate(date: self.toDate)
        cell.fromDatePickerDidSelected = self.onFromDaySelected
        cell.toDatePickerDidSelected = self.onToDaySelected
        cell.fromTimeConvetionDidSelected = self.onFromTimeConventionSelected
        cell.toTimeConvetionDidSelected = self.onToTimeConventionSelected
        cell.reasonTextFieldDidEndEditing = self.reasonChanged
    }
}

extension CreateRequestOffViewController: CreateRequestOffViewControllerType {
    func didSubmitRequestSuccess() {
        //TODOs:
    }
}
