//
//  ErrorDebugPrinter.swift
//  wsm
//
//  Created by Lê Thanh Quang on 9/23/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import Moya

extension Swift.Error {
    func printError() {
        guard let moyaError = self as? MoyaError else {
            print(type(of: self))
            return
        }

        print("ErrorDebugPrinter: ")
        print(String(describing: moyaError.errorDescription))

        switch moyaError {
        case .imageMapping(let response):
            print(response)
        case .jsonMapping(let response):
            print(response)
        case .statusCode(let response):
            print(response)
        case .stringMapping(let response):
            print(response)
        case .underlying(let nsError):
            print(nsError)
        case .requestMapping:
            print("nil")
        }
    }
}
