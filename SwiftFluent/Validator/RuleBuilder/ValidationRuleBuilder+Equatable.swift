//
//  ValidationRuleBuilder+Equatable.swift
//  SwiftFluent
//
//  Created by Ugur Unlu on 02/08/2023.
//

import Foundation

// MARK: - equal

public extension ValidationRuleBuilder where Value: Equatable {
    /**
     Adds a validation rule to check if the value of the property is equal to the specified `value`.

     - Parameter value: The value to compare against the property value.
     - Parameter errorMessage: The error message to display if the validation fails. If not provided, a default error message will be used.
     - Returns: The `ValidationRuleBuilder` instance to allow method chaining for further rule definitions.

     Example usage:
     ```
     let validator = Validator<User>()
     .ruleFor(\.age)
     .equal(25, errorMessage: "Age must be equal to 25.")
     .ruleFor(\.name)
     .equal("John") // Uses the default error message.
     ```
     - Note: If the `errorMessage` is not provided, a default error message will be used in the format: "‘\(keyPath.propertyName)’ must be equal to \(value).". The actual property name and `value` will be dynamically inserted into the error message.
     */
    func equal(_ value: Value, errorMessage: String? = nil) -> ValidationRuleBuilder<Model, Value> {
        buildEqual(value, errorMessage)
        return self
    }

    /**
     Adds a validation rule to check if the value of the property is equal to the specified `value`.

     - Parameter value: The value to compare against the property value.
     - Parameter errorMessage: The error message to display if the validation fails. If not provided, a default error message will be used.
     - Returns: The `Validator` instance to allow further rule definitions for different properties.

     Example usage:
     ```
     let validator = Validator<User>()
     .ruleFor(\.age)
     .equal(25, errorMessage: "Age must be equal to 25.")
     .ruleFor(\.name)
     .equal("John") // Uses the default error message.
     ```
     - Note: If the `errorMessage` is not provided, a default error message will be used in the format: "‘\(keyPath.propertyName)’ must be equal to \(value).". The actual property name and `value` will be dynamically inserted into the error message.
     */
    func equal(_ value: Value, errorMessage: String? = nil) -> Validator<Model> {
        buildEqual(value, errorMessage)
        return validator
    }

    private func buildEqual(_ value: Value, _ errorMessage: String?) {
        let errorMessage = errorMessage ?? ErrorMessage.equalError(name: keyPath.propertyName, value: String(describing: value)).errorDescription
        let error = (keyPath.propertyName, errorMessage)
        let rule = ValidationRule<Model>(errorMessage: {error}) { model in
            let propertyValue = model[keyPath: keyPath]
            return propertyValue == value
        }
        validator.addRule(rule)
    }
}

// MARK: - notEqual

public extension ValidationRuleBuilder where Value: Equatable {

    /**
     Adds a validation rule to check if the value of the property is not equal to the specified `value`.

     - Parameter value: The value that the property should not be equal to.
     - Parameter errorMessage: The error message to display if the validation fails. If not provided, a default error message will be used.
     - Returns: The `ValidationRuleBuilder` instance to allow method chaining for further rule definitions.

     Example usage:
     ```
     let validator = Validator<User>()
     .ruleFor(\.age)
     .notEqual(18, errorMessage: "Age cannot be 18.")
     .ruleFor(\.name)
     .notEqual("John") // Uses the default error message.
     ```
     - Note: If the `errorMessage` is not provided, a default error message will be used in the format: "‘\(keyPath.propertyName)’ should not be equal to \(value).". The actual property name and `value` will be dynamically inserted into the error message.
     */
    func notEqual(_ value: Value, errorMessage: String? = nil) -> ValidationRuleBuilder<Model, Value> {
        buildNotEqual(value, errorMessage)
        return self
    }

    /**
     Adds a validation rule to check if the value of the property is not equal to the specified `value`.

     - Parameter value: The value that the property should not be equal to.
     - Parameter errorMessage: The error message to display if the validation fails. If not provided, a default error message will be used.
     - Returns: The `Validator` instance to allow further rule definitions for different properties.

     Example usage:
     ```
     let validator = Validator<User>()
     .ruleFor(\.age)
     .notEqual(18, errorMessage: "Age cannot be 18.")
     .ruleFor(\.name)
     .notEqual("John") // Uses the default error message.
     ```
     - Note: If the `errorMessage` is not provided, a default error message will be used in the format: "‘\(keyPath.propertyName)’ should not be equal to \(value).". The actual property name and `value` will be dynamically inserted into the error message.
     */
    func notEqual(_ value: Value, errorMessage: String? = nil) -> Validator<Model> {
        buildNotEqual(value, errorMessage)
        return validator
    }

    private func buildNotEqual(_ value: Value, _ errorMessage: String?) {
        let errorMessage = errorMessage ?? ErrorMessage.notEqualError(name: keyPath.propertyName, value: String(describing: value)).errorDescription
        let error = (keyPath.propertyName, errorMessage)
        let rule = ValidationRule<Model>(errorMessage: {error}) { model in
            let propertyValue = model[keyPath: keyPath]
            return propertyValue != value
        }
        validator.addRule(rule)
    }
}
