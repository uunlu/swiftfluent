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
            errorMessage: { (String(describing: Model.self) ,errorMessage) },
            isValid: { $0 < value }
        )
        addRule(rule)
        return self
    }

    /**
     Extends the Validator type with a method to perform less-than-or-equal-to validation on the given model type.

     - Parameters:
     - value: The value to compare the model against for less-than-or-equal-to validation.
     - errorMessage: The error message to display if the validation fails.

     - Returns: An instance of the Validator with the new less-than-or-equal-to validation rule added.

     - Note: The `@discardableResult` attribute allows the user to ignore the return value of this method if they choose to do so.

     - Remark: This method checks if the model's value is less than or equal to the provided `value`. The validation will pass if the model's value is less than or equal to `value`.
     */
    @discardableResult
    public func lessThanOrEqualTo(_ value: Model, errorMessage: String) -> Validator<Model> {
        let rule = ValidationRule<Model>(
            errorMessage: { ( String(describing: Model.self), errorMessage) },
            isValid: { $0 <= value }
        )
        addRule(rule)
        return self
    }

    /**
     Extends the Validator type with a method to perform greater-than validation on the given model type.

     - Parameters:
     - value: The value to compare the model against for greater-than validation.
     - errorMessage: The error message to display if the validation fails.

     - Returns: An instance of the Validator with the new greater-than validation rule added.

     - Note: The `@discardableResult` attribute allows the user to ignore the return value of this method if they choose to do so.

     - Remark: This method checks if the model's value is greater than the provided `value`. The validation will pass if the model's value is indeed greater than `value`.
     */
    @discardableResult
    public func greaterThan(_ value: Model, errorMessage: String) -> Validator<Model> {
        let rule = ValidationRule<Model>(
            errorMessage: {(String(describing: Model.self), errorMessage)},
            isValid: { $0 > value }
        )
        addRule(rule)
        return self
    }

    /**
     Extends the Validator type with a method to perform greater-than-or-equal-to validation on the given model type.

     - Parameters:
     - value: The value to compare the model against for greater-than-or-equal-to validation.
     - errorMessage: The error message to display if the validation fails.

     - Returns: An instance of the Validator with the new greater-than-or-equal-to validation rule added.

     - Note: The `@discardableResult` attribute allows the user to ignore the return value of this method if they choose to do so.

     - Remark: This method checks if the model's value is greater than or equal to the provided `value`. The validation will pass if the model's value is greater than or equal to `value`.
     */
    @discardableResult
    public func greaterThanOrEqualTo(_ value: Model, errorMessage: String) -> Validator<Model> {
        let rule = ValidationRule<Model>(
            errorMessage: {(String(describing: Model.self), errorMessage)},
            isValid: { $0 >= value }
        )
        addRule(rule)
        return self
    }
}
