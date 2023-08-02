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

// MARK: - lessThanOrEqualTo

public extension RuleForBuilder where Value: Comparable {

    /**
     Adds a validation rule to check if the value of the property is less than or equal to the specified `maxValue`.

     - Parameter maxValue: The maximum value allowed for the property.
     - Parameter errorMessage: The error message to display if the validation fails. If not provided, a default error message will be used.
     - Returns: The `RuleForBuilder` instance to allow method chaining for further rule definitions.

     Example usage:
     ```
     let validator = Validator<User>()
     .ruleFor(.age)
     .lessThanOrEqualTo(18, errorMessage: "Age must be less than or equal to 18.")
     .ruleFor(.score)
     .lessThanOrEqualTo(100) // Uses the default error message.
     ```
     - Note: If the `errorMessage` is not provided, a default error message will be used in the format: "The value of 'KeyPath' must be less than or equal to 'maxValue'.". The actual property name and `maxValue` will be dynamically inserted into the error message.
     */
    func lessThanOrEqualTo(_ maxValue: Value, errorMessage: String? = nil) -> RuleForBuilder<Model, Value> {
        buildLessThanOrEqualTo(errorMessage, maxValue)
        return self
    }

    /**
     Adds a validation rule to check if the value of the property is less than or equal to the specified `maxValue`.

     - Parameter maxValue: The maximum value allowed for the property.
     - Parameter errorMessage: The error message to display if the validation fails. If not provided, a default error message will be used.
     - Returns: The `Validator` instance to allow further rule definitions for different properties.

     Example usage:
     ```
     let validator = Validator<User>()
     .ruleFor(.age)
     .lessThanOrEqualTo(18, errorMessage: "Age must be less than or equal to 18.")
     .ruleFor(.score)
     .lessThanOrEqualTo(100) // Uses the default error message.
     ```
     - Note: If the `errorMessage` is not provided, a default error message will be used in the format: "The value of 'KeyPath' must be less than or equal to 'maxValue'.". The actual property name and `maxValue` will be dynamically inserted into the error message.
     */
    func lessThanOrEqualTo(_ maxValue: Value, errorMessage: String? = nil) -> Validator<Model> {
        buildLessThanOrEqualTo(errorMessage, maxValue)
        return validator
    }

    fileprivate func buildLessThanOrEqualTo(_ errorMessage: String?, _ maxValue: Value) {
        let error = errorMessage ?? "‘\(keyPath.propertyName)’ must be less than or equal to \(maxValue)."
        let rule = ValidationRule<Model>(errorMessage: {error}) { model in
            let propertyValue = model[keyPath: keyPath]
            return propertyValue <= maxValue
        }
        validator.addRule(rule)
    }
}

// MARK: - greaterThan

public extension RuleForBuilder where Value: Comparable {
    /**
     Adds a validation rule to check if the value of the property is greater than the specified `maxValue`.

     - Parameter minValue: The minimum value allowed for the property.
     - Parameter errorMessage: The error message to display if the validation fails. If not provided, a default error message will be used.
     - Returns: The `RuleForBuilder` instance to allow method chaining for further rule definitions.

     Example usage:
     ```
     let validator = Validator<User>()
     .ruleFor(.age)
     .greaterThan(18, errorMessage: "Age must be greater than 18.")
     .ruleFor(.score)
     .greaterThan(0) // Uses the default error message.
     ```
     - Note: If the `errorMessage` is not provided, a default error message will be used in the format: "The value of 'KeyPath' must be greater than 'minValue'.". The actual property name and `minValue` will be dynamically inserted into the error message.
     */
    func greaterThan(_ minValue: Value, errorMessage: String? = nil) -> RuleForBuilder<Model, Value> {
        buildGreaterthan(errorMessage, minValue)
        return self
    }

    /**
     Adds a validation rule to check if the value of the property is greater than the specified `minValue`.

     - Parameter minValue: The minimum value allowed for the property.
     - Parameter errorMessage: The error message to display if the validation fails. If not provided, a default error message will be used.
     - Returns: The `Validator` instance to allow further rule definitions for different properties.

     Example usage:
     ```
     let validator = Validator<User>()
     .ruleFor(.age)
     .greaterThan(18, errorMessage: "Age must be greater than 18.")
     .ruleFor(.score)
     .greaterThan(0) // Uses the default error message.
     ```
     - Note: If the `errorMessage` is not provided, a default error message will be used in the format: "The value of 'KeyPath' must be greater than 'minValue'.". The actual property name and `minValue` will be dynamically inserted into the error message.
     */
    func greaterThan(_ minValue: Value, errorMessage: String? = nil) -> Validator<Model> {
        buildGreaterthan(errorMessage, minValue)
        return validator
    }

    fileprivate func buildGreaterthan(_ errorMessage: String?, _ minValue: Value) {
        let error = errorMessage ?? "‘\(keyPath.propertyName)’ must be greater than \(minValue)."
        let rule = ValidationRule<Model>(errorMessage: {error}) { model in
            let propertyValue = model[keyPath: keyPath]
            return propertyValue > minValue
        }
        validator.addRule(rule)
    }
}
