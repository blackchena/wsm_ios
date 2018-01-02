//
//  ManagerRequestFilterView.swift
//  wsm
//
//  Created by Mac Pro on 12/27/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import InAppLocalize

class ManagerRequestFilterView: UIView {
    
    @IBOutlet weak var timeFromTextField: LocalizableTextField!
    @IBOutlet weak var timeToTextField: LocalizableTextField!
    @IBOutlet weak var memberNameTextFiled: LocalizableTextField!
    @IBOutlet weak var statusTextField: LocalizableTextField!
    
    let managerRequestFilterViewKey = "ManagerRequestFilterView"
    let numberOfComponents = 1
    let statusPicker = UIPickerView()
    let timeFromPicker = UIDatePicker()
    let timeToPicker = UIDatePicker()
    let listStatus: [RequestStatus] = [.pending, .approve, .discard, .forward, .cancel]
    var years = [Int]()
    let startYear = 2000
    
    var filterAction: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        pickerSetup()
        textFieldSetup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
     }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }

    private func setupView() {
        if let view = Bundle.main.loadNibNamed(managerRequestFilterViewKey, owner: self, options: nil)?.first as? UIView {
            addSubview(view)
        }
    }
    
    func  textFieldSetup() {
        memberNameTextFiled.delegate = self
        statusTextField.inputView = statusPicker
        statusTextField.text = listStatus.first?.localizedString()
        statusTextField.inputAccessoryView = UIToolbar().ToolbarPiker(selector: #selector(onStatusSelected))
        timeFromTextField.text = getTimeFromDatePiker(picker: timeFromPicker)
        timeToTextField.text = getTimeFromDatePiker(picker: timeToPicker)
        timeFromTextField.inputView = timeFromPicker
        timeFromTextField.inputAccessoryView = UIToolbar().ToolbarPiker(selector: #selector(onTimeFromSelected))
        timeToTextField.inputView = timeToPicker
        timeToTextField.inputAccessoryView = UIToolbar().ToolbarPiker(selector: #selector(onTimeToSelected))
    }
    
    func pickerSetup() {
        statusPicker.delegate = self
        let currentYear = Date().getComponent(.year)
        if years.count == 0 {
            for year in startYear...currentYear + 1 {
                years.append(year)
            }
        }
        timeToPicker.datePickerMode = .date
        timeFromPicker.datePickerMode = .date
        if let startDate = UserDefaults.standard.object(forKey: DateWorking.startDate.rawValue) as? Date,
            let endDate = UserDefaults.standard.object(forKey: DateWorking.endDate.rawValue) as? Date {
            timeFromPicker.date = startDate
            timeToPicker.date = endDate
        }
        timeToPicker.maximumDate = Calendar.current.date(byAdding: .year, value: 1, to: Date())
        timeFromPicker.maximumDate = Calendar.current.date(byAdding: .year, value: 1, to: Date())
    }
    
    @objc func onStatusSelected() {
        endEditing(true)
        let selectedRow = statusPicker.selectedRow(inComponent: 0)
        statusTextField.text = listStatus[selectedRow].localizedString()
        filterAction?()
    }
    
    @objc func onTimeFromSelected() {
        endEditing(true)
        timeFromTextField.text = getTimeFromDatePiker(picker: timeFromPicker)
        timeToTextField.text = nil
    }
    
    @objc func onTimeToSelected() {
        endEditing(true)
        timeToTextField.text = getTimeFromDatePiker(picker: timeToPicker)
        filterAction?()
    }
    
    @IBAction func clearButtonClick(_ sender: Any) {
        timeFromTextField.text = nil
        timeToTextField.text = nil
        statusTextField.text = nil
        memberNameTextFiled.text = nil
        filterAction?()
    }
    
    func getTimeFromDatePiker(picker: UIDatePicker) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = AppConstant.onlyDateFormat
        return dateFormatter.string(from: picker.date)
    }
    
    func getStatusSelected() -> Int? {
        if let status = statusTextField.text, !status.isEmpty {
            return statusPicker.selectedRow(inComponent: 0)
        }
        return 0
    }
}

extension ManagerRequestFilterView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return numberOfComponents
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == timeFromPicker || pickerView == timeToPicker {
            return years.count
        }
        return listStatus.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == timeFromPicker || pickerView == timeToPicker {
            return "\(years[row])"
        }
        return listStatus[row].localizedString() 
    }
}

extension ManagerRequestFilterView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        filterAction?()
        return true
    }
}

