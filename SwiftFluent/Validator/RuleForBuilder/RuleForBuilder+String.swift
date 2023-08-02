//
//  RuleForBuilder+String.swift
//  SwiftFluent
//
//  Created by Ugur Unlu on 01/08/2023.
//

import Foundation

// MARK: - length

public extension RuleForBuilder where Value == String {

    /**
     Adds a validation rule to check if the length of the property value falls within the specified range.

     - Parameter min: The minimum length allowed for the property value.
     - Parameter max: The maximum length allowed for the property value.
     - Parameter errorMessage: The error message to display if the validation fails. If not provided, a default error message will be used.
     - Returns: The `RuleForBuilder` instance to allow method chaining for further rule definitions.

     Example usage:
     ```
     let validator = Validator<User>()
     .ruleFor(.email)
     .length(5, 10, errorMessage: "Email must be between 5 and 10 characters.")
     .ruleFor(.name)
     .length(0, 50) // Uses the default error message.
     ```
     - Note: If the `errorMessage` is not provided, a default error message will be used in the format: "The length of ‘\(keyPath.propertyName)’ must be between `min` and `max` characters.". The actual property name and `min`/`max` values will be dynamically inserted into the error message.
     */
    func length(
        _ min: Int,
        _ max: Int,
        errorMessage: String? = nil
    ) -> RuleForBuilder<Model, Value> {
        buildLength(min, max: max, errorMessage: errorMessage)
        return self
    }

    /**
     Adds a validation rule to check if the length of the property value falls within the specified range.

     - Parameter min: The minimum length allowed for the property value.
     - Parameter max: The maximum length allowed for the property value.
     - Parameter errorMessage: The error message to display if the validation fails. If not provided, a default error message will be used.
     - Returns: The `Validator` instance to allow further rule definitions for different properties.

     Example usage:
     ```
     let validator = Validator<User>()
     .ruleFor(.email)
     .length(5, 10, errorMessage: "Email must be between 5 and 10 characters.")
     .ruleFor(.name)
     .length(0, 50) // Uses the default error message.
     ```
     - Note: If the `errorMessage` is not provided, a default error message will be used in the format: "The length of ‘\(keyPath.propertyName)’ must be between `min` and `max` characters.". The actual property name and `min`/`max` values will be dynamically inserted into the error message.
     */
    func length(
        _ min: Int,
        _ max: Int,
        errorMessage: String? = nil
    ) -> Validator<Model> {
        buildLength(min, max: max, errorMessage: errorMessage)
        return validator
    }

    fileprivate func buildLength(_ min: Int, max: Int, errorMessage: String?) {
        let error = errorMessage ?? "The length of ‘\(keyPath.propertyName)’ must be between \(min) and \(max) characters."

        let rule = ValidationRule<Model>(errorMessage: {error}) { model in
            let value = model[keyPath: keyPath]
            return value.count >= min && value.count <= max
        }

        validator.addRule(rule)
    }
}

// MARK: - email

public extension RuleForBuilder where Value == String {
    func email(errorMessage: String? = nil) -> RuleForBuilder<Model, Value> {
        buildEmail(errorMessage: errorMessage)
        return self
    }

    func email(errorMessage: String? = nil) -> Validator<Model> {
        buildEmail(errorMessage: errorMessage)
        return validator
    }

    fileprivate func buildEmail(errorMessage: String?) {
        let defaultMessage = errorMessage ??
        "'\(keyPath.propertyName)' is not a valid email address."

        let rule = ValidationRule<Model>(errorMessage:{defaultMessage}) { model in
            let value = model[keyPath: keyPath]
            return validateEmail(value)
        }

        validator.addRule(rule)
    }

    private func validateEmail(_ email: String, regex: String? = nil) -> Bool {
        let emailRegex = regex ?? "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)

        return emailPredicate.evaluate(with: email)
    }
}
