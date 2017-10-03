//
//  CreateRequestOtViewController.swift
//  wsm
//
//  Created by framgia on 9/28/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import UIKit
import InAppLocalize

class CreateRequestLeaveViewController: RequestBaseViewController {

    @IBOutlet weak var trackingView: UIView!
    @IBOutlet weak var trackingBothView: UIView!
    @IBOutlet weak var trackingCheckInView: UIView!
    @IBOutlet weak var trackingCheckOutView: UIView!
    @IBOutlet weak var compensationView: UIView!

    @IBOutlet weak var trackingTextField: WsmTextField!
    @IBOutlet weak var checkInTextField: WsmTextField!
    @IBOutlet weak var checkOutTextField: WsmTextField!
    @IBOutlet weak var leaveTypeTextField: WsmTextField!
    @IBOutlet weak var compensationFromTextField: WsmTextField!
    @IBOutlet weak var compensationToTextField: WsmTextField!

    @IBOutlet weak var trackingLabel: LocalizableLabel!
    @IBOutlet weak var trackingExampleLabel: LocalizableLabel!
    @IBOutlet weak var checkInLabel: LocalizableLabel!
    @IBOutlet weak var checkOutLabel: LocalizableLabel!
    @IBOutlet weak var checkInExampleLabel: LocalizableLabel!
    @IBOutlet weak var checkOutExampleLabel: LocalizableLabel!
    @IBOutlet weak var checkInViewFullWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var checkInViewHalfWidthConstraint: NSLayoutConstraint!

    fileprivate let requestModel = RequestLeaveApiInputModel()
    fileprivate let leaveTypes = UserServices.getLocalLeaveTypeSettings() ?? [LeaveTypeModel]()

    fileprivate let halfWidth: CGFloat = 0.475
    fileprivate let leaveTypePicker = UIPickerView()
    fileprivate let trackingDatePicker = UIDatePicker()
    fileprivate let checkInDatePicker = UIDatePicker()
    fileprivate let checkOutDatePicker = UIDatePicker()
    fileprivate let compensationFromDatePicker = UIDatePicker()
    fileprivate let compensationToDatePicker = UIDatePicker()
    fileprivate var contentSizeNoCompensation: CGSize!
    fileprivate var contentSizeWithCompensation: CGSize!

    override func viewDidLoad() {
        super.viewDidLoad()
        onLeaveTypeSelected()
    }

    override func setupPicker() {
        super.setupPicker()

        leaveTypePicker.delegate = self
        leaveTypeTextField.inputView = leaveTypePicker
        leaveTypeTextField.inputAccessoryView = UIToolbar().ToolbarPiker(selector: #selector(onLeaveTypeSelected))
    }

    override func bindData() {
        super.bindData()

        if leaveTypes.count > 0 {
            leaveTypePicker.selectRow(0, inComponent: 0, animated: true)
            onLeaveTypeSelected()
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

    @objc func onLeaveTypeSelected() {
        self.view.endEditing(true)
        let typeSelected = leaveTypes[leaveTypePicker.selectedRow(inComponent: 0)]
        leaveTypeTextField.text = typeSelected.name
        requestModel.leaveTypeId = typeSelected.id

        switch typeSelected.trackingTimeType {
        case .checkOut:
            trackingLabel.text = LocalizationHelper.shared.localized("title_leave_early_m")
            trackingExampleLabel.text = LocalizationHelper.shared.localized("exmple_leave_early_m")
            break
        case .checkInM,
             .checkIn:
            trackingLabel.text = LocalizationHelper.shared.localized("title_in_late_m")
            trackingExampleLabel.text = LocalizationHelper.shared.localized("exmple_in_late_m")
        case .checkInA:
            trackingLabel.text = LocalizationHelper.shared.localized("title_in_late_a")
            trackingExampleLabel.text = LocalizationHelper.shared.localized("exmple_in_late_a")
        default:
            break
        }

        trackingView.isHidden = typeSelected.trackingTimeType == .both
        trackingBothView.isHidden = !trackingView.isHidden

        switch typeSelected.compensationKind {
        case .require:
            compensationView.isHidden = false
            scrollView.contentSize = CGSize(width:scrollView.contentSize.width,
                                            height: compensationView.frame.maxY)

        case .notRequire:
            compensationView.isHidden = true
            scrollView.contentSize = CGSize(width: scrollView.contentSize.width,
                                            height: compensationView.frame.minY + 10)
        }
    }

    @IBAction func nextButtonClick(_ sender: Any) {
        if /*isValid() && requestModel.isValid(),*/
            let confirmVc = UIViewController.getStoryboardController(identifier: "ConfirmCreateRequestLeaveViewController") as? ConfirmCreateRequestLeaveViewController {
            self.requestModel.projectName = projectNameTextField.text
            self.requestModel.reason = reasonTextField.text
            confirmVc.requestModel = self.requestModel
            self.navigationController?.pushViewController(confirmVc, animated: true)
        }

    }

    @objc private func onTrackingDateSelected() {
        self.view.endEditing(true)
        self.trackingTextField.text = trackingDatePicker.date.toString(dateFormat: Date.dateTimeFormat)

        let trackingType = leaveTypes[leaveTypePicker.selectedRow(inComponent: 0)].trackingTimeType
        switch trackingType {
        case .checkOut:
            requestModel.checkoutTime = self.trackingTextField.text
            break
        case .checkInM,
             .checkIn,
             .checkInA:
            requestModel.checkinTime = self.trackingTextField.text
        default:
            break
        }

        trackingView.isHidden = trackingType == .both
        trackingBothView.isHidden = !trackingView.isHidden
    }

    @objc private func onCheckInDateSelected() {
        self.view.endEditing(true)
        self.checkInTextField.text = checkInDatePicker.date.toString(dateFormat: Date.dateTimeFormat)
        requestModel.checkinTime = self.checkInTextField.text
    }

    @objc private func onCheckOutDateSelected() {
        self.view.endEditing(true)
        self.checkOutTextField.text = checkOutDatePicker.date.toString(dateFormat: Date.dateTimeFormat)
        requestModel.checkoutTime = self.checkOutTextField.text
    }

    @objc private func onConpensationFromDateSelected() {
        self.view.endEditing(true)
        self.compensationFromTextField.text = compensationFromDatePicker.date.toString(dateFormat: Date.dateTimeFormat)
        requestModel.compensationAttributes.compensationFrom = self.compensationFromTextField.text
    }

    @objc private func onConpensationToDateSelected() {
        self.view.endEditing(true)
        self.compensationToTextField.text = compensationToDatePicker.date.toString(dateFormat: Date.dateTimeFormat)
        requestModel.compensationAttributes.compensationTo = self.compensationToTextField.text
    }

    @IBAction func selectTrackingDate(_ sender: UITextField) {
        trackingTextField.inputView = trackingDatePicker
        trackingTextField.inputAccessoryView = UIToolbar().ToolbarPiker(selector: #selector(onTrackingDateSelected))
    }

    @IBAction func selectCheckInDate(_ sender: UITextField) {
        checkInTextField.inputView = checkInDatePicker
        checkInTextField.inputAccessoryView = UIToolbar().ToolbarPiker(selector: #selector(onCheckInDateSelected))
    }

    @IBAction func selectCheckOutDate(_ sender: UITextField) {
        checkOutTextField.inputView = checkOutDatePicker
        checkOutTextField.inputAccessoryView = UIToolbar().ToolbarPiker(selector: #selector(onCheckOutDateSelected))
    }

    @IBAction func selectCompensationFromDate(_ sender: UITextField) {
        compensationFromTextField.inputView = compensationFromDatePicker
        compensationFromTextField.inputAccessoryView = UIToolbar().ToolbarPiker(selector: #selector(onConpensationFromDateSelected))
    }

    @IBAction func selectCompensationToDate(_ sender: UITextField) {
        compensationToTextField.inputView = compensationToDatePicker
        compensationToTextField.inputAccessoryView = UIToolbar().ToolbarPiker(selector: #selector(onConpensationToDateSelected))
    }
}

extension CreateRequestLeaveViewController {

    override func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case branchPicker:
            return workSpaces.count
        case groupPicker:
            return groups.count
        case leaveTypePicker:
            return leaveTypes.count
        default:
            return 0
        }
    }

    override func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case branchPicker:
            return workSpaces[row].name
        case groupPicker:
            return groups[row].fullName
        case leaveTypePicker:
            return leaveTypes[row].name
        default:
            return ""
        }
    }
}
