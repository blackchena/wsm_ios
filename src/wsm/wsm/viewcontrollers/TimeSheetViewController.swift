//
//  TimeSheetViewController.swift
//  wsm
//
//  Created by framgia on 9/20/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import Floaty
import InAppLocalize

class TimeSheetViewController: BaseViewController, FloatyDelegate {

    private let floaty = Floaty()

    override func viewDidLoad() {
        super.viewDidLoad()

        createRequestButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func createRequestButton() {
        floaty.addButton(title: LocalizationHelper.shared.localized("create_others_request"), hexColor: "#35F128")
        floaty.addButton(title: LocalizationHelper.shared.localized("create_request_leave"), hexColor: "#FA003F")
        floaty.addButton(title: LocalizationHelper.shared.localized("create_request_ot"), hexColor: "#1564C0")

        floaty.paddingX = floaty.paddingY
        floaty.fabDelegate = self
        floaty.buttonColor = UIColor.init(hexString: "#DB4336")
        floaty.buttonImage = UIImage(named: "ic_add")

        self.view.addSubview(floaty)
    }
}
