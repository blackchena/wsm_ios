//
//  APIHelper.swift
//  wsm
//
//  Created by Nguyen Hung on 8/26/17.
//  Copyright © 2017 nguyen.van.hung. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift
import Moya

final class ApiHelper {
    class func mapResponseAsDictionary(_ response: Response) -> ResponseData {
        do {
            if let json = try response.mapJSON() as? [String: Any], let status = json["status"] as? Int {
                return ResponseData(status, json["messages"] as? String, json["data"] as? [String: Any])
            }
        } catch {}
        return ResponseData(400, "unknown", nil)
    }

    class func mapResponseAsRaw(_ response: Response) -> ResponseData {
        do {
            if let json = try response.mapJSON() as? [String: Any], let status = json["status"] as? Int {
                return ResponseData(status, json["messages"] as? String, json["data"])
            }
        } catch {}
        return ResponseData(400, "unknown", nil)
    }
}
