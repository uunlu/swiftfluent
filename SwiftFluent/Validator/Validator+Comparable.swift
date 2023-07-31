//
//  Validator+Comparable.swift
//  SwiftFluent
//
//  Created by Ugur Unlu on 31/07/2023.
//

import Foundation

extension Validator where Model: Comparable {
    /**
     Extends the Validator type with a method to perform less-than validation on the given model type.

     - Parameters:
       - value: The value to compare the model against for less-than validation.
       - errorMessage: The error message to display if the validation fails.

     - Returns: An instance of the Validator with the new less-than validation rule added.

     - Note: The `@discardableResult` attribute allows the user to ignore the return value of this method if they choose to do so.

     - Remark: This method checks if the model's value is less than the provided `value`. The validation will pass if the model's value is indeed less than `value`.
    */
    @discardableResult
    public func lessThan(_ value: Model, errorMessage: String) -> Validator<Model> {
        let rule = ValidationRule<Model>(
            errorMessage: errorMessage,
            isValid: { $0 < value }
        )
        addRule(rule)
        return self
    }
}
