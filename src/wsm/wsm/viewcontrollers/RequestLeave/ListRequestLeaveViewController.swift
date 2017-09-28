//
//  ListRequestLeaveViewController.swift
//  wsm
//
//  Created by framgia on 9/28/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import Floaty

class ListReuqestLeaveViewController: BaseViewController, FloatyDelegate {
    private let floaty = Floaty()

    override func viewDidLoad() {
        super.viewDidLoad()

        createRequestButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func createRequestButton() {
        floaty.paddingX = floaty.paddingY
        floaty.fabDelegate = self
        floaty.buttonColor = UIColor.appBarTintColor
        floaty.buttonImage = UIImage(named: "ic_add")
        self.view.addSubview(floaty)
    }

    func emptyFloatySelected(_ floaty: Floaty) {
        let createOtVc = UIViewController.getStoryboardController(identifier: "CreateRequestLeaveViewController")
        self.navigationController?.pushViewController(createOtVc, animated: true)
    }
}
