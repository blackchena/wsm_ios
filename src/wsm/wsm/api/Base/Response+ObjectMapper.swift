//
//  Observable+ObjectMapper.swift
//  wsm
//
//  Created by Lê Thanh Quang on 9/21/17.
//  Copyright © 2017 framgia. All rights reserved.
//
import Foundation
import Moya
import ObjectMapper

public extension Response {

    /// Maps data received from the signal into an object which
    /// implements the Mappable protocol and check is this a success request.
    /// If not, throw Error
    public func tryToValidateResponseData() throws {
        if let responseData = ResponseData(JSONString: try mapString()) {
            if !responseData.isSucceeded() {
                throw APIError.apiFailure(message: responseData.message)
            }
        } else {
            //Cannot parser result
            throw APIError.invalidData
        }
    }

    /// Maps data received from the signal into an object which implements the Mappable protocol.
    /// If the conversion fails, the signal errors.
    public func mapObject<T: Mappable>() throws -> T {

        do {
            try tryToValidateResponseData()

            guard let object = Mapper<T>().map(JSONObject: try mapJSON()) else {
                //            throw MoyaError.jsonMapping(self)
                throw APIError.invalidData
            }
            return object
        } catch let moyaError as MoyaError {
            moyaError.printError()
            throw APIError.invalidData
        } catch let apiError as APIError {
            throw apiError
        } catch let error {
            throw error
        }
    }

    /// Maps data received from the signal into an array of objects which implement the Mappable
    /// protocol.
    /// If the conversion fails, the signal errors.
    public func mapArray<T: Mappable>() throws -> [T] {

        do {
            try tryToValidateResponseData()

            guard let array = try mapJSON() as? [[String : Any]] else {
                throw APIError.invalidData
            }

            return Mapper<T>().mapArray(JSONArray: array)
        } catch _ as MoyaError {
            throw APIError.invalidData
        } catch let apiError as APIError {
            throw apiError
        } catch let error {
            throw error
        }
    }

    // MARK: - ImmutableMappable

    /// Maps data received from the signal into an object which implements the ImmutableMappable
    /// protocol.
    /// If the conversion fails, the signal errors.
    public func mapObject<T: ImmutableMappable>() throws -> T {

        do {
            try tryToValidateResponseData()

            return try Mapper<T>().map(JSONObject: try mapJSON())
        } catch _ as MoyaError {
            throw APIError.invalidData
        } catch let apiError as APIError {
            throw apiError
        } catch let error {
            throw error
        }
    }

    /// Maps data received from the signal into an array of objects which implement the ImmutableMappable
    /// protocol.
    /// If the conversion fails, the signal errors.
    public func mapArray<T: ImmutableMappable>() throws -> [T] {

        do {
            try tryToValidateResponseData()

            guard let array = try mapJSON() as? [[String : Any]] else {
                throw APIError.invalidData
            }

            return try Mapper<T>().mapArray(JSONArray: array)
        } catch _ as MoyaError {
            throw APIError.invalidData
        } catch let apiError as APIError {
            throw apiError
        } catch let error {
            throw error
        }
    }
}
