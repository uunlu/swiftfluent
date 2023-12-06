//
//  Validator+OptionalType.swift
//  SwiftFluent
//
//  Created by Ugur Unlu on 31/07/2023.
//

import Foundation

extension Validator where Model: OptionalType {
    /**
     Adds a validation rule to the Validator to check if the optional value is not nil.

     Use this method to add a validation rule that ensures the optional value is not nil.

     - Parameter errorMessage: The error message to display if the validation fails.
     - Returns: The Validator instance with the new validation rule added.

     Example usage:
     ```
     let validator = Validator<String?>()
     validator.notNil(errorMessage: "Value should not be nil.")
     ```

     The above example creates a `Validator` instance for validating an optional `String`. It adds a validation rule using the `notNil(errorMessage:)` method, which checks if the optional value is not nil. If the optional value is nil, the validation fails, and the provided error message will be displayed.

     - Note: The `@discardableResult` attribute allows ignoring the return value if desired. However, it is recommended to capture the returned Validator instance to ensure all validation rules are added.
     */
    @discardableResult
    public func notNil(errorMessage: String? = nil) -> Validator<Model> {
        let errorMessage = errorMessage ?? ErrorMessage.notNilError(name: String(describing: Model.self)).errorDescription
        let rule = ValidationRule<Model>(
            errorMessage: {(String(describing: Model.self), errorMessage)},
            isValid: { $0.isNotNil }
        )
        addRule(rule)
        return self
    }
}

// A protocol to represent optional types
public protocol OptionalType {
    associatedtype Wrapped
    var isNotNil: Bool { get }
    var value: Wrapped? { get }
}

// Conform Optional to OptionalType
extension Optional: OptionalType {
    public var isNotNil: Bool {
        return self != nil
    }

    public var value: Wrapped? {
        return self
    }
}
