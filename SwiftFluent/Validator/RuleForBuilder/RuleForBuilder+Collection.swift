//
//  RuleForBuilder+Sequence.swift
//  SwiftFluent
//
//  Created by Ugur Unlu on 02/08/2023.
//

import Foundation

// MARK: - notEmpty

public extension RuleForBuilder where Value: Collection  {

    /**
     Adds a validation rule to check if the value of the property is not empty.

     - Parameter errorMessage: The error message to display if the validation fails. If not provided, a default error message will be used.
     - Returns: The `RuleForBuilder` instance to allow method chaining for further rule definitions.

     Example usage:
     ```
     let validator = Validator<User>()
     .ruleFor(.name)
     .notEmpty(errorMessage: "Name must not be empty.")
     .ruleFor(.email)
     .notEmpty() // Uses the default error message.
     ```
     - Note: If the `errorMessage` is not provided, a default error message will be used in the format: "The value of 'KeyPath' must not be empty.". The actual property name will be dynamically inserted into the error message.
     */
    func notEmpty(_ errorMessage: String? = nil) -> RuleForBuilder<Model, Value> {
        buildNotEmpty(errorMessage)
        return self
    }

    /**
     Adds a validation rule to check if the value of the property is not empty.

     - Parameter errorMessage: The error message to display if the validation fails. If not provided, a default error message will be used.
     - Returns: The `Validator` instance to allow further rule definitions for different properties.

     Example usage:
     ```
     let validator = Validator<User>()
     .ruleFor(.name)
     .notEmpty(errorMessage: "Name must not be empty.")
     .ruleFor(.email)
     .notEmpty() // Uses the default error message.
     ```
     - Note: If the `errorMessage` is not provided, a default error message will be used in the format: "The value of 'KeyPath' must not be empty.". The actual property name will be dynamically inserted into the error message.
     */
    func notEmpty(_ errorMessage: String? = nil) -> Validator<Model> {
        buildNotEmpty(errorMessage)
        return validator
    }

    fileprivate func buildNotEmpty(_ errorMessage: String?) {
        let error = errorMessage ?? "‘\(keyPath.propertyName)’ should not be empty."
        let rule = ValidationRule<Model>(errorMessage: {(keyPath.propertyName, error)}) { model in
            let propertyValue = model[keyPath: keyPath]
            return propertyValue.isEmpty == false
        }
        validator.addRule(rule)
    }
}
