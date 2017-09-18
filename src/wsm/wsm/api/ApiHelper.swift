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
            if let json = try response.mapJSON() as? [String: Any], let status = json["status"] as? String {
                return ResponseData(status, json["message"] as? String, json["data"] as? [String: Any])
            }
        } catch {}
        return ResponseData("failure", "unknown", nil)
    }

    class func mapResponseAsRaw(_ response: Response) -> ResponseData {
        do {
            if let json = try response.mapJSON() as? [String: Any], let status = json["status"] as? String {
                return ResponseData(status, json["message"] as? String, json["data"])
            }
        } catch {}
        return ResponseData("failure", "unknown", nil)
    }
}
