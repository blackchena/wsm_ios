//
//  API.swift
//  wsm
//
//  Created by nguyen.van.hung on 6/29/17.
//  Copyright © 2017 nguyen.van.hung. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift
import Moya
import Alamofire
import DateToolsSwift

public enum RequestErrorCode: Equatable {
    case unauthorized
    case notFound
    case parseError
    case networkError
    case unknown
}

public func==(lhs: RequestErrorCode, rhs: RequestErrorCode) -> Bool {
    switch (lhs, rhs) {
    case (.unauthorized, .unauthorized): return true
    case (.notFound, .notFound): return true
    case (.parseError, .parseError): return true
    case (.networkError, .networkError): return true
    default: return false
    }
}

public struct RequestErrorType: Swift.Error, Equatable {
    var code: RequestErrorCode
    var message: String?

    init(_ message: String? = nil, _ code: RequestErrorCode = .parseError) {
        self.message = message
        self.code = code
    }

    static let failure = RequestErrorType("failed", .unknown)
    static let unauthorized = RequestErrorType("unauthorized", .unauthorized)
    static let notFound = RequestErrorType("notFound", .notFound)
    static let parseError = RequestErrorType("parseError", .parseError)
    static let networkError = RequestErrorType("networkError", .networkError)
    static let unknown = RequestErrorType("unknown", .unknown)
}

public func==(lhs: RequestErrorType, rhs: RequestErrorType) -> Bool {
    return lhs.code == rhs.code
}

public struct ResponseData {
    var status: Int
    var message: String?
    var data: Any?

    init(_ status: Int, _ message: String?, _ data: Any?) {
        self.status = status
        self.message = message
        self.data = data
    }

    func isSucceeded() -> Bool {
        return status == 200
    }

    func string(forKey key: String) -> String? {
        if let data = data as? [String: Any] {
            return data[key] as? String
        }
        return nil
    }
}

public enum API {
    case login(String, String)
    case logout
    case getProfile(userId: Int)
}

extension API: TargetType {
    static var debugMode = true

    static let baseURLStringProd = "http://wsm.framgia.vn"

    static let baseURLStringDebug = "http://edev.framgia.vn"

    public var baseURL: URL {
        if API.debugMode {
            return URL(string: API.baseURLStringDebug)!
        }
        return URL(string: API.baseURLStringProd)!
    }

    public var path: String {
        switch self {
        case .login:
            return "/api/sign_in"
        case .logout:
            return "/api/sign_out"
        case .getProfile(let userId):
            return "/api/dashboard/users/\(userId)"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .login,
             .logout:
            return .post
        case .getProfile:
            return .get
        }
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
        case .logout:
            return nil
        case .getProfile:
            return nil
        }
    }

    public var parameterEncoding: ParameterEncoding {
        if method == .get {
            return URLEncoding.default
        }
        return JSONEncoding.default
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
            NetworkLoggerPlugin(verbose: true, output: debugLog),
            NetworkActivityPlugin(networkActivityClosure: networkActivityClosure)
        ]
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        let newManager = Alamofire.SessionManager(configuration: configuration)

        return MoyaProvider<API>(endpointClosure: endpointClosure, manager: newManager, plugins: plugins)
    }

    fileprivate static func getAuthenticatedProvider(_ token: String) -> MoyaProvider<API> {
        let plugins: [PluginType] = [
            NetworkLoggerPlugin(verbose: true, output: debugLog),
            NetworkActivityPlugin(networkActivityClosure: networkActivityClosure),
            WsmAccessTokenPlugin(token: token)
        ]
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        let newManager = Alamofire.SessionManager(configuration: configuration)

        return MoyaProvider<API>(endpointClosure: endpointClosure, manager: newManager, plugins: plugins)
    }

    fileprivate static var authenticatedProvider: MoyaProvider<API>?
    fileprivate static let defaultProvider = getDefaultProvider()
    fileprivate static var _accessToken: String?
    public static var accessToken: String? {
        get {
            return _accessToken
        }
        set (value) {
            _accessToken = value
            if let token = _accessToken {
                authenticatedProvider = getAuthenticatedProvider(token)
            } else {
                authenticatedProvider = nil
            }
        }
    }
    public static var shared: MoyaProvider<API> {
        if let authenticatedProvider = authenticatedProvider {
            return authenticatedProvider
        }
        return defaultProvider
    }
}

public func url(_ route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}

private func debugLog(separator: String, terminator: String, items: Any...) {
    debugPrint(items, separator: separator, terminator: terminator)
}
