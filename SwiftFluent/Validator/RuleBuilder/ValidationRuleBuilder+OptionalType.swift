//
//  ValidationRuleBuilder+OptionalType.swift
//  SwiftFluent
//
//  Created by Ugur Unlu on 02/08/2023.
//

import Foundation

// MARK: - notNil

public extension ValidationRuleBuilder where Value: OptionalType  {

    /**
     Adds a validation rule to check if the value of the property is not nil.

     - Parameter errorMessage: The error message to display if the validation fails. If not provided, a default error message will be used.
     - Returns: The `ValidationRuleBuilder` instance to allow method chaining for further rule definitions.

     Example usage:
     ```
     let validator = Validator<User>()
     .ruleFor(\.name)
     .notNil(errorMessage: "Name must not be empty.")
     .ruleFor(\.age)
     .notNil() // Uses the default error message.
     ```
     - Note: If the `errorMessage` is not provided, a default error message will be used in the format: "The value of 'KeyPath' must not be nil.". The actual property name will be dynamically inserted into the error message.
     */
    func notNil(errorMessage: String? = nil) -> ValidationRuleBuilder<Model, Value> {
        buildNotNil(errorMessage)
        return self
    }

    /**
     Adds a validation rule to check if the value of the property is not nil.

     - Parameter errorMessage: The error message to display if the validation fails. If not provided, a default error message will be used.
     - Returns: The `Validator` instance to allow further rule definitions for different properties.

     Example usage:
     ```
     let validator = Validator<User>()
     .ruleFor(\.name)
     .notNil(errorMessage: "Name must not be empty.")
     .ruleFor(\.age)
     .notNil() // Uses the default error message.
     ```
     - Note: If the `errorMessage` is not provided, a default error message will be used in the format: "The value of 'KeyPath' must not be nil.". The actual property name will be dynamically inserted into the error message.
     */
    func notNil(errorMessage: String? = nil) -> Validator<Model> {
        buildNotNil(errorMessage)
        return validator
    }

    private func buildNotNil(_ errorMessage: String?) {
        let errorMessage = errorMessage ?? ErrorMessage.notNilError(name: keyPath.propertyName).errorDescription
        let error = (keyPath.propertyName, errorMessage)
        let rule = ValidationRule<Model>(errorMessage: { error}) { model in
            let propertyValue = model[keyPath: keyPath]
            return propertyValue.isNotNil
        }
        validator.addRule(rule)
    }
}
