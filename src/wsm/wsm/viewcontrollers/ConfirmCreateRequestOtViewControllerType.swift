//
//  ConfirmCreateRequestOtViewControllerType.swift
//  wsm
//
//  Created by framgia on 9/27/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import UIKit
import PromiseKit
import ObjectMapper

protocol ConfirmCreateRequestOtViewControllerType {
    func didSubmitRequestSuccess()
}

extension ConfirmCreateRequestOtViewControllerType where Self: UIViewController {
    func submitRequestOt(requestModel: RequestOtApiInputModel) {
        AlertHelper.showLoading()
        RequestOtProvider.submitRequestOt(requestModel: requestModel)
            .then { apiOutput -> Void in
                RequestOtProvider.listRequests.append(apiOutput.requestModel!)
                self.didSubmitRequestSuccess()
            }.catch { error in
                AlertHelper.showError(error: error)
            }.always {
                AlertHelper.hideLoading()
        }
    }
}
