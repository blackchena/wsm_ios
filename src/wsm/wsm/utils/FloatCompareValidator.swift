//
//  FloatCompareValidator.swift
//  wsm
//
//  Created by Lê Thanh Quang on 10/9/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import Validator

public struct FloatCompareValidator: ValidationRule {
    public typealias InputType = String

    public let error: Error

    /**

     A minimum value an input must equal to or be greater than to pass as valid.

     */
    let min: Float

    /**

     A maximum value an input must equal to or be less than to pass as valid.

     */
    let max: Float

    let isRequired: Bool


    /**

     Initializes a `FloatCompareValidator` with a min and max value for an
     input comparison, and an error describing a failed validation.

     - Parameters:
     - min: A minimum value an input must equal to or be greater than.
     - max: A maximum value an input must equal to or be less than.
     - error: An error describing a failed validation.

     */
    public init(min: Float, max: Float, isRequired: Bool = true, error: Error) {
        self.min = min
        self.max = max
        self.error = error
        self.isRequired = isRequired
    }

    /**

     Validates the input.

     - Parameters:
     - input: Input to validate.

     - Returns:
     true if the input is equal to or between the minimum and maximum.

     */
    public func validate(input: String?) -> Bool {
        guard let input = Float.init(input ?? "") else { return !isRequired }
        return input >= min && input <= max
    }
}
