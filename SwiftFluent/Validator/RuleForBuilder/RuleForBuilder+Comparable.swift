//
//  RuleForBuilder+Comparable.swift
//  SwiftFluent
//
//  Created by Ugur Unlu on 01/08/2023.
//

import Foundation


// MARK: - lessThan

public extension RuleForBuilder where Value: Comparable {

    /**
     Adds a validation rule to check if the value of the property is less than the specified `maxValue`.

     - Parameter maxValue: The maximum value allowed for the property.
     - Parameter errorMessage: The error message to display if the validation fails. If not provided, a default error message will be used.
     - Returns: The `RuleForBuilder` instance to allow method chaining for further rule definitions.

     Example usage:
     ```
     let validator = Validator<User>()
     .ruleFor(.age)
     .lessThan(10, errorMessage: "Age must be less than 10.")
     .ruleFor(.name)
     .lessThan(100) // Uses the default error message.
     ```
     - Note: If the `errorMessage` is not provided, a default error message will be used in the format: "The value of 'KeyPath' must be less than 'maxValue'.". The actual property name and `maxValue` will be dynamically inserted into the error message.
     */
    func lessThan(_ maxValue: Value, errorMessage: String? = nil) -> RuleForBuilder<Model, Value> {
        buildLessthan(errorMessage, maxValue)
        return self
    }

    /**
     Adds a validation rule to check if the value of the property is less than the specified `maxValue`.

     - Parameter maxValue: The maximum value allowed for the property.
     - Parameter errorMessage: The error message to display if the validation fails. If not provided, a default error message will be used.
     - Returns: The `Validator` instance to allow further rule definitions for different properties.

     Example usage:
     ```
     let validator = Validator<User>()
     .ruleFor(.age)
     .lessThan(10, errorMessage: "Age must be less than 10.")
     .ruleFor(.name)
     .lessThan(100) // Uses the default error message.
     ```
     - Note: If the `errorMessage` is not provided, a default error message will be used in the format: "The value of 'KeyPath' must be less than 'maxValue'.". The actual property name and `maxValue` will be dynamically inserted into the error message.
     */
    func lessThan(_ maxValue: Value, errorMessage: String? = nil) -> Validator<Model> {
        buildLessthan(errorMessage, maxValue)
        return validator
    }

    fileprivate func buildLessthan(_ errorMessage: String?, _ maxValue: Value) {
        let error = errorMessage ?? "‘\(keyPath.propertyName)’ must be less than \(maxValue)."
        let rule = ValidationRule<Model>(errorMessage: {error}) { model in
            let propertyValue = model[keyPath: keyPath]
            return propertyValue < maxValue
        }
        validator.addRule(rule)
    }
}

// MARK: - greaterThan

public extension RuleForBuilder where Value: Comparable {
    func greaterThan(_ maxValue: Value, errorMessage: String? = nil) -> RuleForBuilder<Model, Value> {
        buildGreaterthan(errorMessage, maxValue)
        return self
    }

    func greaterThan(_ maxValue: Value, errorMessage: String? = nil) -> Validator<Model> {
        buildGreaterthan(errorMessage, maxValue)
        return validator
    }

    fileprivate func buildGreaterthan(_ errorMessage: String?, _ maxValue: Value) {
        let error = errorMessage ?? "‘\(keyPath.propertyName)’ must be greater than \(maxValue)."
        let rule = ValidationRule<Model>(errorMessage: {error}) { model in
            let propertyValue = model[keyPath: keyPath]
            return propertyValue > maxValue
        }
        validator.addRule(rule)
    }
}
