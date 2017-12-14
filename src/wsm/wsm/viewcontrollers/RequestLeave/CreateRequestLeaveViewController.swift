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

    weak var listRequestDelegate: ListRequestDelegte?
    var requestModel = RequestLeaveApiInputModel()
    fileprivate let emptyError = LocalizationHelper.shared.localized("is_empty")
    fileprivate let leaveTypes = UserServices.getLocalLeaveTypeSettings() ?? [LeaveTypeModel]()

    fileprivate let leaveTypePicker = UIPickerView()
    fileprivate let trackingDatePicker = UIDatePicker()
    fileprivate let checkInDatePicker = UIDatePicker()
    fileprivate let checkOutDatePicker = UIDatePicker()
    fileprivate let compensationFromDatePicker = UIDatePicker()
    fileprivate let compensationToDatePicker = UIDatePicker()
    fileprivate var contentSizeNoCompensation: CGSize!
    fileprivate var contentSizeWithCompensation: CGSize!
    fileprivate var isBinding = true

    override func viewDidLoad() {
        super.viewDidLoad()

        requestModel.companyId = currentUser?.company?.id

        trackingTextField.isRequired = true
        checkInTextField.isRequired = true
        checkOutTextField.isRequired = true
        compensationFromTextField.isRequired = true
        compensationToTextField.isRequired = true
        reasonTextField.isRequired = true
    }

    override func setupPicker() {
        super.setupPicker()

        leaveTypePicker.delegate = self
        leaveTypeTextField.isPicker = requestModel.id == nil ? true : false
        leaveTypeTextField.inputView = leaveTypePicker
        leaveTypeTextField.inputAccessoryView = UIToolbar().ToolbarPiker(selector: #selector(onLeaveTypeSelected))
    }

    override func bindData() {
        super.bindData()

        if requestModel.id == nil {
            isBinding = false
            if leaveTypes.count > 0 {
                leaveTypePicker.selectRow(0, inComponent: 0, animated: true)
                onLeaveTypeSelected()
            }
        } else {
            bindDataEdit()
        }
    }

    func bindDataEdit() {

        title = LocalizationHelper.shared.localized("edit_others_request")

        branchTextField.isEnabled = true
        groupTextField.isEnabled = false
        leaveTypeTextField.isEnabled = false

        branchTextField.textColor = UIColor.black
        groupTextField.textColor = UIColor.lightGray
        leaveTypeTextField.textColor = UIColor.lightGray

        branchTextField.text = requestModel.workspace?.name
        groupTextField.text = requestModel.group?.name
        projectNameTextField.text = requestModel.projectName

        if let i = leaveTypes.index(where: {$0.id == requestModel.leaveTypeId}) {
            leaveTypePicker.selectRow(i, inComponent: 0, animated: false)
            onLeaveTypeSelected()
        }

        let leaveType = leaveTypes[leaveTypePicker.selectedRow(inComponent: 0)]
        switch leaveType.trackingTimeType {
        case .both:
            checkInTextField.text = requestModel.checkinTime
            checkOutTextField.text = requestModel.checkoutTime
        case .checkOut:
            trackingTextField.text = requestModel.checkoutTime
        default:
            trackingTextField.text = requestModel.checkinTime
        }

        if leaveType.compensationKind == .require {
            compensationToTextField.text = requestModel.compensationAttributes.compensationTo?.toString(dateFormat: AppConstant.requestDateFormat)
            compensationFromTextField.text = requestModel.compensationAttributes.compensationFrom?.toString(dateFormat: AppConstant.requestDateFormat)
            reasonTextField.text = requestModel.reason
        }

        isBinding = false
    }

    override func onBranchSelected() {
        super.onBranchSelected()
        requestModel.workspaceId = workSpaces[branchPicker.selectedRow(inComponent: 0)].id
    }

    override func onGroupSelected() {
        super.onGroupSelected()
        requestModel.groupId = groups[groupPicker.selectedRow(inComponent: 0)].id
        clearTrackingTimes()
    }

    @objc func onLeaveTypeSelected() {
        self.view.endEditing(true)
        let typeSelected = leaveTypes[leaveTypePicker.selectedRow(inComponent: 0)]
        leaveTypeTextField.text = typeSelected.name
        requestModel.leaveTypeId = typeSelected.id
        clearTrackingTimes()

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
            if let scrollView = scrollView {
                scrollView.contentSize = CGSize(width:scrollView.contentSize.width,
                                                height: compensationView.frame.maxY)
            }
        case .notRequire:
            compensationView.isHidden = true
            if let scrollView = scrollView {
                scrollView.contentSize = CGSize(width: scrollView.contentSize.width,
                                                height: compensationView.frame.minY + 10)
            }
        }
    }

    @IBAction func nextButtonClick(_ sender: Any) {
        if isRequestValid(),
            let confirmVc = getViewController(identifier: "ConfirmCreateRequestLeaveViewController")
                as? ConfirmCreateRequestLeaveViewController {

            self.requestModel.projectName = projectNameTextField.text
            self.requestModel.reason = reasonTextField.text
            confirmVc.requestModel = self.requestModel
            confirmVc.listRequestDelegate = listRequestDelegate
            self.navigationController?.pushViewController(confirmVc, animated: true)
        }
    }

    @objc private func onTrackingDateSelected() {
        self.view.endEditing(true)

        var isValid = false
        var isCheckout = false
        let leaveType = leaveTypes[leaveTypePicker.selectedRow(inComponent: 0)]

        trackingView.isHidden = leaveType.trackingTimeType == .both
        trackingBothView.isHidden = !trackingView.isHidden
        trackingTextField.text = trackingDatePicker.date.toString(dateFormat: AppConstant.requestDateFormat)

        switch leaveType.trackingTimeType {
        case .checkOut:
            if isCheckOutValid(leaveTypeId: leaveType.id) {
                requestModel.checkoutTime = trackingTextField.text
                autoFillCompensationForInLate()
            } else {
                trackingTextField.text = ""
            }
            isCheckout = true
        case .checkIn:
            isValid = true
        case .checkInM:
            isValid = isInLateTimeValid()
        case .checkInA:
            isValid = isInLateAfternoonTimeValid()
        default:
            break
        }

        if !isCheckout {
            if isValid {
                requestModel.checkinTime = trackingTextField.text
                clearCompensationTimes()
                autoFillCompensationForInLate()
            } else {
                trackingTextField.text = ""
                clearCompensationTimes()
            }
        }
    }

    @objc private func onCheckInDateSelected() {
        self.view.endEditing(true)
        self.checkInTextField.text = checkInDatePicker.date.toString(dateFormat: AppConstant.requestDateFormat)
        var isValid = false

        if leaveTypes[leaveTypePicker.selectedRow(inComponent: 0)].compensationKind == CompensationKind.require {
            isValid = isLeaveOutFromValid()
        } else {
            isValid = true
        }

        if isValid {
            requestModel.checkinTime = self.checkInTextField.text
        } else {
            self.checkInTextField.text = ""
        }

        clearCompensationTimes()
    }

    @objc private func onCheckOutDateSelected() {
        self.view.endEditing(true)

        if isCheckInEmpty() {
            return
        }

        self.checkOutTextField.text = checkOutDatePicker.date.toString(dateFormat: AppConstant.requestDateFormat)
        var isValid = false

        if leaveTypes[leaveTypePicker.selectedRow(inComponent: 0)].compensationKind == CompensationKind.require {
            isValid = isLeaveOutToValid()
        } else {
            isValid = isForgotCheckOutTimeValid()
        }

        if isValid {
            requestModel.checkoutTime = self.checkOutTextField.text
            autoFillCompensationForInLate()
        } else {
            clearCompensationTimes()
        }
    }

    @objc private func onConpensationFromDateSelected() {
        self.view.endEditing(true)
        self.compensationFromTextField.text = compensationFromDatePicker.date.toString(dateFormat: AppConstant.requestDateFormat)
        requestModel.compensationAttributes.compensationFrom = compensationFromDatePicker.date

        autoFillCompensationForInLate()
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
        if !isCheckInEmpty() {
            checkOutTextField.inputView = checkOutDatePicker
            checkOutTextField.inputAccessoryView = UIToolbar().ToolbarPiker(selector: #selector(onCheckOutDateSelected))
        }
    }

    @IBAction func selectCompensationFromDate(_ sender: UITextField) {
        compensationFromTextField.inputView = compensationFromDatePicker
        compensationFromTextField.inputAccessoryView = UIToolbar().ToolbarPiker(selector: #selector(onConpensationFromDateSelected))
    }

    @IBAction func selectCompensationToDate(_ sender: UITextField) {
        AlertHelper.showInfo(message: LocalizationHelper.shared.localized("you_just_need_choose_the_compensation_from_time"))
    }
    
    func clearTrackingTimes() {
        if !isBinding {
            trackingTextField.text = ""
            checkInTextField.text = ""
            reasonTextField.text = ""
            requestModel.checkinTime = ""
            requestModel.reason = ""
            clearCompensationTimes()
        }
    }

    func clearCompensationTimes() {
        checkOutTextField.text = ""
        compensationToTextField.text = ""
        compensationFromTextField.text = ""
        requestModel.checkoutTime = ""
        requestModel.compensationAttributes.compensationFrom = nil
        requestModel.compensationAttributes.compensationTo = nil
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

// MARK: validate
extension CreateRequestLeaveViewController {

    func isRequestValid() -> Bool {
        var result = true
        let error = LocalizationHelper.shared.localized("is_empty")
        let leaveType = leaveTypes[leaveTypePicker.selectedRow(inComponent: 0)]
        switch leaveType.trackingTimeType {
        case .both:
            if checkInTextField.isEmpty() {
                checkInTextField.showErrorWithText(errorText: error)
                result = false
            }
            if checkOutTextField.isEmpty() {
                checkOutTextField.showErrorWithText(errorText: error)
                result = false
            }
        case .checkIn,
             .checkInA,
             .checkInM,
             .checkOut:
            if trackingTextField.isEmpty() {
                trackingTextField.showErrorWithText(errorText: error)
                result = false
            }
        }

        if leaveType.compensationKind == .require {
            if compensationFromTextField.isEmpty() {
                compensationFromTextField.showErrorWithText(errorText: error)
                result = false
            }
            if compensationToTextField.isEmpty() {
                compensationToTextField.showErrorWithText(errorText: error)
                result = false
            }
            if reasonTextField.isEmpty() {
                reasonTextField.showErrorWithText(errorText: error)
                result = false
            }
        }

        return result
    }

    func isInLateTimeValid() -> Bool{
        let workspace = workSpaces[branchPicker.selectedRow(inComponent: 0)]
        let leaveType = leaveTypes[leaveTypePicker.selectedRow(inComponent: 0)]
        guard workspace.shifts.count > 0,
            let selectedDate = trackingDatePicker.date.zeroSecond(),
            let timeIn = workspace.shifts[0].getTimeInSpecial(),
            let timeLunch = workspace.shifts[0].timeLunch,
            let maxComeLate = workspace.shifts[0].getMaxComeLateSpecial(maxComeLate: leaveType.maxPerOne),
            let inDate = selectedDate.createDateFromTimeOf(date: timeIn),
            let luchDate = selectedDate.createDateFromTimeOf(date: timeLunch) else {
                return false
        }
        if selectedDate <= inDate {
            AlertHelper.showError(message: LocalizationHelper.shared.localized("this_is_form_request_late_time_in_is_incorrect"))
            return false
        }

        if !(selectedDate < luchDate && selectedDate > inDate) {
            AlertHelper.showError(message: LocalizationHelper.shared.localized("check_in_time_must_be_in_morning_shift"))
            return false
        }

        let duration = selectedDate.timeIntervalSince(inDate)
        if Int(duration) > maxComeLate {
            AlertHelper.showError(message: LocalizationHelper.shared.localized("your_amount_tim_can_not_greater_than_max_allow_time"))
            return false
        }

        return true
    }

    func isInLateAfternoonTimeValid() -> Bool{
        let workspace = workSpaces[branchPicker.selectedRow(inComponent: 0)]
        let leaveType = leaveTypes[leaveTypePicker.selectedRow(inComponent: 0)]
        guard workspace.shifts.count > 0,
            let selectedDate = trackingDatePicker.date.zeroSecond(),
            let timeout = workspace.shifts[0].getTimeOutSpecial(),
            let timeAfternoon = workspace.shifts[0].getTimeAfternoonSpecial(),
            let maxComeLate = workspace.shifts[0].getMaxComeLateSpecial(maxComeLate: leaveType.maxPerOne),
            let inDate = selectedDate.createDateFromTimeOf(date: timeAfternoon),
            let outDate = selectedDate.createDateFromTimeOf(date: timeout) else {
                return false
        }

        if selectedDate <= inDate {
            AlertHelper.showError(message: LocalizationHelper.shared.localized("this_is_form_request_late_time_in_is_incorrect"))
            return false
        }

        if !(selectedDate < outDate && selectedDate > inDate) {
            AlertHelper.showError(message: LocalizationHelper.shared.localized("check_in_time_must_be_in_afternoon_shift"))
            return false
        }

        let duration = selectedDate.timeIntervalSince(inDate)
        if Int(duration) > maxComeLate || Int(duration) * -1 > maxComeLate{
            AlertHelper.showError(message: LocalizationHelper.shared.localized("your_amount_tim_can_not_greater_than_max_allow_time"))
            return false
        }

        return true
    }

    func isLeaveEarlyTimeValid() -> Bool {
        let workspace = workSpaces[branchPicker.selectedRow(inComponent: 0)]
        let leaveType = leaveTypes[leaveTypePicker.selectedRow(inComponent: 0)]
        guard workspace.shifts.count > 0,
            let selectedDate = trackingDatePicker.date.zeroSecond(),
            let timeIn = workspace.shifts[0].getTimeInSpecial(),
            let timeLunch = workspace.shifts[0].timeLunch,
            let maxLevesEarly = workspace.shifts[0].getMaxLeavesEarlySpecial(maxLevesEarly: leaveType.maxPerOne),
            let inDate = selectedDate.createDateFromTimeOf(date: timeIn),
            let luchDate = selectedDate.createDateFromTimeOf(date: timeLunch) else {
                return false
        }

        if selectedDate <= inDate {
            AlertHelper.showError(message: LocalizationHelper.shared.localized("your_time_can_not_be_sooner_than_time_in_of_company"))
            return false
        }

        if !(selectedDate < luchDate && selectedDate > inDate) {
            AlertHelper.showError(message: LocalizationHelper.shared.localized("check_in_time_must_be_in_morning_shift"))
            return false
        }

        let duration = luchDate.timeIntervalSince(selectedDate)
        if Int(duration) > maxLevesEarly {
            AlertHelper.showError(message: LocalizationHelper.shared.localized("your_amount_tim_can_not_greater_than_max_allow_time"))
            return false
        }

        return true
    }

    func isLeaveEarlyAfternoonTimeValid() -> Bool {
        let workspace = workSpaces[branchPicker.selectedRow(inComponent: 0)]
        let leaveType = leaveTypes[leaveTypePicker.selectedRow(inComponent: 0)]
        guard workspace.shifts.count > 0,
            let selectedDate = trackingDatePicker.date.zeroSecond(),
            let timeout = workspace.shifts[0].getTimeOutSpecial(),
            let timeAfternoon = workspace.shifts[0].getTimeAfternoonSpecial(),
            let maxLevesEarly = workspace.shifts[0].getMaxLeavesEarlySpecial(maxLevesEarly: leaveType.maxPerOne),
            let inDate = selectedDate.createDateFromTimeOf(date: timeAfternoon),
            let outDate = selectedDate.createDateFromTimeOf(date: timeout) else {
                return false
        }

        if selectedDate <= inDate {
            AlertHelper.showError(message: LocalizationHelper.shared.localized("your_time_can_not_be_sooner_than_time_in_of_company"))
            return false
        }

        if !(selectedDate < outDate && selectedDate > inDate) {
            AlertHelper.showError(message: LocalizationHelper.shared.localized("check_in_time_must_be_in_afternoon_shift"))
            return false
        }

        let duration = outDate.timeIntervalSince(selectedDate)
        if Int(duration) > maxLevesEarly {
            AlertHelper.showError(message: LocalizationHelper.shared.localized("your_amount_tim_can_not_greater_than_max_allow_time"))
            return false
        }

        return true
    }

    func isCheckOutTimeValid() -> Bool {
        let workspace = workSpaces[branchPicker.selectedRow(inComponent: 0)]
        let leaveType = leaveTypes[leaveTypePicker.selectedRow(inComponent: 0)]
        guard workspace.shifts.count > 0,
            let selectedDate = trackingDatePicker.date.zeroSecond(),
            let timeIn = workspace.shifts[0].getTimeInSpecial(),
            let timeLunch = workspace.shifts[0].timeLunch,
            let maxComeLate = workspace.shifts[0].getMaxComeLateSpecial(maxComeLate: leaveType.maxPerOne),
            let inDate = selectedDate.createDateFromTimeOf(date: timeIn),
            let luchDate = selectedDate.createDateFromTimeOf(date: timeLunch) else {
                return false
        }

        if selectedDate <= inDate {
            AlertHelper.showError(message: LocalizationHelper.shared.localized("this_is_form_request_late_time_in_is_incorrect"))
            return false
        }

        if !(selectedDate < luchDate && selectedDate > inDate) {
            AlertHelper.showError(message: LocalizationHelper.shared.localized("check_in_time_must_be_in_morning_shift"))
            return false
        }

        let duration = inDate.timeIntervalSince(selectedDate)
        if Int(duration) > maxComeLate || Int(duration) * -1 > maxComeLate{
            AlertHelper.showError(message: LocalizationHelper.shared.localized("your_amount_tim_can_not_greater_than_max_allow_time"))
            return false
        }
        return true
    }

    func isLeaveOutFromValid() -> Bool {
        let workspace = workSpaces[branchPicker.selectedRow(inComponent: 0)]
        guard workspace.shifts.count > 0,
            let selectedDate = checkInDatePicker.date.zeroSecond(),
            let timeIn = workspace.shifts[0].getTimeInSpecial(),
            let timeLunch = workspace.shifts[0].timeLunch,
            let timeAfternoon = workspace.shifts[0].getTimeAfternoonSpecial(),
            let timeOut = workspace.shifts[0].getTimeOutSpecial(),
            let inDate = selectedDate.createDateFromTimeOf(date: timeIn),
            let afternoonDate = selectedDate.createDateFromTimeOf(date: timeAfternoon),
            let lunchDate = selectedDate.createDateFromTimeOf(date: timeLunch),
            let outDate = selectedDate.createDateFromTimeOf(date: timeOut) else {
                return false
        }

        if selectedDate > lunchDate && selectedDate < afternoonDate {
            AlertHelper.showError(message: LocalizationHelper.shared.localized("your_time_can_not_in_lunch_break_time_of_company"))
            return false
        }

        if selectedDate < inDate {
            AlertHelper.showError(message: LocalizationHelper.shared.localized("your_time_can_not_be_sooner_than_time_in_of_company"))
            return false
        }

        if selectedDate >= outDate {
            AlertHelper.showError(message: LocalizationHelper.shared.localized("your_time_can_not_be_later_than_time_out_company"))
            return false
        }

        return true
    }

    func isCheckInEmpty () -> Bool {
        if checkInTextField.isEmpty() {
            AlertHelper.showError(message: LocalizationHelper.shared.localized("you_have_to_choose_the_check_in_time_first"))
            return true
        }
        return false
    }

    func isLeaveOutToValid() -> Bool {
        if isCheckInEmpty() {
            return false
        }

        let workspace = workSpaces[branchPicker.selectedRow(inComponent: 0)]
        let leaveType = leaveTypes[leaveTypePicker.selectedRow(inComponent: 0)]
        guard workspace.shifts.count > 0,
            let checkInDate = checkInDatePicker.date.zeroSecond(),
            let selectedDate = checkOutDatePicker.date.zeroSecond(),
            let timeIn = workspace.shifts[0].getTimeInSpecial(),
            let timeLunch = workspace.shifts[0].timeLunch,
            let timeAfternoon = workspace.shifts[0].getTimeAfternoonSpecial(),
            let timeOut = workspace.shifts[0].getTimeOutSpecial(),
            let inDate = selectedDate.createDateFromTimeOf(date: timeIn),
            let afternoonDate = selectedDate.createDateFromTimeOf(date: timeAfternoon),
            let lunchDate = selectedDate.createDateFromTimeOf(date: timeLunch),
            let outDate = selectedDate.createDateFromTimeOf(date: timeOut),
            let maxLevesEarly = workspace.shifts[0].getMaxLeavesEarlySpecial(maxLevesEarly: leaveType.maxPerOne) else {
                return false
        }

        if selectedDate > lunchDate && selectedDate < afternoonDate {
            AlertHelper.showError(message: LocalizationHelper.shared.localized("your_time_can_not_in_lunch_break_time_of_company"))
            return false
        }

        if selectedDate <= checkInDate {
            AlertHelper.showError(message: LocalizationHelper.shared.localized("request_time_to_can_not_greater_than_request_time_from"))
            return false
        }

        if selectedDate < inDate {
            AlertHelper.showError(message: LocalizationHelper.shared.localized("your_time_can_not_be_sooner_than_time_in_of_company"))
            return false
        }

        if selectedDate > outDate {
            AlertHelper.showError(message: LocalizationHelper.shared.localized("your_time_can_not_be_later_than_time_out_company"))
            return false
        }

        var lunchBreakTime = 0
        if checkInDate < lunchDate && selectedDate > afternoonDate {
            lunchBreakTime = Int(afternoonDate.timeIntervalSince(lunchDate))
        }

        let duration = selectedDate.timeIntervalSince(checkInDate)
        if Int(duration) - lunchBreakTime > maxLevesEarly {
            AlertHelper.showError(message: LocalizationHelper.shared.localized("your_amount_tim_can_not_greater_than_max_allow_time"))
            return false
        }

        return true
    }

    func isForgotCheckOutTimeValid() -> Bool {
        if isCheckInEmpty() {
            return false
        }

        if let checkOut = checkOutDatePicker.date.zeroSecond(),
            let checkIn = checkInDatePicker.date.zeroSecond(),
            checkOut <= checkIn {
            AlertHelper.showError(message: LocalizationHelper.shared.localized("request_time_to_can_not_greater_than_request_time_from"))
            return false
        }

        return true
    }

    func isCheckOutValid(leaveTypeId: Int?) -> Bool {
        if let id = leaveTypeId {
            switch id {
            case TrackingCheckOutTypeId.leaveEarlyM.rawValue,
                 TrackingCheckOutTypeId.leaveEarlyWomanM.rawValue:
                return isLeaveEarlyTimeValid()
            case TrackingCheckOutTypeId.leaveEarlyA.rawValue,
                 TrackingCheckOutTypeId.leaveEarlyWomanA.rawValue:
                return isLeaveEarlyAfternoonTimeValid()
            default:
                return true
            }
        }
        return false
    }
}

// Mark: Compensation
extension CreateRequestLeaveViewController {
    func autoFillCompensationForInLate() {
        let leaveType = leaveTypes[leaveTypePicker.selectedRow(inComponent: 0)]
        if leaveType.compensationKind == .notRequire {
            return
        }

        let workspace = workSpaces[branchPicker.selectedRow(inComponent: 0)]

        guard workspace.shifts.count > 0,
            let trackingDate = trackingDatePicker.date.zeroSecond(),
            let checkOutDate = checkOutDatePicker.date.zeroSecond(),
            let checkInDate = checkInDatePicker.date.zeroSecond(),
            let timeIn = workspace.shifts[0].getTimeInSpecial(),
            let timeLunch = workspace.shifts[0].timeLunch,
            let timeAfternoon = workspace.shifts[0].getTimeAfternoonSpecial(),
            let timeOut = workspace.shifts[0].getTimeOutSpecial(),
            let compensationDateStart = Date(dateString: leaveType.trackingTimeType == .checkOut ?
                requestModel.checkoutTime : requestModel.checkinTime)?.createDateFromTimeOf(date: timeOut) else {
                return
        }

        if compensationFromTextField.isEmpty() {
            compensationFromDatePicker.date = compensationDateStart
            compensationFromTextField.text = compensationDateStart.toString(dateFormat: AppConstant.requestDateFormat)
            requestModel.compensationAttributes.compensationFrom = compensationDateStart
        }

        var inDate = Date()
        var afternoonDate = Date()
        var lunchDate = Date()
        var outDate = Date()

        //compensation duration
        var compensationDuration = 0.0
        switch leaveType.trackingTimeType {
        case .checkOut:
            if let date = trackingDate.createDateFromTimeOf(date: timeLunch) {
                lunchDate = date
            }
            if let date = trackingDate.createDateFromTimeOf(date: timeOut) {
                outDate = date
            }
            if leaveType.id == TrackingCheckOutTypeId.leaveEarlyM.rawValue {
                compensationDuration = lunchDate.timeIntervalSince(trackingDate)
            } else if leaveType.id == TrackingCheckOutTypeId.leaveEarlyA.rawValue {
                compensationDuration = outDate.timeIntervalSince(trackingDate)
            }
        case .checkInM:
            if let date = trackingDate.createDateFromTimeOf(date: timeIn) {
                inDate = date
            }
            compensationDuration = trackingDate.timeIntervalSince(inDate)
        case .checkInA:
            if let date = trackingDate.createDateFromTimeOf(date: timeAfternoon) {
                afternoonDate = date
            }
            if let date = compensationDateStart.createDateFromTimeOf(date: timeOut) {
                outDate = date
            }
            compensationDuration = trackingDate.timeIntervalSince(afternoonDate)
        case .both:
            compensationDuration = checkOutDate.timeIntervalSince(checkInDate)
        default:
            break
        }

        var compensationEndDate: Date?
        if let blockMinutes = leaveType.blockMinutes, blockMinutes > 0 {
            let blockSeconds = blockMinutes * 60
            let surplus = Int(compensationDuration) % blockSeconds
            var multiple = Int(compensationDuration) / blockSeconds
            if surplus > 0 {
                multiple += 1
            }
            compensationEndDate = Calendar.current.date(byAdding: .minute, value: multiple*blockMinutes, to: compensationFromDatePicker.date)

        } else {
            compensationEndDate = Calendar.current.date(byAdding: .second, value: Int(compensationDuration), to: compensationFromDatePicker.date)
        }

        if currentUser?.special == .baby, leaveType.trackingTimeType != .both,
            let date = compensationEndDate,
            let correctDate = Calendar.current.date(byAdding: .minute, value: -AppConstant.babySpecialTime, to: date),
            correctDate > compensationFromDatePicker.date {
                compensationEndDate = correctDate
        }

        compensationToTextField.text = compensationEndDate?.toString(dateFormat: AppConstant.requestDateFormat)
        requestModel.compensationAttributes.compensationTo = compensationEndDate
    }
}
