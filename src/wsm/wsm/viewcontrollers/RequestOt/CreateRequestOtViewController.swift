//
//  CreateRequestOtViewController.swift
//  wsm
//
//  Created by framgia on 9/25/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import UIKit
import InAppLocalize

class CreateRequestOtViewController: RequestBaseViewController {
    
    @IBOutlet weak var fromTextField: WsmTextField!
    @IBOutlet weak var toTextField: WsmTextField!

    fileprivate let requestModel = RequestOtApiInputModel()
    let fromDatePicker = UIDatePicker()
    let toDatePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        projectNameTextField.isRequired = true
        fromTextField.isRequired = true
        toTextField.isRequired = true
        reasonTextField.isRequired = true
    }

    @IBAction func selectFrom(_ sender: UITextField) {
        sender.inputView = fromDatePicker
        sender.inputAccessoryView = UIToolbar().ToolbarPiker(selector: #selector(onFromDateSelected))
    }

    @IBAction func selectTo(_ sender: UITextField) {
        sender.inputView = toDatePicker
        sender.inputAccessoryView = UIToolbar().ToolbarPiker(selector: #selector(onToDateSelected))
    }

    @objc private func onFromDateSelected() {
        self.view.endEditing(true)
        if requestModel.endTime != nil && !validateDate(){
            return
        }
        self.fromTextField.text = fromDatePicker.date.toString(dateFormat: AppConstant.requestDateFormat)
        requestModel.fromTime = self.fromTextField.text
    }

    @objc private func onToDateSelected() {
        self.view.endEditing(true)
        if requestModel.fromTime != nil && !validateDate() {
            return
        }
        self.toTextField.text = toDatePicker.date.toString(dateFormat: AppConstant.requestDateFormat)
        requestModel.endTime = self.toTextField.text
    }

    override func onBranchSelected() {
        super.onBranchSelected()
        requestModel.workspaceId = workSpaces[branchPicker.selectedRow(inComponent: 0)].id
    }

    override func onGroupSelected() {
        super.onGroupSelected()
        requestModel.groupId = groups[groupPicker.selectedRow(inComponent: 0)].id
    }
    
    @IBAction func textEditingEnd(_ sender: WsmTextField) {
        if sender.isEmpty() {
            sender.showErrorWithText(errorText: LocalizationHelper.shared.localized("is_empty"))
        } else {
            switch sender {
            case reasonTextField:
                requestModel.reason = sender.text
            case projectNameTextField:
                requestModel.projectName = sender.text
            default:
                break
            }
        }
    }

    func validateDate() -> Bool {
        if toDatePicker.date < fromDatePicker.date {
            AlertHelper.showInfo(message: LocalizationHelper.shared.localized("end_time_is_less_than_start_time"))
            return false
        }
        return true
    }

    func isValid() -> Bool {
        var result = true
        let error = LocalizationHelper.shared.localized("is_empty")
        if projectNameTextField.isEmpty() {
            projectNameTextField.showErrorWithText(errorText: error)
            result = false
        }
        if fromTextField.isEmpty() {
            fromTextField.showErrorWithText(errorText: error)
            result = false
        }
        if toTextField.isEmpty() {
            toTextField.showErrorWithText(errorText: error)
            result = false
        }
        if reasonTextField.isEmpty() {
            reasonTextField.showErrorWithText(errorText: error)
            result = false
        }
        return result
    }

    @IBAction func nextBtnClick(_ sender: Any) {
        if isValid() && requestModel.isValid(),
            let confirmOtVc = UIViewController.getStoryboardController(identifier: "ConfirmCreateRequestOtViewController") as? ConfirmCreateRequestOtViewController {
            self.requestModel.projectName = projectNameTextField.text
            self.requestModel.reason = reasonTextField.text
            confirmOtVc.requestModel = self.requestModel
            self.navigationController?.pushViewController(confirmOtVc, animated: true)
        }
    }
}
