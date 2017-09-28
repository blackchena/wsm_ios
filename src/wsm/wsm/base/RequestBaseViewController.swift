//
//  RequestBaseViewController.swift
//  wsm
//
//  Created by framgia on 9/28/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import UIKit
import InAppLocalize

class RequestBaseViewController: NoMenuBaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var empNameTextField: WsmTextField!
    @IBOutlet weak var empCodeTextField: WsmTextField!
    @IBOutlet weak var branchTextField: WsmTextField!
    @IBOutlet weak var groupTextField: WsmTextField!
    @IBOutlet weak var projectNameTextField: WsmTextField!
    @IBOutlet weak var reasonTextField: WsmTextField!

    let fromDatePicker = UIDatePicker()
    let toDatePicker = UIDatePicker()
    let branchPicker = UIPickerView()
    let groupPicker = UIPickerView()

    let currentUser = UserServices.getLocalUserProfile()
    var workSpaces = [UserWorkSpace]()
    var groups = [UserGroup]()

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

        branchTextField.inputView = branchPicker
        branchTextField.inputAccessoryView = UIToolbar().ToolbarPiker(selector: #selector(setBranchText))

        groupTextField.inputView = groupPicker
        groupTextField.inputAccessoryView = UIToolbar().ToolbarPiker(selector: #selector(setGroupText))
    }

    func bindData() {
        empNameTextField.text = currentUser?.name
        empCodeTextField.text = currentUser?.employeeCode

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

    @objc func setBranchText() {
        self.view.endEditing(true)
        branchTextField.text = workSpaces[branchPicker.selectedRow(inComponent: 0)].name
    }

    @objc func setGroupText() {
        self.view.endEditing(true)
        groupTextField.text = groups[groupPicker.selectedRow(inComponent: 0)].fullName
    }
}

extension RequestBaseViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView === branchPicker ? workSpaces.count : groups.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerView === branchPicker ? workSpaces[row].name : groups[row].fullName
    }
}

extension RequestBaseViewController {
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
