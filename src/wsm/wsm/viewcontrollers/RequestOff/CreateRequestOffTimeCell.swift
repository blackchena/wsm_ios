//
//  CreateRequestOffTimeCell.swift
//  wsm
//
//  Created by Lê Thanh Quang on 10/5/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import Validator
import InAppLocalize

private struct CreateCellConstants {
    static let numberToEnableReplacement = 3
}

class CreateRequestOffTimeCell: UITableViewCell {

    //MARK: IBOutlet
    @IBOutlet weak var fromDayTextField: WsmTextField!
    @IBOutlet weak var fromTimeConventionTextField: WsmTextField!
    @IBOutlet weak var toDayTextField: WsmTextField!
    @IBOutlet weak var toTimeConventionTextField: WsmTextField!
    @IBOutlet weak var reasonTextField: WsmTextField!
    @IBOutlet weak var replacementTextField: WsmTextField!
    fileprivate let timeConventionTypeList: [TimeConventionType] = [.am, .pm]
    fileprivate let fromTimeConventionPicker = UIPickerView()
    fileprivate let toTimeConventionPicker = UIPickerView()
    fileprivate let fromDatePicker = UIDatePicker()
    fileprivate let toDatePicker = UIDatePicker()
    fileprivate let replacementPicker = UIPickerView()

    public var fromDatePickerDidSelected: ((CreateRequestOffTimeCell, Date) -> Bool)?
    public var toDatePickerDidSelected: ((CreateRequestOffTimeCell, Date) -> Bool)?

    public var fromTimeConvetionDidSelected: ((TimeConventionType) -> Bool)?
    public var toTimeConvetionDidSelected: ((TimeConventionType) -> Bool)?
    public var replacementDidSelected: (() -> Bool)?
    public var reasonTextFieldDidEndEditing: ((String?) -> Void)?
    public var replacementTextfieldDidEndEditing: ((ReplacementModel?) -> Void)?
    fileprivate var listTheReplacement = [ReplacementModel]()
    var currentTheReplacement: ReplacementModel?
    
    public func setFromDate(date: Date?) {
        if let date = date {
            fromDatePicker.date = date
        }

        fromDayTextField.text = date?.toString(dateFormat: AppConstant.onlyDateFormat)
    }

    public func setToDate(date: Date?) {
        if let date = date {
            toDatePicker.date = date
        }

        toDayTextField.text = date?.toString(dateFormat: AppConstant.onlyDateFormat)
    }

    public func setFromTimeConvention(convention: TimeConventionType?) {
        if let convention = convention {
            fromTimeConventionPicker.selectRow(convention == .am ? 0 : 1, inComponent: 0, animated: false)
            fromTimeConventionTextField.text = convention.rawValue
        }
    }

    public func setToTimeConvention(convention: TimeConventionType?) {
        if let convention = convention {
            toTimeConventionPicker.selectRow(convention == .am ? 0 : 1, inComponent: 0, animated: false)
            toTimeConventionTextField.text = convention.rawValue
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        reasonTextField.isRequired = true

        //date picker setup
        fromDatePicker.datePickerMode = .date
        fromDatePicker.date = Date()
        fromDayTextField.isPicker = true

        toDatePicker.datePickerMode = .date
        toDatePicker.date = Date()
        toDayTextField.isPicker = true

        fromTimeConventionPicker.delegate = self
        fromTimeConventionTextField.setupPicker(picker: fromTimeConventionPicker,
                                                selector: #selector(onFromTimeConventionSelected), target: self)
        setFromTimeConvention(convention: .am)

        toTimeConventionPicker.delegate = self
        toTimeConventionTextField.setupPicker(picker: toTimeConventionPicker,
                                              selector: #selector(onToTimeConventionSelected), target: self)
        setToTimeConvention(convention: .am)
        
        getListTheReplacement()
        replacementPicker.delegate = self
        replacementTextField.delegate = self
        replacementTextField.setupPicker(
            picker: replacementPicker,
            selector: #selector(theReplacementPickerSelected),
            target: self
        )
        replacementTextField.isEnabled = false
        reasonTextField.delegate = self
    }
    
    func getListTheReplacement() {
        guard let groupId = UserServices.getLocalUserProfile()?.groups?.first?.id else {
            return
        }
        RequestOffProvider.getListTheReplacement(groupId: groupId)
            .then { apiOutput -> Void in
                if let theReplacements = apiOutput.replacements {
                    self.listTheReplacement.append(contentsOf: theReplacements)
                }
            }.catch { error in
                AlertHelper.showError(error: error)
            }
    }

    func enableReplacement(numberDayOff: Int?) {
        if let numberDayOff = numberDayOff, numberDayOff >= CreateCellConstants.numberToEnableReplacement {
            replacementTextField.isEnabled = true
            replacementTextField.text = currentTheReplacement?.name
        } else {
            replacementTextField.isEnabled = false
            replacementTextField.text = nil
        }
    }
    
    public func validateData() -> Bool {
        var result = true

        result = fromDayTextField.validate(rule: StringRequiredValidator(error: ValidateError.custom(withLocalizeKey: "is_empty")), withShowError: true) && result
        result = toDayTextField.validate(rule: StringRequiredValidator(error: ValidateError.custom(withLocalizeKey: "is_empty")), withShowError: true) && result
        result = reasonTextField.validate(rule: StringRequiredValidator(error: ValidateError.custom(withLocalizeKey: "is_empty")), withShowError: true) && result

        return result
    }

    @IBAction func showFromDayPicker(_ sender: Any) {
        fromDayTextField.setupDatePicker(picker: fromDatePicker, selector: #selector(onFromDatePickerSelected), target: self, currentValue: fromDayTextField.text)
    }

    @IBAction func showToDayPicker(_ sender: Any) {
        toDayTextField.setupDatePicker(picker: toDatePicker, selector: #selector(onToDatePickerSelected), target: self, currentValue: toDayTextField.text)
    }

    @objc private func onFromDatePickerSelected() {
        self.endEditing(true)
        if let isOk = self.fromDatePickerDidSelected?(self, fromDatePicker.date),
            isOk {
            fromDayTextField.text = fromDatePicker.date.toString(dateFormat: AppConstant.onlyDateFormat)
        }
    }

    @objc private func onToDatePickerSelected() {
        self.endEditing(true)
        if let isOk = self.toDatePickerDidSelected?(self, toDatePicker.date),
            isOk {
            toDayTextField.text = toDatePicker.date.toString(dateFormat: AppConstant.onlyDateFormat)
        }
    }

    @objc func onFromTimeConventionSelected() {
        self.endEditing(true)
        if let isOk = self.fromTimeConvetionDidSelected?(timeConventionTypeList[fromTimeConventionPicker.selectedRow(inComponent: 0)]),
            isOk {
            fromTimeConventionTextField.text = timeConventionTypeList[fromTimeConventionPicker.selectedRow(inComponent: 0)].rawValue
        }
    }

    @objc private func onToTimeConventionSelected() {
        self.endEditing(true)
        if let isOk = self.toTimeConvetionDidSelected?(timeConventionTypeList[toTimeConventionPicker.selectedRow(inComponent: 0)]),
            isOk {
            toTimeConventionTextField.text = timeConventionTypeList[toTimeConventionPicker.selectedRow(inComponent: 0)].rawValue
        }
    }

    @objc private func theReplacementPickerSelected() {
        endEditing(true)
    }
    
    @IBAction func onReasonTextFieldEditingDidEnd(_ sender: Any) {
        reasonTextFieldDidEndEditing?(reasonTextField.text)
    }
    
    @IBAction func onReplacementTextFieldEditingDidEnd(_ sender: Any){
        replacementTextfieldDidEndEditing?(currentTheReplacement)
    }
    
}

extension CreateRequestOffTimeCell:  UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == replacementPicker {
            return listTheReplacement.count
        }
        return timeConventionTypeList.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == replacementPicker {
            return listTheReplacement[row].name
        }
        return timeConventionTypeList[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == replacementPicker {
            replacementTextField.text =  listTheReplacement[row].name
            currentTheReplacement = listTheReplacement[row]
        }
    }
    
}

extension CreateRequestOffTimeCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == replacementTextField {
            replacementTextField.text = self.currentTheReplacement?.name
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == reasonTextField {
           textField.endEditing(true)
        }
        return true;
    }
}
