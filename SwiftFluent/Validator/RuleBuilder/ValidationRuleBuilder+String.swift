//
//  ValidationRuleBuilder+String.swift
//  SwiftFluent
//
//  Created by Ugur Unlu on 01/08/2023.
//

import Foundation

// MARK: - length

public extension ValidationRuleBuilder where Value == String {
    /**
     Adds a validation rule to check if the value of the property falls within the specified closed range.

     - Parameter range: The closed range within which the property value should lie.
     - Parameter errorMessage: The error message to display if the validation fails. If not provided, a default error message will be used.
     - Returns: The `ValidationRuleBuilder` instance to allow method chaining for further rule definitions.

     Example usage:
     let validator = Validator<User>()
     .ruleFor(.age)
     .range(18...65, errorMessage: "Age must be between 18 and 65.")
     .ruleFor(.experience)
     .range(0...20) // Uses the default error message.
     */
    func range(_ range: ClosedRange<Int>, errorMessage: String? = nil) -> ValidationRuleBuilder<Model, Value> {
        buildLength(range.lowerBound, max: range.upperBound, errorMessage: errorMessage)
        return self
    }

    /**
     Adds a validation rule to check if the value of the property falls within the specified closed range.

     - Parameter range: The closed range within which the property value should lie.
     - Parameter errorMessage: The error message to display if the validation fails. If not provided, a default error message will be used.
     - Returns: The `Validator` instance to allow further rule definitions for different properties.

     Example usage:
     let validator = Validator<User>()
     .ruleFor(.age)
     .range(18...65, errorMessage: "Age must be between 18 and 65.")
     .ruleFor(.experience)
     .range(0...20) // Uses the default error message.
     */
    func range(_ range: ClosedRange<Int>, errorMessage: String? = nil) -> Validator<Model> {
        buildLength(range.lowerBound, max: range.upperBound, errorMessage: errorMessage)
        return validator
    }

    /**
     Adds a validation rule to check if the length of the property value falls within the specified range.

     - Parameter min: The minimum length allowed for the property value.
     - Parameter max: The maximum length allowed for the property value.
     - Parameter errorMessage: The error message to display if the validation fails. If not provided, a default error message will be used.
     - Returns: The `ValidationRuleBuilder` instance to allow method chaining for further rule definitions.

     Example usage:
     ```
     let validator = Validator<User>()
     .ruleFor(\.email)
     .length(5, 10, errorMessage: "Email must be between 5 and 10 characters.")
     .ruleFor(\.name)
     .length(0, 50) // Uses the default error message.
     ```
     - Note: If the `errorMessage` is not provided, a default error message will be used in the format: "The length of ‘\(keyPath.propertyName)’ must be between `min` and `max` characters.". The actual property name and `min`/`max` values will be dynamically inserted into the error message.
     */
    func length(
        _ min: Int,
        _ max: Int,
        errorMessage: String? = nil
    ) -> ValidationRuleBuilder<Model, Value> {
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
     .ruleFor(\.email)
     .length(5, 10, errorMessage: "Email must be between 5 and 10 characters.")
     .ruleFor(\.name)
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

    private func buildLength(_ min: Int, max: Int, errorMessage: String?) {
        let errorMessage = errorMessage ?? ErrorMessage.lengthError(name: keyPath.propertyName, min: min, max: max).errorDescription
        let error = (keyPath.propertyName, errorMessage)

        let rule = ValidationRule<Model>(errorMessage: {error}) { model in
            let value = model[keyPath: keyPath]
            return value.count >= min && value.count <= max
        }

        validator.addRule(rule)
    }
}

// MARK: - maxLength

public extension ValidationRuleBuilder where Value == String {

    /**
     Adds a validation rule to check if the length of the property value is less than or equal to the specified `max` length.

     - Parameter max: The maximum allowed length for the property value.
     - Parameter errorMessage: The error message to display if the validation fails. If not provided, a default error message will be used.
     - Returns: The `ValidationRuleBuilder` instance to allow method chaining for further rule definitions.

     Example usage:
     ```
     let validator = Validator<User>()
     .ruleFor(\.name)
     .maxLength(30, errorMessage: "Name must be 30 characters or less.")
     .ruleFor(\.address)
     .maxLength(100) // Uses the default error message.
     ```
     - Note: If the `errorMessage` is not provided, a default error message will be used in the format: "‘\(keyPath.propertyName)’ must be \(max) characters or fewer.". The actual property name and `max` will be dynamically inserted into the error message.
     */
    func maxLength(
        _ max: Int,
        errorMessage: String? = nil
    ) -> ValidationRuleBuilder<Model, Value> {
        buildMaxLength(max, errorMessage: errorMessage)
        return self
    }

    /**
     Adds a validation rule to check if the length of the property value is less than or equal to the specified `max` length.

     - Parameter max: The maximum allowed length for the property value.
     - Parameter errorMessage: The error message to display if the validation fails. If not provided, a default error message will be used.
     - Returns: The `Validator` instance to allow further rule definitions for different properties.

     Example usage:
     ```
     let validator = Validator<User>()
     .ruleFor(\.name)
     .maxLength(30, errorMessage: "Name must be 30 characters or less.")
     .ruleFor(\.address)
     .maxLength(100) // Uses the default error message.
     ```
     - Note: If the `errorMessage` is not provided, a default error message will be used in the format: "‘\(keyPath.propertyName)’ must be \(max) characters or fewer.". The actual property name and `max` will be dynamically inserted into the error message.
     */
    func maxLength(
        _ max: Int,
        errorMessage: String? = nil
    ) -> Validator<Model> {
        buildMaxLength(max, errorMessage: errorMessage)
        return validator
    }

    private func buildMaxLength(_ max: Int, errorMessage: String?) {
        let errorMessage = errorMessage ?? ErrorMessage.maxLengthError(name: keyPath.propertyName, max: max).errorDescription
        let error = (keyPath.propertyName, errorMessage)

        let rule = ValidationRule<Model>(errorMessage: {error}) { model in
            let value = model[keyPath: keyPath]
            return value.count <= max
        }

        validator.addRule(rule)
    }
}

// MARK: - minLength

public extension ValidationRuleBuilder where Value == String {

    /**
     Adds a validation rule to check if the value of the property has a minimum length of `min`.

     - Parameter min: The minimum length allowed for the property.
     - Parameter errorMessage: The error message to display if the validation fails. If not provided, a default error message will be used.
     - Returns: The `ValidationRuleBuilder` instance to allow method chaining for further rule definitions.

     Example usage:
     ```
     let validator = Validator<User>()
     .ruleFor(\.name)
     .minLength(5, errorMessage: "Name must have at least 5 characters.")
     .ruleFor(\.email)
     .minLength(8) // Uses the default error message.
     ```
     - Note: If the `errorMessage` is not provided, a default error message will be used in the format: "‘\(keyPath.propertyName)’ must have at least \(min) characters.".
     */
    func minLength(
        _ min: Int,
        errorMessage: String? = nil
    ) -> ValidationRuleBuilder<Model, Value> {
        buildMinLength(min, errorMessage: errorMessage)
        return self
    }

    /**
     Adds a validation rule to check if the value of the property has a minimum length of `min`.

     - Parameter min: The minimum length allowed for the property.
     - Parameter errorMessage: The error message to display if the validation fails. If not provided, a default error message will be used.
     - Returns: The `Validator` instance to allow further rule definitions for different properties.

     Example usage:
     ```
     let validator = Validator<User>()
     .ruleFor(\.name)
     .minLength(5, errorMessage: "Name must have at least 5 characters.")
     .ruleFor(\.email)
     .minLength(8) // Uses the default error message.
     ```
     - Note: If the `errorMessage` is not provided, a default error message will be used in the format: "‘\(keyPath.propertyName)’ must have at least \(min) characters.".
     */
    func minLength(
        _ min: Int,
        errorMessage: String? = nil
    ) -> Validator<Model> {
        buildMinLength(min, errorMessage: errorMessage)
        return validator
    }

    private func buildMinLength(_ min: Int, errorMessage: String?) {
        let errorMessage = errorMessage ?? ErrorMessage.minLengthError(name: keyPath.propertyName, min: min).errorDescription
        let error = (keyPath.propertyName, errorMessage)

        let rule = ValidationRule<Model>(errorMessage: {error}) { model in
            let value = model[keyPath: keyPath]
            return value.count >= min
        }

        validator.addRule(rule)
    }
}

// MARK: - email

public extension ValidationRuleBuilder where Value == String {

    /**
     Adds an email validation rule to the builder for the specified property.

     - Parameter customRegex: An optional regular expression to customize email validation.
     - Parameter errorMessage: An optional custom error message to display if validation fails.
     - Returns: The `ValidationRuleBuilder` instance with the email validation rule added.

     Example usage:
     ```
     let validator = Validator<User>()
     .ruleFor(\.email)
     .email(errorMessage: "Invalid email format.")
     .ruleFor(\.name)
     .email() // Uses the default error message.
     ```
     - Note: If the `errorMessage` is not provided, a default error message will be used in the format: "‘\(keyPath.propertyName)’ is not a valid email address.". The actual property name will be dynamically inserted into the error message.
     */
    func email(_ customRegex: String? = nil, errorMessage: String? = nil) -> ValidationRuleBuilder<Model, Value> {
        buildEmail(customRegex, errorMessage: errorMessage)
        return self
    }

    /**
     Adds an email validation rule to the validator for the specified property.

     - Parameter customRegex: An optional regular expression to customize email validation.
     - Parameter errorMessage: An optional custom error message to display if validation fails.
     - Returns: The `Validator` instance with the email validation rule added.

     Example usage:
     ```
     let validator = Validator<User>()
     .ruleFor(\.email)
     .email(errorMessage: "Invalid email format.")
     .ruleFor(\.name)
     .email() // Uses the default error message.
     ```
     - Note: If the `errorMessage` is not provided, a default error message will be used in the format: "‘\(keyPath.propertyName)’ is not a valid email address.". The actual property name will be dynamically inserted into the error message.
     */
    func email(customRegex: String? = nil, errorMessage: String? = nil) -> Validator<Model> {
        buildEmail(customRegex, errorMessage: errorMessage)
        return validator
    }

    private func buildEmail(_ customRegex: String?, errorMessage: String?) {
        let errorMessage = errorMessage ?? ErrorMessage.emailError(name: keyPath.propertyName).errorDescription
        let error = (keyPath.propertyName, errorMessage)

        let rule = ValidationRule<Model>(errorMessage: {error}) { model in
            let value = model[keyPath: keyPath]
            return value.isValidEmail(customRegex: customRegex)
        }

        validator.addRule(rule)
    }
}

// MARK: - creditCard

public extension ValidationRuleBuilder where Value == String {

    /**
     Adds a validation rule to check if the value of the property is a valid credit card number.

     - Parameter errorMessage: The error message to display if the validation fails. If not provided, a default error message will be used.
     - Returns: The `ValidationRuleBuilder` instance to allow method chaining for further rule definitions.

     Example usage:
     let validator = Validator<User>()
     .ruleFor(\.creditCardNumber)
     .creditCard(errorMessage: "Invalid credit card number.")
     .ruleFor(\.name)
     .creditCard() // Uses the default error message.
     - Note: If the `errorMessage` is not provided, a default error message will be used in the format: "‘\(keyPath.propertyName)’ is not a valid credit card number." where `keyPath.propertyName` represents the name of the property being validated.
     */
    func creditCard(_ errorMessage: String? = nil) -> ValidationRuleBuilder<Model, Value> {
        buildCreditCard(errorMessage)
        return self
    }

    /**
     Adds a validation rule to check if the value of the property is a valid credit card number.

     - Parameter errorMessage: The error message to display if the validation fails. If not provided, a default error message will be used.
     - Returns: The `Validator` instance to allow further rule definitions for different properties.

     Example usage:
     ```
     let validator = Validator<User>()
     .ruleFor(\.creditCardNumber)
     .creditCard(errorMessage: "Invalid credit card number.")
     .build()
     ```
     - Note: If the `errorMessage` is not provided, a default error message will be used in the format: "‘creditCardNumber’ is not a valid credit card number.".
     */
    func creditCard(_ errorMessage: String? = nil) -> Validator<Model> {
        buildCreditCard(errorMessage)
        return validator
    }

    private func buildCreditCard(_ errorMessage: String?) {
        let errorMessage = errorMessage ?? ErrorMessage.creditCardError(name: keyPath.propertyName).errorDescription
        let error = (keyPath.propertyName, errorMessage)

        let rule = ValidationRule<Model>(errorMessage: {error}) { model in
            let value = model[keyPath: keyPath]
            return CreditCardValidator.isValid(value)
        }

        validator.addRule(rule)
    }
}

// MARK: - number

public extension ValidationRuleBuilder where Value == String {

    /**
     Adds a validation rule to check if the value of the property is a valid number.

     - Parameter errorMessage: The error message to display if the validation fails. If not provided, a default error message will be used.
     - Returns: The `ValidationRuleBuilder` instance to allow method chaining for further rule definitions.

     Example usage:
     ```
     let validator = Validator<User>()
     .ruleFor(\.age)
     .number(errorMessage: "Age must be a valid number.")
     .ruleFor(\.salary)
     .number() // Uses the default error message.
     ```
     - Note: If the `errorMessage` is not provided, a default error message will be used in the format: "‘\(keyPath.propertyName)’ must be a valid number." where `keyPath.propertyName` represents the name of the property being validated.
     */
    func number(
        errorMessage: String? = nil
    ) -> ValidationRuleBuilder<Model, Value> {
        buildNumber(errorMessage: errorMessage)
        return self
    }

    /**
     Adds a validation rule to check if the value of the property is a valid number.

     - Parameter errorMessage: The error message to display if the validation fails. If not provided, a default error message will be used.
     - Returns: The `Validator` instance to allow further rule definitions for different properties.

     Example usage:
     ```
     let validator = Validator<User>()
     .ruleFor(\.age)
     .number(errorMessage: "Age must be a valid number.")
     .ruleFor(\.salary)
     .number() // Uses the default error message.
     ```
     - Note: If the `errorMessage` is not provided, a default error message will be used in the format: "‘\(keyPath.propertyName)’ must be a valid number." where `keyPath.propertyName` represents the name of the property being validated.
     */
    func number(
        errorMessage: String? = nil
    ) -> Validator<Model> {
        buildNumber(errorMessage: errorMessage)
        return validator
    }

    private func buildNumber(errorMessage: String?) {
        let errorMessage = errorMessage ?? ErrorMessage.numberError(name: keyPath.propertyName).errorDescription
        let error = (keyPath.propertyName, errorMessage)

        let rule = ValidationRule<Model>(errorMessage: {error}) { model in
            let value = model[keyPath: keyPath]
            return value.isNumber()
        }

        validator.addRule(rule)
    }
}

// MARK: - url

public extension ValidationRuleBuilder where Value: OptionalType, Value.Wrapped == String {
    /**
     Creates a validation rule builder for validating URLs.

     - Parameters:
     - errorMessage: An optional error message to be associated with this validation rule.

     - Returns: A `ValidationRuleBuilder` instance configured for building URL validation rules.
     */
    func url(
        errorMessage: String? = nil
    ) -> ValidationRuleBuilder<Model, Value> {
        buildURL(errorMessage: errorMessage)
        return self
    }

    /**
     Creates a validator for URL validation, allowing validation of a specific property as a URL.

     - Parameters:
     - errorMessage: An optional error message to be associated with this validation.

     - Returns: A `Validator` instance configured for validating URL properties.
     */
    func url(
        errorMessage: String? = nil
    ) -> Validator<Model> {
        buildURL(errorMessage: errorMessage)
        return validator
    }

    private func buildURL(errorMessage: String?) {
        let errorMessage = errorMessage ?? ErrorMessage.urlError(name: keyPath.propertyName).errorDescription
        let error = (keyPath.propertyName, errorMessage)
        let rule = ValidationRule<Model>(errorMessage: {error}) { model in
            let value = model[keyPath: keyPath]
            guard let urlString = value as? String else { return false }
            if URL(string: urlString) == nil {
                return false
            }
            return true
        }

        validator.addRule(rule)
    }
}

public extension ValidationRuleBuilder where Value == String {
    /**
     Creates a validation rule builder for validating URLs.

     - Parameters:
     - errorMessage: An optional error message to be associated with this validation rule.

     - Returns: A `ValidationRuleBuilder` instance configured for building URL validation rules.
     */
    func url(
        errorMessage: String? = nil
    ) -> ValidationRuleBuilder<Model, Value> {
        buildURL(errorMessage: errorMessage)
        return self
    }

    /**
     Creates a validator for URL validation, allowing validation of a specific property as a URL.

     - Parameters:
     - errorMessage: An optional error message to be associated with this validation.

     - Returns: A `Validator` instance configured for validating URL properties.
     */
    func url(
        errorMessage: String? = nil
    ) -> Validator<Model> {
        buildURL(errorMessage: errorMessage)
        return validator
    }

    private func buildURL(errorMessage: String?) {
        let errorMessage = errorMessage ?? ErrorMessage.urlError(name: keyPath.propertyName).errorDescription
        let error = (keyPath.propertyName, errorMessage)
        let rule = ValidationRule<Model>(errorMessage: {error}) { model in
            let value = model[keyPath: keyPath]
            if URL(string: value) == nil {
                return false
            }
            return true
        }

        validator.addRule(rule)
    }
}
