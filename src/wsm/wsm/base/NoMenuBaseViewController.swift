//
//  File.swift
//  wsm
//
//  Created by framgia on 9/25/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import InAppLocalize

class NoMenuBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()

        if let title = self.title {
            self.title = LocalizationHelper.shared.localized(title)
        }
    }
}
