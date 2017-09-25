//
//  API.swift
//  wsm
//
//  Created by nguyen.van.hung on 6/29/17.
//  Copyright © 2017 nguyen.van.hung. All rights reserved.
//

import Foundation
import Moya
import Alamofire
import ObjectMapper
import SwiftyUserDefaults

public enum APIError: Swift.Error {
    case noStatusCode

    case invalidData
    case unknown(statusCode: Int?)

    case notModified // 304
    case invalidRequest // 400
    case unauthorized // 401
    case accessDenied // 403
    case notFound  // 404
    case methodNotAllowed  // 405
    case serverError // 500
    case badGateway // 502
    case serviceUnavailable // 503
    case gatewayTimeout // 504
    case networkError
    case apiFailure(message: String?)

    public var localizedDescription: String {
        //TODOs: fill message match with APIError on Localize text
        return ""
    }
}

public class ResponseData: Mappable {
    var status: Int?
    var message: String?

    required public init?(map: Map) {

    }

    func isSucceeded() -> Bool {
        return status == 200
    }

    public func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
    }
}

public enum API {
    case login(String, String)
    case logout
    case getProfile(userId: Int)
    case getTimeSheets
}

extension TargetType {

    static var debugMode: Bool {
        return true
    }

    public var baseURL: URL {
        return URL(string: API.debugMode ? "http://edev.framgia.vn" : "http://wsm.framgia.vn")!
    }

    public var parameterEncoding: ParameterEncoding {
        if method == .get {
            return URLEncoding.default
        }
        return JSONEncoding.default
    }

}

extension API: TargetType {

    public var path: String {
        switch self {
        case .login:
            return "/api/sign_in"
        case .logout:
            return "/api/sign_out"
        case .getProfile(let userId):
            return "/api/dashboard/users/\(userId)"
        case .getTimeSheets:
            return "/api/dashboard/request_ots"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .login,
             .logout:
            return .post
        case .getProfile,
             .getTimeSheets:
            return .get
        }
    }

    fileprivate func createParameters<T: BaseMappable>(dataModel: T) -> [String: Any] {
        return dataModel.toJSON()
    }

    public var parameters: [String: Any]? {
        switch self {
        case .login(let email, let password):
            let params: [String: Any] = [
                "sign_in": [
                    "email": email,
                    "password": password
                ]
            ]
            return params
        case .logout,
             .getProfile,
             .getTimeSheets:
            return nil
        }
    }

    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }

    public var task: Task {
        return Task.request
    }

    public var validate: Bool {
        return false
    }
}

public struct ApiProvider {
    fileprivate static var endpointClosure = {
        (target: API) -> Endpoint<API> in
        return Endpoint<API>(
            url: url(target),
            sampleResponseClosure: { .networkResponse(200, target.sampleData) },
            method: target.method,
            parameters: target.parameters,
            parameterEncoding: target.parameterEncoding)
    }

    fileprivate static var networkActivityClosure = {
        (change: NetworkActivityChangeType) -> Void in
        UIApplication.shared.isNetworkActivityIndicatorVisible = (change == .began)
    }

    fileprivate static func getDefaultProvider() -> MoyaProvider<API> {
        let plugins: [PluginType] = [
            NetworkLoggerPlugin(verbose: true, output: debugLog, responseDataFormatter: JSONResponseDataFormatter),
            NetworkActivityPlugin(networkActivityClosure: networkActivityClosure),
            WsmAccessTokenPlugin()
        ]
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        let newManager = Alamofire.SessionManager(configuration: configuration)

        return MoyaProvider<API>(endpointClosure: endpointClosure, manager: newManager, plugins: plugins)
    }

    fileprivate static let defaultProvider = getDefaultProvider()

    public static var shared: MoyaProvider<API> {
        return defaultProvider
    }
}

public func url(_ route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}

private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data // fallback to original data if it can't be serialized.
    }
}

private func debugLog(separator: String, terminator: String, items: Any...) {
    debugPrint(items, separator: separator, terminator: terminator)
}
