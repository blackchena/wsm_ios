//
//  WsmTextField.swift
//  wsm
//
//  Created by framgia on 9/25/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import InAppLocalize
import TextFieldEffects
import Validator
import InAppLocalize

class WsmTextField: ACFloatingTextfield {   
    private var localizeKey: String?
    private let padding = UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 10);

    var isRequired: Bool = false {
        willSet {
            if newValue {
                rightViewWith(text: "✮", color: UIColor.red)
            } else {
                self.rightView = nil
                self.rightViewMode = .never
            }
        }
    }

    var isPicker: Bool = false {
        willSet {
            if newValue {
                tintColor = .clear
                rightViewWith(text: "▼", color: .black)
            } else {
                self.rightView = nil
                self.rightViewMode = .never
            }
        }
    }

    override open var placeholder: String? {
        set (newValue) {
            self.localizeKey = newValue
            if let key = newValue {
                let localizedString = LocalizationHelper.shared.localized(key)
                super.placeholder = localizedString
            } else {
                super.placeholder = newValue
            }
        }
        get {
            return super.placeholder
        }
    }

    override open func awakeFromNib() {
        super.awakeFromNib()
        self.localizeKey = self.placeholder
        self.placeholder = self.localizeKey
    }

    func rightViewWith(text: String, color: UIColor) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        label.text = text
        label.textAlignment = .right
        label.textColor = color
        label.font = UIFont.boldSystemFont(ofSize: 10)
        rightView = label
        rightViewMode = .always
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }

    public func setupPicker(picker: UIPickerView, selector: Selector, target: Any? = nil, currentValue: String = "") {
        self.isPicker = true
        self.inputView = picker
        self.inputAccessoryView = UIToolbar().ToolbarPiker(selector: selector, target: target)
        self.text = currentValue
    }

    public func setupDatePicker(picker: UIDatePicker, selector: Selector, target: Any? = nil, currentValue: String = "") {
        self.isPicker = true
        self.inputView = picker
        self.inputAccessoryView = UIToolbar().ToolbarPiker(selector: selector, target: target)
        self.text = currentValue
    }
}

extension WsmTextField {
    public func validate<R>(rule r: R, withShowError: Bool) -> Bool where R : ValidationRule, R.InputType == UITextField.InputType {
        let result = self.validate(rule: r)
        switch result {
        case .invalid(let errors):
            if withShowError,
                let firstError = errors.first {
                self.showErrorWithText(errorText: firstError.localizedDescription)
            }
            return false
        default:
            break
        }
        
        return true
    }
}
