//
//  RequestBasicInfoHeaderView.swift
//  wsm
//
//  Created by Lê Thanh Quang on 10/5/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit

@IBDesignable class RequestBasicInfoHeaderView: UIView {

    //    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var empNameTextField: WsmTextField!
    @IBOutlet weak var empCodeTextField: WsmTextField!
    @IBOutlet weak var positionNameTextField: WsmTextField!
    @IBOutlet weak var branchTextField: WsmTextField!
    @IBOutlet weak var groupTextField: WsmTextField!
    @IBOutlet weak var projectNameTextField: WsmTextField!
    //    @IBOutlet weak var reasonTextField: WsmTextField!

    fileprivate let branchPicker = UIPickerView()
    fileprivate let groupPicker = UIPickerView()

    fileprivate let currentUser = UserServices.getLocalUserProfile()
    fileprivate var workSpaces = [UserWorkSpace]()
    fileprivate var groups = [UserGroup]()

    public var selectedWorkSpace: UserWorkSpace?
    public var selectedGroup: UserGroup?
    public var isEditingRequest: Bool = false {
        didSet {
            groupTextField?.isEnabled = !self.isEditingRequest
            groupTextField?.textColor = self.isEditingRequest ? UIColor.lightGray : UIColor.black
        }
    }

    public var empName: String? {
        get {
            return empNameTextField.text
        }
        set {
            empNameTextField.text = newValue
        }
    }

    public var empCode: String? {
        get {
            return empCodeTextField.text
        }
        set {
            empCodeTextField.text = newValue
        }
    }

    public var positionName: String? {
        get {
            return positionNameTextField.text
        }
        set {
            positionNameTextField.text = newValue
        }
    }

    public var projectName: String? {
        get {
            return projectNameTextField.text
        }
        set {
            projectNameTextField.text = newValue
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // Performs the initial setup.
    private func setupView() {
        if let view = Bundle.main.loadNibNamed("RequestBasicInfoHeaderView", owner: self, options: nil)?.first as? UIView {

            view.frame = bounds
            // Auto-layout stuff.
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            // Show the view.
            addSubview(view)

            initData()
        }
    }

    private func initData() {
        workSpaces = currentUser?.workSpaces ?? [UserWorkSpace]()
        groups = currentUser?.groups ?? [UserGroup]()
        self.isUserInteractionEnabled = true
        bindData()
        setupPicker()
    }

    func setupPicker() {
        branchPicker.delegate = self
        groupPicker.delegate = self

        branchTextField.isPicker = true
        branchTextField.inputView = branchPicker
        branchTextField.inputAccessoryView = UIToolbar().ToolbarPiker(selector: #selector(onBranchSelected))

        groupTextField.isPicker = true
        groupTextField.inputView = groupPicker
        groupTextField.inputAccessoryView = UIToolbar().ToolbarPiker(selector: #selector(onGroupSelected))

        groupTextField.isEnabled = !self.isEditingRequest
        groupTextField.textColor = self.isEditingRequest ? UIColor.lightGray : UIColor.black
    }

    func bindData() {
        empNameTextField.text = currentUser?.name
        empCodeTextField.text = currentUser?.employeeCode

        empNameTextField.isEnabled = false
        empCodeTextField.isEnabled = false

        empNameTextField.textColor = UIColor.lightGray
        empCodeTextField.textColor = UIColor.lightGray

        positionNameTextField.isEnabled = true

        if workSpaces.count > 0 {
            if let selectedWorkSpaceId = selectedWorkSpace?.id,
                let i = workSpaces.index(where: {$0.id == selectedWorkSpaceId}) {
                branchPicker.selectRow(i, inComponent: 0, animated: true)
            } else {
                if let defaultBranchId = UserServices.getLocalUserSetting()?.workSpaceDefault,
                    let i = workSpaces.index(where: {$0.id == defaultBranchId}) {
                    branchPicker.selectRow(i, inComponent: 0, animated: true)
                } else {
                    branchPicker.selectRow(0, inComponent: 0, animated: true)
                }
            }
            onBranchSelected()
        }

        if groups.count > 0 {
            if let selectedGroupId = selectedGroup?.id,
                let i = groups.index(where: {$0.id == selectedGroupId}) {
                groupPicker.selectRow(i, inComponent: 0, animated: true)
            } else {
                if let defaultGroupId = UserServices.getLocalUserSetting()?.groupDefault,
                    let i = groups.index(where: {$0.id == defaultGroupId}) {
                    groupPicker.selectRow(i, inComponent: 0, animated: true)
                } else {
                    groupPicker.selectRow(0, inComponent: 0, animated: true)
                }
            }
            onGroupSelected()
        }
    }

    @objc func onBranchSelected() {
        self.endEditing(true)
        selectedWorkSpace = workSpaces[branchPicker.selectedRow(inComponent: 0)]
        branchTextField.text = selectedWorkSpace?.name
    }

    @objc func onGroupSelected() {
        self.endEditing(true)
        selectedGroup = groups[groupPicker.selectedRow(inComponent: 0)]
        groupTextField.text = selectedGroup?.fullName
    }
}

extension RequestBasicInfoHeaderView: UIPickerViewDelegate, UIPickerViewDataSource {
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
