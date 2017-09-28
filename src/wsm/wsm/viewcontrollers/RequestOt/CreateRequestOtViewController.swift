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

class CreateRequestOtViewController: NoMenuBaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var fromText: WsmTextField!
    @IBOutlet weak var toText: WsmTextField!
    @IBOutlet weak var empNameText: WsmTextField!
    @IBOutlet weak var empCodeText: WsmTextField!
    @IBOutlet weak var projectText: WsmTextField!
    @IBOutlet weak var branchText: WsmTextField!
    @IBOutlet weak var groupText: WsmTextField!
    @IBOutlet weak var reasonText: WsmTextField!

    fileprivate let fromDatePicker = UIDatePicker()
    fileprivate let toDatePicker = UIDatePicker()
    fileprivate let branchPicker = UIPickerView()
    fileprivate let groupPicker = UIPickerView()

    fileprivate let requestModel = RequestOtApiInputModel()
    fileprivate let currentUser = UserServices.getLocalUserProfile()
    fileprivate var workSpaces = [UserWorkSpace]()
    fileprivate var groups = [UserGroup]()

    override func viewDidLoad() {
        super.viewDidLoad()
        registerKeyboardNotifications()

        workSpaces = currentUser?.workSpaces ?? [UserWorkSpace]()
        groups = currentUser?.groups ?? [UserGroup]()
        bindData()
        setupPicker()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func setupPicker() {
        branchPicker.delegate = self
        groupPicker.delegate = self

        branchText.inputView = branchPicker
        branchText.inputAccessoryView = UIToolbar().ToolbarPiker(selector: #selector(setBranchText))

        groupText.inputView = groupPicker
        groupText.inputAccessoryView = UIToolbar().ToolbarPiker(selector: #selector(setGroupText))
    }

    func bindData() {
        empNameText.text = currentUser?.name
        empCodeText.text = currentUser?.employeeCode

        if workSpaces.count > 0 {
            let defaultBranchId = UserServices.getLocalUserSetting()?.workSpaceDefault
            if let i = workSpaces.index(where: {$0.id == defaultBranchId}) {
                branchPicker.selectRow(i, inComponent: 0, animated: true)
            } else {
                branchPicker.selectRow(0, inComponent: 0, animated: true)
            }
            setBranchText()
        }
        if groups.count > 0 {
            let defaultGroupId = UserServices.getLocalUserSetting()?.groupDefault
            if let i = groups.index(where: {$0.id == defaultGroupId}) {
                groupPicker.selectRow(i, inComponent: 0, animated: true)
            } else {
                groupPicker.selectRow(0, inComponent: 0, animated: true)
            }
            setGroupText()
        }
    }

    @IBAction func selectFrom(_ sender: UITextField) {
        sender.inputView = fromDatePicker
        sender.inputAccessoryView = UIToolbar().ToolbarPiker(selector: #selector(setFromText))
    }

    @IBAction func selectTo(_ sender: UITextField) {
        sender.inputView = toDatePicker
        sender.inputAccessoryView = UIToolbar().ToolbarPiker(selector: #selector(setToText))
    }

    @objc private func setFromText() {
        self.view.endEditing(true)
        if requestModel.endTime != nil && !validateDate(){
            return
        }
        self.fromText.text = fromDatePicker.date.toString(dateFormat: Date.dateTimeFormat)
        requestModel.fromTime = self.fromText.text
    }

    @objc private func setToText() {
        self.view.endEditing(true)
        if requestModel.fromTime != nil && !validateDate() {
            return
        }

        self.toText.text = toDatePicker.date.toString(dateFormat: Date.dateTimeFormat)
        requestModel.endTime = self.toText.text
    }

    @objc private func setBranchText() {
        self.view.endEditing(true)
        branchText.text = workSpaces[branchPicker.selectedRow(inComponent: 0)].name
        requestModel.workspaceId = workSpaces[branchPicker.selectedRow(inComponent: 0)].id
    }

    @objc private func setGroupText() {
        groupText.text = groups[groupPicker.selectedRow(inComponent: 0)].fullName
        requestModel.groupId = groups[groupPicker.selectedRow(inComponent: 0)].id
        self.view.endEditing(true)
    }
    
    @IBAction func textEditingEnd(_ sender: UITextField) {
        if sender === reasonText {
            requestModel.reason = reasonText.text
        } else if sender === projectText {
            requestModel.projectName = projectText.text
        }
    }

    func validateDate() -> Bool {
        if toDatePicker.date < fromDatePicker.date {
            AlertHelper.showInfo(message: LocalizationHelper.shared.localized("end_time_is_less_than_start_time"))
            return false
        }
        return true
    }
}

extension CreateRequestOtViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView === branchPicker ? workSpaces.count : groups.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerView === branchPicker ? workSpaces[row].name : groups[row].fullName
    }

    @IBAction func nextBtnClick(_ sender: Any) {

        if requestModel.isValid(), let confirmOtVc = UIViewController.getStoryboardController(identifier: "ConfirmCreateRequestOtViewController") as? ConfirmCreateRequestOtViewController {
            self.requestModel.projectName = projectText.text
            self.requestModel.reason = reasonText.text
            confirmOtVc.requestModel = self.requestModel
            self.navigationController?.pushViewController(confirmOtVc, animated: true)
        } else {
            AlertHelper.showInfo(message: LocalizationHelper.shared.localized("enter_full_info"))
        }
    }
}

extension CreateRequestOtViewController {
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
    }

    func keyboardWillShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        guard let keyboardInfo = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    func keyboardWillHide(notification: Notification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
}
