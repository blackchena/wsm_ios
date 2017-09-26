//
//  WsmAccessTokenPlugin.swift
//  wsm
//
//  Created by framgia on 9/19/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import Moya
import SwiftyUserDefaults

public struct WsmAccessTokenPlugin: PluginType {

    /// The access token to be applied in the header.
    /**
     Initialize a new `WsmAccessTokenPlugin`.

     - parameters:
     - token: The token to be applied in the pattern `Authorization: Bearer <token>`
     */
    public init() {
    }

    /**
     Prepare a request by adding an authorization header if necessary.

     - parameters:
     - request: The request to modify.
     - target: The target of the request.
     - returns: The modified `URLRequest`.
     */
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        if let authorizable = target as? AccessTokenAuthorizable, authorizable.shouldAuthorize == false {
            return request
        }

        let languageSupport = ["vi", "en", "ja"]
        var deviceLanguage = Locale.preferredLanguages[0]
        if !languageSupport.contains(deviceLanguage) {
            deviceLanguage = "en"
        }

        var request = request
        if let token = UserServices.getAuthToken() {
            request.addValue(token, forHTTPHeaderField: "WSM-AUTH-TOKEN")
        }

        request.addValue(deviceLanguage, forHTTPHeaderField: "WSM-LOCALE")
        return request
    }
}
