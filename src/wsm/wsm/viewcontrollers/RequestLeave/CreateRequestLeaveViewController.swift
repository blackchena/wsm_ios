//
//  CreateRequestOtViewController.swift
//  wsm
//
//  Created by framgia on 9/28/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import UIKit
import InAppLocalize

class CreateRequestLeaveViewController: RequestBaseViewController {
    fileprivate let requestModel = RequestOtApiInputModel()

    override func setBranchText() {
        super.setBranchText()
        requestModel.workspaceId = workSpaces[branchPicker.selectedRow(inComponent: 0)].id
    }

    override func setGroupText() {
        super.setGroupText()
        requestModel.groupId = groups[groupPicker.selectedRow(inComponent: 0)].id
    }
}
