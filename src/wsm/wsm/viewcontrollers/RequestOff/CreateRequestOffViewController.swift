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

fileprivate enum DayOffPayType {
    case haveSalary
    case noSalary
}

class CreateRequestOffViewController: RequestBaseViewController {

    //MARK: IBOutlet
    fileprivate let dayOffSectionIndex = 1
    fileprivate let offTypePicker = UIPickerView()

    fileprivate let offTypeList: [DateOffType] = [.haveSalaryCompanyPay, .haveSalaryInsuranceCoverage, .noSalary]

    fileprivate var currentRequestOffModel = RequestOffDetailApiInputModel()
    fileprivate var currentDateOffType: DateOffType = .haveSalaryCompanyPay
    fileprivate var reasonText: String?
    fileprivate var isValidating = false

    fileprivate var dayOffSettingBindedValues = [Int: (Float, Bool, DayOffSettingModel)]()
    fileprivate var timeWithOffTypes = [DayOffPayType : (RequestDayOffFromModel, RequestDayOffToModel)]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        offTypePicker.delegate = self

        self.tableView?.register(UINib(nibName: "RequestTextFieldCell", bundle: nil), forCellReuseIdentifier: "RequestTextFieldCell")
        self.tableView?.delegate = self
        self.tableView?.dataSource = self

        self.tableView?.estimatedRowHeight = 44

        //initial value
        timeWithOffTypes[.haveSalary] = (currentRequestOffModel.offHaveSalaryFrom, currentRequestOffModel.offHaveSalaryTo)
        timeWithOffTypes[.noSalary] = (currentRequestOffModel.offNoSalaryFrom, currentRequestOffModel.offNoSalaryTo)
    }

    func bindDataToModel() {
        currentRequestOffModel.workSpaceId = basicInfoHeaderView.selectedWorkSpace.id ?? 0
        currentRequestOffModel.groupId = basicInfoHeaderView.selectedGroup.id ?? 0
        currentRequestOffModel.projectName = basicInfoHeaderView.projectName
        //        currentRequestOffModel.positionName = basicInfoHeaderView.


        //        currentRequestOffModel.offHaveSalaryFrom = RequestDayOffFromModel()
        //        currentRequestOffModel.offHaveSalaryTo = RequestDayOffToModel()

        if let haveSalaryoff = timeWithOffTypes[.haveSalary] {
            currentRequestOffModel.offHaveSalaryFrom = haveSalaryoff.0
            currentRequestOffModel.offHaveSalaryTo = haveSalaryoff.1
        }

        if let noHaveSalaryOff = timeWithOffTypes[.noSalary] {
            currentRequestOffModel.offNoSalaryFrom = noHaveSalaryOff.0
            currentRequestOffModel.offNoSalaryTo = noHaveSalaryOff.1
        }

        currentRequestOffModel.requestDayOffTypesAttributes = generateDayOffTypeAttributes(dayOffSettingBindedValue: dayOffSettingBindedValues)

        currentRequestOffModel.numberDayOffNormal = dayOffSettingBindedValues[AppConstant.annualDayOffSettingId]?.0 ?? 0

        currentRequestOffModel.reason = reasonText ?? ""
    }

    @objc fileprivate func onOffTypeSelected() {
        self.view.endEditing(true)

        self.currentDateOffType = offTypeList[offTypePicker.selectedRow(inComponent: 0)]
        //TODOs: update UI
        isValidating = false

        self.tableView?.reloadData()
    }

    fileprivate func setTimeValueForCurrentOffType(closure: (((RequestDayOffFromModel, RequestDayOffToModel)) -> Void)) {

        if !currentDateOffType.isHaveSalary,
            let noSalary = self.timeWithOffTypes[.noSalary] {
            closure(noSalary)
        } else {
            if let haveSalary = self.timeWithOffTypes[.haveSalary] {
                closure(haveSalary)
            }
        }
    }

    fileprivate func setTimeValueForCurrentOffTypeWithValidate(closure: (((RequestDayOffFromModel, RequestDayOffToModel)) -> Bool)) -> Bool {

        if !currentDateOffType.isHaveSalary,
            let noSalary = self.timeWithOffTypes[.noSalary] {
            return closure(noSalary)
        } else {

            var result = false
            if let haveSalary = self.timeWithOffTypes[.haveSalary] {
                result = closure(haveSalary)
            }

            return result
        }
    }

    fileprivate func getTimeValueForCurrentOffType() -> (RequestDayOffFromModel, RequestDayOffToModel) {

        if !currentDateOffType.isHaveSalary {

            //makesure that key not nil
            if self.timeWithOffTypes[.noSalary] == nil {
                self.timeWithOffTypes[.noSalary] = (RequestDayOffFromModel(isHaveSalary: false), RequestDayOffToModel(isHaveSalary: false))
            }

            return self.timeWithOffTypes[.noSalary]!
        } else {
            if self.timeWithOffTypes[.haveSalary] == nil {
                self.timeWithOffTypes[.haveSalary] = (RequestDayOffFromModel(isHaveSalary: true), RequestDayOffToModel(isHaveSalary: true))
            }
            return self.timeWithOffTypes[.haveSalary]!
        }
    }

    fileprivate func onFromDaySelected(sender: CreateRequestOffTimeCell, date: Date) -> Bool {

        setTimeValueForCurrentOffType(closure: { (from, to) in
            from.offPaidFrom = date
            to.offPaidTo = nil
        })

        self.tableView?.reloadData()
        self.tableView?.scrollToRow(at: IndexPath.init(row: 0, section: 2), at: .middle, animated: false)
        return true
    }

    fileprivate func onFromTimeConventionSelected(convention: TimeConventionType) -> Bool {
        setTimeValueForCurrentOffType(closure: { (from, _) in
            from.paidFromPeriod = convention
        })

        return true
    }

    fileprivate func onToDaySelected(sender: CreateRequestOffTimeCell, date: Date) -> Bool {

        return setTimeValueForCurrentOffTypeWithValidate(closure: { (from, to) -> Bool in
            if from.offPaidFrom == nil {
                AlertHelper.showInfo(message: LocalizationHelper.shared.localized("you_have_to_choose_start_date"))
                return false
            } else if from.offPaidFrom! > date {
                AlertHelper.showInfoWithPromise(message: LocalizationHelper.shared.localized("end_date_must_greater_than_start_day")).always {
                    _ = sender.toDayTextField.becomeFirstResponder()
                }
                return false
            } else {
                to.offPaidTo = date
                return true
            }
        })
    }

    fileprivate func onToTimeConventionSelected(convention: TimeConventionType) -> Bool {
        setTimeValueForCurrentOffType(closure: { (_, to) in
            to.paidToPeriod = convention
        })

        return true
    }

    fileprivate func validateDayOffField() -> Bool {
        isValidating = true

        //validate current dayoff first, if current dayoff is valid -> validate other dayoff | else show error of current dayoff

        //1. validate current dayoff
        let (isTimeCellValid, isDayOffSettingValid, indexPath) = validateDayOff(offType: currentDateOffType)

        switch (isTimeCellValid, isDayOffSettingValid, indexPath) {
        case (false, _, let indexPath):
            self.tableView?.reloadData()
            if let indexPath = indexPath {
                self.tableView?.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
            return false
        case (true, false, let indexPath):
            if let indexPath = indexPath {
                self.tableView?.scrollToRow(at: indexPath, at: .middle, animated: false)
            } else {
                //TODOs this case
                AlertHelper.showError(message: LocalizationHelper.shared.localized("the_number_of_days_allowed"))
            }
            return false
        default:
            break
        }


        //2. continue validate other dayoffs
        //   if the other dayoffs don't bind any value (it's mean emtpy dayOffSetting) to dayOffSetting field, just skip
        for offSetting in offTypeList {
            if offSetting != currentDateOffType {
                let (isTimeCellValid, isDayOffSettingValid, _) = validateDayOff(offType: offSetting, skipEmptyDayOffSetting: true)

                if !isTimeCellValid {
                    //show message error
                    AlertHelper.showError(message: LocalizationHelper.shared.localized(offSetting.isHaveSalary ? "datetime_have_salary_can_not_empty" : "datetime_no_salary_can_not_empty"))
                    return false
                } else if !isDayOffSettingValid {
                    //show message error
                    //TODOs: show this error with name of offType
                    AlertHelper.showError(message: LocalizationHelper.shared.localized("the_number_of_days_allowed"))
                    return false
                }
            }
        }

        //success
        bindDataToModel()
        return true
    }

    private func countDayOffSettingBindedValues(byDateOffType offType: DateOffType) -> Int {

        if let listIdDayOffSetting = getRequestDayOffTypes(byDateOffType: offType)?.filter({ f -> Bool in return f.id != nil }).map({ o -> Int in return o.id! }) {
            let allDayOffSettingBinded = [Int](dayOffSettingBindedValues.keys)

            return listIdDayOffSetting.filter(allDayOffSettingBinded.contains).count
        }

        return 0
    }

    /**
     * return tuple (0,1,2) where
     * 0: isTimeCellValid
     * 1: isDayOffSettingValid
     * 2: IndexPath of invalid cell
     */
    fileprivate func validateDayOff(offType: DateOffType, skipEmptyDayOffSetting: Bool = false) -> (Bool, Bool, IndexPath?) {
        //if .noSalary -> just fill time from & to
        // else must fill atleast 1 valid field

        //1. validate datetime section first
        var isTimeCellValid = false
        let currentOffTypeTime = timeWithOffTypes[offType.isHaveSalary ? .haveSalary : .noSalary] ?? (RequestDayOffFromModel(isHaveSalary: offType.isHaveSalary), RequestDayOffToModel(isHaveSalary: offType.isHaveSalary))

        isTimeCellValid = currentOffTypeTime.0.offPaidFrom != nil && currentOffTypeTime.1.offPaidTo != nil

        isTimeCellValid = (reasonText?.isNotEmpty ?? false) && isTimeCellValid

        if skipEmptyDayOffSetting,
            countDayOffSettingBindedValues(byDateOffType: offType) == 0 {

            if currentDateOffType.isHaveSalary == offType.isHaveSalary {
                return (true, true, nil)
            }
            else if currentOffTypeTime.0.offPaidFrom != nil {
                return (currentOffTypeTime.0.offPaidFrom != nil && currentOffTypeTime.1.offPaidTo != nil, true, nil)
            } else {
                return (currentOffTypeTime.0.offPaidFrom == nil && currentOffTypeTime.1.offPaidTo == nil, true, nil)
            }
        }

        if offType == .noSalary {
            //this is .noSalary, just validate datetime section
            return (isTimeCellValid, true, IndexPath.init(row: 0, section: 2))
        }

        var isValid = false
        var firstRowIndexOfInvalidateDayOffCell = -1

        //continue validate dayoff setting section and get first index of invalid cell
        for dayOff in dayOffSettingBindedValues {
            isValid = dayOff.value.0 > 0 && dayOff.value.1

            if !isValid && firstRowIndexOfInvalidateDayOffCell == -1,
                dayOff.value.0 > 0,
                let index = self.indexCellForDayOffSetting(byDayOffSettingId: dayOff.key) {
                firstRowIndexOfInvalidateDayOffCell = index
            }
        }

        var indexPath: IndexPath?

        if !isTimeCellValid {
            indexPath = IndexPath.init(row: 0, section: 2)
        } else if firstRowIndexOfInvalidateDayOffCell != -1 {
            indexPath = IndexPath.init(row: firstRowIndexOfInvalidateDayOffCell, section: dayOffSectionIndex)
        }

        return (isTimeCellValid, isValid, indexPath)
    }

    @IBAction func nextButtonClicked(_ sender: Any) {
        if validateDayOffField(),
            let confirmVc = UIViewController.getStoryboardController(identifier: "ConfirmCreateRequestOffViewController")
                as? ConfirmCreateRequestOffViewController {

                confirmVc.dayOffSettingBindedValues = self.dayOffSettingBindedValues
                confirmVc.requestOffInputDetailModel = self.currentRequestOffModel
                self.navigationController?.pushViewController(confirmVc, animated: true)
            }
    }
    

    fileprivate func reasonChanged(reason: String?) {
        reasonText = reason
    }

    fileprivate func onDayOffValueChange(cell: RequestTextFieldCell, bindingContext: Any?, value: String?) {
        if let cellDayOffSetting = bindingContext as? DayOffSettingModel {

            let dayOffSettingBindedValue = Float.init(cell.textField.text ?? "")

            if let cellDayOffSettingId = cellDayOffSetting.id {
                if let dayOffSettingBindedValue = dayOffSettingBindedValue {
                    dayOffSettingBindedValues[cellDayOffSettingId] = (dayOffSettingBindedValue, cell.textField.validate().isValid, cellDayOffSetting)
                } else {
                    dayOffSettingBindedValues.removeValue(forKey: cellDayOffSettingId)
                }
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
        return pickerView === self.offTypePicker ? self.offTypeList.count : super.pickerView(pickerView, numberOfRowsInComponent: component)
    }

    override func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerView === self.offTypePicker ? self.offTypeList[row].toLocalizeString() : super.pickerView(pickerView, titleForRow: row, forComponent: component)
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

            if let settingId = setting.id {
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
        cell.setFromDate(date: self.getTimeValueForCurrentOffType().0.offPaidFrom)
        cell.setToDate(date: self.getTimeValueForCurrentOffType().1.offPaidTo)
        cell.setFromTimeConvention(convention: self.getTimeValueForCurrentOffType().0.paidFromPeriod)
        cell.setToTimeConvention(convention: self.getTimeValueForCurrentOffType().1.paidToPeriod)
        
        cell.fromDatePickerDidSelected = self.onFromDaySelected
        cell.toDatePickerDidSelected = self.onToDaySelected
        cell.fromTimeConvetionDidSelected = self.onFromTimeConventionSelected
        cell.toTimeConvetionDidSelected = self.onToTimeConventionSelected
        cell.reasonTextFieldDidEndEditing = self.reasonChanged
    }
}

extension CreateRequestOffViewController: CreateRequestOffViewControllerType {
//    func didSubmitRequestSuccess() {        
//
//    }
}
