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
import InAppLocalize

public enum APIError: Swift.Error, LocalizedError {
    case noStatusCode
    case invalidData
    case unknown(statusCode: Int?)
    case invalidRequest(response: ResponseData?) // 400
    case unauthorized(message: String?) // 401
    case networkError
    case apiFailure(message: String?)

    public var errorDescription: String? {
        //TODOs: fill message match with APIError on Localize text
        switch self {
        case .apiFailure(let message):
            return message ?? LocalizationHelper.shared.localized("api_error_unknow_error")

        case .networkError:
            return LocalizationHelper.shared.localized("api_network_error")
        case .unauthorized( let message):
            //TODOs: handle accessToken expired case -> must logout
            return message ?? LocalizationHelper.shared.localized("you_are_unauthorized_to_access")
        case .unknown(let statusCode):
            print("ERROR WITH HTTP STATUS CODE: \(String(describing: statusCode))")
            return LocalizationHelper.shared.localized("api_error_server_error")
        case .noStatusCode:
            return LocalizationHelper.shared.localized("api_error_server_error")
        case .invalidData,
             .invalidRequest:
            return LocalizationHelper.shared.localized("api_error_unknow_error")
        }
    }
}

public class ResponseData: Mappable {
    var status: Int?
    var message: String?
    var data: [String]?

    init(status: Int?, message: String?, data: [String]?) {
        self.status = status
        self.message = message
        self.data = data
    }

    required public init?(map: Map) {

    }

    func isSucceeded() -> Bool {
        return status == 200
    }

    public func mapping(map: Map) {
        status <- map["status"]
        message <- map["messages"]
        data <- map["data.base"]
    }
}

protocol BaseApiTargetType: TargetType {
    func createParameters<T: BaseMappable>(fromDataModel: T) -> [String: Any]
}

extension BaseApiTargetType {

    public var baseURL: URL {
        return URL(string: ApiProvider.baseURLString)!
    }

    public var parameterEncoding: ParameterEncoding {
        if method == .get {
            return URLEncoding.default
        }
        return JSONEncoding.default
    }

    func createParameters<T: BaseMappable>(fromDataModel: T) -> [String: Any] {
        return fromDataModel.toJSON()
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

    /**
     * Set default method is GET, if any APIs enpoint have differences Method, should override this
     */
    public var method: Moya.Method {
        return .get
    }

     public var parameters: [String: Any]? {
        return nil
    }
}

public struct ApiProvider {

    static var debugMode: Bool {
        return true
    }

    public static var baseURLString: String {
        return ApiProvider.debugMode ? AppConstant.debugAPIBaseUrl : AppConstant.productAPIBaseUrl
    }

    fileprivate static var endpointClosure = {
        (target: MultiTarget) -> Endpoint<MultiTarget> in
        return Endpoint<MultiTarget>(
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

    fileprivate static func getDefaultProvider() -> MoyaProvider<MultiTarget> {
        let plugins: [PluginType] = [
            NetworkLoggerPlugin(verbose: true, output: debugLog, responseDataFormatter: JSONResponseDataFormatter),
            NetworkActivityPlugin(networkActivityClosure: networkActivityClosure),
            WsmAccessTokenPlugin()
        ]
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        let newManager = Alamofire.SessionManager(configuration: configuration)

        return MoyaProvider<MultiTarget>(endpointClosure: endpointClosure, manager: newManager, plugins: plugins)
    }

    fileprivate static let defaultProvider = getDefaultProvider()

    public static var shared: MoyaProvider<MultiTarget> {
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
