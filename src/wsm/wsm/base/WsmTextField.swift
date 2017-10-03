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
import ACFloatingTextfield_Swift

class WsmTextField: ACFloatingTextfield {
    private var localizeKey: String?

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
}
