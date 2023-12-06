//
//  Validator+Equatable.swift
//  SwiftFluent
//
//  Created by Ugur Unlu on 31/07/2023.
//

import Foundation

extension Validator where Model: Equatable {
    /**
     Extends the Validator type with a method to perform inequality validation on the given model type, where the model conforms to the Equatable protocol.

     - Parameters:
     - value: The value to compare the model against for inequality.
     - errorMessage: The error message to display if the validation fails.

     - Returns: An instance of the Validator with the new inequality validation rule added.

     - Note: The `@discardableResult` attribute allows the user to ignore the return value of this method if they choose to do so.
     */
    @discardableResult
    public func notEqual(_ value: Model, errorMessage: String? = nil) -> Validator<Model> {
        let errorMessage = errorMessage ?? ErrorMessage.notEqualError(name: String(describing: Model.self), value: String(describing: value)).errorDescription
        let rule = ValidationRule<Model>(
            errorMessage: {(String(describing: Model.self), errorMessage)},
            isValid: { $0 != value }
        )
        addRule(rule)
        return self
    }

    /**
     Extends the Validator type with a method to perform equality validation on the given model type, where the model conforms to the Equatable protocol.

     - Parameters:
       - value: The value to compare the model against for equality.
       - errorMessage: The error message to display if the validation fails.

     - Returns: An instance of the Validator with the new equality validation rule added.

     - Note: The `@discardableResult` attribute allows the user to ignore the return value of this method if they choose to do so.
    */
    @discardableResult
    public func equal(_ value: Model, errorMessage: String? = nil) -> Validator<Model> {
        let errorMessage = errorMessage ?? ErrorMessage.equalError(name: String(describing: Model.self), value: String(describing: value)).errorDescription
        let rule = ValidationRule<Model>(
            errorMessage: {(String(describing: Model.self), errorMessage)},
            isValid: { $0 == value }
        )
        addRule(rule)
        return self
    }
}
