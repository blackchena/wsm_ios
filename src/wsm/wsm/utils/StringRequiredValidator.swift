//
//  StringRequiredValidator.swift
//  wsm
//
//  Created by Lê Thanh Quang on 10/11/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import Validator

class StringRequiredValidator: ValidationRule {

    public typealias InputType = String

    public let error: Error

    /**

     Initializes a `ValidationRuleComparison` with an error describing a failed
     validation.

     - Parameters:
     - error: An error describing a failed validation.

     */
    public init(error: Error) {
        self.error = error
    }

    /**

     Validates the input.

     - Parameters:
     - input: Input to validate.

     - Returns:
     true if non-nil.

     */
    public func validate(input: String?) -> Bool {
        return (input ?? "").isNotEmpty
    }

}
