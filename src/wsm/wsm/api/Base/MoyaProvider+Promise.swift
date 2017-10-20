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
                        } catch let apiError as MoyaError {
                            reject(handleRejectRequest(moyaError: apiError))
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

                        } catch let apiError as MoyaError {
                            reject(handleRejectRequest(moyaError: apiError))
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
                        } catch let apiError as MoyaError {
                            reject(handleRejectRequest(moyaError: apiError))
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
        return handleRejectRequest(moyaError: moyaError)
    } else if let apiError = error as? APIError {
        return apiError
    } else {
        return error.isCancelledError ? APIError.networkError : APIError.unauthorized(message: nil)
    }
}

private func handleRejectRequest(responseData: ResponseData) -> APIError {
    if let statusCode = responseData.status {
        switch statusCode {
        case 400:
            return  APIError.invalidRequest(response: responseData)
        case 401,
             403:
            return  APIError.unauthorized(message: responseData.message)
        default:
            return (responseData.message ?? "").isEmpty ? APIError.unknown(statusCode: statusCode) : APIError.apiFailure(message: responseData.message)
        }
    } else {
        return APIError.noStatusCode
    }
}


private func handleRejectRequest(moyaError: MoyaError) -> APIError {
    switch moyaError {
    case .statusCode(let response):
        let statusCode = response.statusCode
        let wsmResponseDataModel = Mapper<ResponseData>().map(JSONObject: try? response.mapJSON()) ?? ResponseData(status: statusCode, message: nil, data: nil)
        return handleRejectRequest(responseData: wsmResponseDataModel)
    default:
        return APIError.networkError
    }
}
