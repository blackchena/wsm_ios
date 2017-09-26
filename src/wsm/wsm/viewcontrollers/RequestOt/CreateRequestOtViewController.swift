//
//  CreateRequestOtViewController.swift
//  wsm
//
//  Created by framgia on 9/25/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import UIKit

class CreateRequestOtViewController: NoMenuBaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var fromText: WsmTextField!
    @IBOutlet weak var toText: WsmTextField!
    @IBOutlet weak var empNameText: WsmTextField!
    @IBOutlet weak var empCodeText: WsmTextField!
    @IBOutlet weak var projectText: WsmTextField!
    @IBOutlet weak var branchText: WsmTextField!
    @IBOutlet weak var groupText: WsmTextField!
    @IBOutlet weak var reasonText: WsmTextField!

    private let fromDatePicker = UIDatePicker()
    private let toDatePicker = UIDatePicker()

    let requestModel = RequestOtModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        registerKeyboardNotifications()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @IBAction func selectFrom(_ sender: UITextField) {
        sender.inputView = fromDatePicker
        sender.inputAccessoryView = UIToolbar().ToolbarPiker(selector: #selector(setFromText))
    }

    @IBAction func selectTo(_ sender: UITextField) {
        sender.inputView = toDatePicker
        sender.inputAccessoryView = UIToolbar().ToolbarPiker(selector: #selector(setToText))
    }

    @objc private func setFromText() {
        self.fromText.text = fromDatePicker.date.toString(dateFormat: Date.dateTimeFormat)
        requestModel.fromTime = self.fromText.text
        self.view.endEditing(true)
    }

    @objc private func setToText() {
        self.toText.text = toDatePicker.date.toString(dateFormat: Date.dateTimeFormat)
        requestModel.endTime = self.toText.text
        self.view.endEditing(true)
    }

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
    @IBAction func nextBtnClick(_ sender: Any) {
        if let confirmOtVc = UIViewController.getStoryboardController(identifier: "ConfirmCreateRequestOtViewController")
            as? ConfirmCreateRequestOtViewController {
            confirmOtVc.requestModel = self.requestModel
            self.navigationController?.pushViewController(confirmOtVc, animated: true)
        }
    }
}
