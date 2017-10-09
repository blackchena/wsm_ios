//
//  ConfirmCreateRequestLeaveViewControllerType.swift
//  wsm
//
//  Created by framgia on 10/2/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit
import ObjectMapper

protocol ConfirmCreateRequestLeaveViewControllerType {
    func didSubmitRequestSuccess()
}

extension ConfirmCreateRequestLeaveViewControllerType where Self: UIViewController {
    func submitRequestLeave(requestModel: RequestLeaveApiInputModel) {
        AlertHelper.showLoading()
        RequestLeaveProvider.submitRequestLeave(requestModel: requestModel)
            .then { apiOutput -> Void in
                RequestLeaveProvider.shared.listRequests.append(apiOutput.requestModel!)
                self.didSubmitRequestSuccess()
            }.catch { error in
                AlertHelper.showError(error: error)
            }.always {
                AlertHelper.hideLoading()
        }
    }
}
