//
//  MoyaProvider+Promise.swift
//  wsm
//
//  Created by Lê Thanh Quang on 9/21/17.
//  Copyright © 2017 framgia. All rights reserved.
//
import Foundation
import PromiseKit
import Moya
import ObjectMapper

public extension MoyaProvider {
    public typealias ResultPromise<T: BaseMappable> = Promise<T>

    public typealias VoidPromise = Promise<Void>

    public func requestPromise<T: BaseMappable>(target: Target,
                                                queue: DispatchQueue? = nil,
                                                progress: Moya.ProgressBlock? = nil) -> ResultPromise<T> {

        return requestPromiseWithCancellable(target: target, queue: queue, progress: progress).promise
    }

    public func requestPromise(target: Target,
                               queue: DispatchQueue? = nil,
                               progress: Moya.ProgressBlock? = nil) -> VoidPromise {

        return requestPromiseWithCancellable(target: target, queue: queue, progress: progress).promise
    }

    public func requestPromiseArray<T: BaseMappable>(target: Target,
                                                     queue: DispatchQueue? = nil,
                                                     progress: Moya.ProgressBlock? = nil) -> ResultPromise<[T]> {

        return requestPromiseArrayWithCancellable(target: target, queue: queue, progress: progress).promise
    }

    func requestPromiseWithCancellable<T: BaseMappable>(target: Target,
                                                        queue: DispatchQueue?,
                                                        progress: Moya.ProgressBlock? = nil) ->
        (promise: ResultPromise<T>, cancellable: Cancellable) {
            let (promise, fulfill, reject) = ResultPromise<T>.pending()

            return (
                promise, self.request(target, completion: { result in
                    switch result {
                    case .success(let response):
                        do {
                            try response.tryToValidateResponseData()

                            guard let object = Mapper<T>().map(JSONObject: try response.mapJSON()) else {
                                throw APIError.invalidData
                            }

                            fulfill(object)
                        } catch let error {
                            //TODOs: Handle isCancelledError case
                            reject(handleCompleteRequestError(error: error))
                        }
                    case .failure(let error):
                        reject(handleRejectRequest(moyaError: error))
                    }
                }))
    }

    func requestPromiseWithCancellable(target: Target,
                                       queue: DispatchQueue?,
                                       progress: Moya.ProgressBlock? = nil) ->
        (promise: VoidPromise, cancellable: Cancellable) {
            let (promise, fulfill, reject) = VoidPromise.pending()

            return (
                promise, self.request(target, completion: { result in
                    switch result {
                    case .success(let response):
                        do {
                            try response.tryToValidateResponseData()
                            fulfill()
                        } catch let error {
                            //TODOs: Handle isCancelledError case
                            reject(handleCompleteRequestError(error: error))
                        }
                    case .failure(let error):
                        reject(handleRejectRequest(moyaError: error))
                    }
                }))
    }

    func requestPromiseArrayWithCancellable<T: BaseMappable>(target: Target,
                                                             queue: DispatchQueue?,
                                                             progress: Moya.ProgressBlock? = nil) ->
        (promise: ResultPromise<[T]>, cancellable: Cancellable) {
            let (promise, fulfill, reject) = ResultPromise<[T]>.pending()

            return (
                promise, self.request(target, completion: { result in
                    switch result {
                    case .success(let response):
                        do {

                            try response.tryToValidateResponseData()

                            guard let array = try response.mapJSON() as? [[String : Any]] else {
                                throw APIError.invalidData
                            }

                            let data = Mapper<T>().mapArray(JSONArray: array)
                            fulfill(data)
                        } catch let error {
                            //TODOs: Handle isCancelledError case
                            reject(handleCompleteRequestError(error: error))
                        }
                    case .failure(let error):
                        reject(handleRejectRequest(moyaError: error))
                    }
                }))
    }
}

private func handleCompleteRequestError(error: Swift.Error) -> APIError {
    if let moyaError = error as? MoyaError {
        moyaError.printError()
        return APIError.invalidData
    } else if let apiError = error as? APIError {
        return apiError
    } else {
        return error.isCancelledError ? APIError.networkError : APIError.unauthorized
    }

}

private func handleRejectRequest(moyaError: MoyaError) -> APIError {
    switch moyaError {
    case .statusCode(let response):
        let statusCode = response.statusCode
        switch statusCode {
        case 304:
            return APIError.notModified
        case 400:
            return  APIError.invalidRequest
        case 401:
            return  APIError.unauthorized
        case 403:
            return APIError.accessDenied
        case 404:
            return APIError.notFound
        case 405:
            return APIError.methodNotAllowed
            //    case 422:
            //    let message = ResponseMessage(value: value)
            //    SpeedLog.print(message)
        //    reject(ResponseError.validate(message: message))
        case 500:
            return APIError.serverError
        case 502:
            return APIError.badGateway
        case 503:
            return APIError.serviceUnavailable
        case 504:
            return APIError.gatewayTimeout
        default:
            return APIError.unknown(statusCode: statusCode)
        }
    default:
        return APIError.noStatusCode
    }
}
