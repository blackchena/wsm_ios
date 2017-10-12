//
//  RequestFilterView.swift
//  wsm
//
//  Created by framgia on 10/9/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import InAppLocalize

class RequestFilterView: UIView {

    @IBOutlet weak var statusTextField: LocalizableTextField!
    @IBOutlet weak var monthTextField: LocalizableTextField!
    @IBOutlet weak var clearButton: UIButton!

    let statusPicker = UIPickerView()
    let monthPicker = MonthYearPickerView()
    let listStatus = [RequestStatus.pending,
                      RequestStatus.approve,
                      RequestStatus.discard,
                      RequestStatus.forward,
                      RequestStatus.cancel]

    var filterAction: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()

        clearButton.layer.cornerRadius = 5
        statusTextField.tintColor = .clear
        monthTextField.tintColor = .clear

        statusPicker.delegate = self
        statusTextField.inputView = statusPicker
        statusTextField.inputAccessoryView = UIToolbar().ToolbarPiker(selector: #selector(onStatusSelected))

        monthTextField.inputView = monthPicker
        monthTextField.inputAccessoryView = UIToolbar().ToolbarPiker(selector: #selector(onMonthSelected))
        monthTextField.text = monthPicker.getMonthYearSelectedString()
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
        if let view = Bundle.main.loadNibNamed("RequestFilterView", owner: self, options: nil)?.first as? UIView {
            view.frame = bounds
            // Auto-layout stuff.
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            // Show the view.
            addSubview(view)
        }
    }

    @objc func onStatusSelected() {
        endEditing(true)
        let selectedRow = statusPicker.selectedRow(inComponent: 0)
        statusTextField.text = listStatus[selectedRow].rawValue
        self.filterAction?()
    }

    @objc func onMonthSelected() {
        endEditing(true)
        monthTextField.text = monthPicker.getMonthYearSelectedString()
        self.filterAction?()
    }

    func getMonthYearSelectedString() -> String? {
        return monthTextField.text
    }

    func getStatusSelected() -> Int? {
        if let count = statusTextField.text?.characters.count, count > 0 {
            return statusPicker.selectedRow(inComponent: 0)
        } else {
            return nil
        }
    }

    func resetConditions() {
        monthPicker.selectCurrentMonth()
        monthTextField.text = monthPicker.getMonthYearSelectedString()
        statusTextField.text = ""
    }

    @IBAction func clearButtonClick(_ sender: Any) {
        monthTextField.text = ""
        statusTextField.text = ""
        self.filterAction?()
    }
}

extension RequestFilterView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listStatus.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return listStatus[row].localizedString()
    }
}
