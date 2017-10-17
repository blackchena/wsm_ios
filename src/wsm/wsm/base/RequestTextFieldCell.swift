//
//  RequestTextFieldCell.swift
//  wsm
//
//  Created by Lê Thanh Quang on 10/5/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import Validator
import InAppLocalize

@IBDesignable class RequestTextFieldCell: UITableViewCell {

    @IBOutlet weak var textField: WsmTextField!

    public var bindingContext: Any?

    public var mustValidateWhenLoaded = false

    public var onTextChanged: ((RequestTextFieldCell, Any?, String?) -> Void)?
    public var configCell: ((RequestTextFieldCell, Any?) -> Void)?

    static var cellHeight: CGFloat {
        return 50.0
    }

    @IBInspectable var placeHolder: String? {
        get {
            return textField.placeholder
        }
        set(str) {
            textField.placeholder = str
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        textField.validationHandler = { result in
            switch result {
            case .invalid(let errs):
                let mess = errs.first?.localizedDescription
                self.textField.showErrorWithText(errorText: ((mess?.isEmpty ?? true) ? LocalizationHelper.shared.localized("error") : mess!))
            default:
                break;
            }
        }

        configCell?(self, bindingContext)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.textField.inputView = nil
        self.textField.inputAccessoryView = nil
        self.textField.text = nil
        self.textField.placeholder = nil
        self.textField.removeErrorPlaceHolder()
    }

    public func validateDataOfCell() {
        if mustValidateWhenLoaded {
            self.textField.validate()
        } else {
            self.textField.hideErrorPlaceHolder()
        }
    }

    public func setValidatorRules(rules: ValidationRuleSet<String>?) {
        if let rules = rules {
            textField.validationRules = rules            
            textField.validateOnEditingEnd(enabled: true)
        }
    }

    public func getValidatorRules() -> ValidationRuleSet<String>? {
        return textField.validationRules
    }

    @IBAction func textFieldDidEndEditing(_ sender: Any) {
        self.onTextChanged?(self, bindingContext, self.textField.text)
    }


}
