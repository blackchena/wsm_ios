//
//  EditProfileViewController.swift
//  wsm
//
//  Created by framgia on 10/17/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import InAppLocalize

class ChangePasswordViewController: NoMenuBaseViewController {

    @IBOutlet weak var currentPasswordTextField: WsmTextField!
    @IBOutlet weak var newPasswordTextField: WsmTextField!
    @IBOutlet weak var confirmPasswordTextField: WsmTextField!

    @IBAction func submitButtonClick(_ sender: Any) {
        if isValid() {
            changePassword()
        }
    }

    func changePassword() {
        let changePasswordModel = ChangePasswordApiInputModel()
        changePasswordModel.currentPassword = currentPasswordTextField.text
        changePasswordModel.newPassword = newPasswordTextField.text
        changePasswordModel.confirmPassword = confirmPasswordTextField.text

        AlertHelper.showLoading()
        UserProvider.changePassword(changePasswordModel: changePasswordModel)
            .then { apiOutput -> Void in
                AlertHelper.showInfo(message: apiOutput.message, makesureLoadingHidden: true, handler: { (alert) in
                    self.navigationController?.popViewController(animated: true)
                })
            }.catch { error in
                AlertHelper.showError(error: error)
            }.always {
                AlertHelper.hideLoading()
        }
    }
}

extension ChangePasswordViewController {
    func isValid() -> Bool {

        var result = true

        let emptyError = LocalizationHelper.shared.localized("is_empty")
        if currentPasswordTextField.isEmpty() {
            currentPasswordTextField.showErrorWithText(errorText: emptyError)
            result = false
        }
        if newPasswordTextField.isEmpty() {
            newPasswordTextField.showErrorWithText(errorText: emptyError)
            result = false
        } else if newPasswordTextField.text!.characters.count < 6 {
            newPasswordTextField.showErrorWithText(errorText: LocalizationHelper.shared.localized("least_6_characters"))
            result = false
        }

        if result && confirmPasswordTextField.text != newPasswordTextField.text {
            confirmPasswordTextField.showErrorWithText(errorText: LocalizationHelper.shared.localized("confirm_password_does_not_match"))
            result = false
        }

        return result
    }
}
