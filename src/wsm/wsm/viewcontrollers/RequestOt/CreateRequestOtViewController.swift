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

    var requestModel = RequestOtApiInputModel()
    weak var listRequestDelegate: ListRequestDelegte?
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
        if !isFromDateEmpty() {
            sender.inputView = toDatePicker
            sender.inputAccessoryView = UIToolbar().ToolbarPiker(selector: #selector(onToDateSelected))
        }
    }

    @objc private func onFromDateSelected() {
        self.view.endEditing(true)
        fromTextField.text = fromDatePicker.date.toString(dateFormat: AppConstant.requestDateFormat)
        toTextField.text = ""
        requestModel.fromTime = self.fromTextField.text
        requestModel.endTime = ""
    }

    @objc private func onToDateSelected() {
        self.view.endEditing(true)
        if isRequestTimeValid() {
            self.toTextField.text = toDatePicker.date.toString(dateFormat: AppConstant.requestDateFormat)
            requestModel.endTime = self.toTextField.text
        }
    }

    override func onBranchSelected() {
        super.onBranchSelected()
        requestModel.workspaceId = workSpaces[branchPicker.selectedRow(inComponent: 0)].id
    }

    override func onGroupSelected() {
        super.onGroupSelected()
        requestModel.groupId = groups[groupPicker.selectedRow(inComponent: 0)].id
    }
    
    override func bindData() {
        super.bindData()
        if requestModel.id != nil {
            title = LocalizationHelper.shared.localized("edit_overtime_request")
            
            branchTextField.isEnabled = false
            groupTextField.isEnabled = false
            
            branchTextField.textColor = UIColor.lightGray
            groupTextField.textColor = UIColor.lightGray
            
            projectNameTextField.text = requestModel.projectName
            fromTextField.text = requestModel.fromTime
            toTextField.text = requestModel.endTime
            reasonTextField.text = requestModel.reason
            if let fromTime = requestModel.fromTime?.toDate(dateFormat: AppConstant.requestDateFormat) {
                fromDatePicker.date = fromTime
            }
            if let toTime = requestModel.endTime?.toDate(dateFormat: AppConstant.requestDateFormat) {
                toDatePicker.date = toTime
            }
        }
    }
    
    @IBAction func textEditingEnd(_ sender: WsmTextField) {
        if !sender.isEmpty() {
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

    @IBAction func nextBtnClick(_ sender: Any) {
        guard isRequestValid(), requestModel.isValid(),
              let confirmOtViewController = getViewController(identifier: "ConfirmCreateRequestOtViewController")
              as? ConfirmCreateRequestOtViewController else {
            return
        }
        requestModel.projectName = projectNameTextField.text
        requestModel.reason = reasonTextField.text
        confirmOtViewController.requestModel = requestModel
        confirmOtViewController.listRequestDelegate = listRequestDelegate
        navigationController?.pushViewController(confirmOtViewController, animated: true)
    }
}

extension CreateRequestOtViewController {
    func isRequestValid() -> Bool {
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

    func isRequestTimeValid() -> Bool {
        if toDatePicker.date <= fromDatePicker.date {
            AlertHelper.showInfo(message: LocalizationHelper.shared.localized("end_time_is_less_than_start_time"))
            return false
        }
        return true
    }

    func isFromDateEmpty () -> Bool {
        if fromTextField.isEmpty() {
            AlertHelper.showError(message: LocalizationHelper.shared.localized("you_have_to_choose_the_from_time_first"))
            return true
        }
        return false
    }
}
