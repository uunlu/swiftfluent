//
//  Validator+String.swift
//  SwiftFluent
//
//  Created by Ugur Unlu on 31/07/2023.
//

import Foundation

// MARK: - Validator `String` extensions

extension Validator where Model == String {
    /**
     Adds an email validation rule to the Validator.

     Use this method to add an email validation rule to the Validator. The `email` function checks if the input `Model` contains a valid email address by invoking the `isValidEmail()` function on it.

     - Parameter errorMessage: The error message to display if the email validation fails.
     - Returns: The Validator instance with the new email validation rule added.
     */
    @discardableResult
    public func email(customRegex: String? = nil, errorMessage: String? = nil) -> Validator<Model> {
        let errorMessage = errorMessage ?? ErrorMessage.emailError(name: String(describing: Model.self)).errorDescription
        let rule = ValidationRule<Model>(
            errorMessage: {(String(describing: Model.self), errorMessage)},
            isValid: { $0.isValidEmail(customRegex: customRegex) }
        )
        addRule(rule)
        return self
    }

    /**
     Adds a credit card validation rule to the Validator.

     Use this method to add a credit card validation rule to the Validator. The `creditCard` function checks if the credit card number, represented by the input `Model`, is valid according to the Luhn algorithm using the `CreditCardValidator.isValid(_:)` function.

     - Parameter errorMessage: The error message to display if the credit card validation fails.
     - Returns: The Validator instance with the new credit card validation rule added.

     Example usage:
     ```swift
     let validator = Validator<String>()
     .creditCard(errorMessage: "Invalid credit card number.")
     ```
     - Note: The `@discardableResult` attribute allows ignoring the return value if desired. However, it is recommended to capture the returned Validator instance to ensure all validation rules are added.
     */
    @discardableResult
    public func creditCard(errorMessage: String? = nil) -> Validator<Model> {
        let errorMessage = errorMessage ?? ErrorMessage.creditCardError(name: String(describing: Model.self)).errorDescription
        let rule = ValidationRule<Model>(
            errorMessage: {(String(describing: Model.self), errorMessage)},
            isValid: { CreditCardValidator.isValid($0) }
        )
        addRule(rule)
        return self
    }

    @discardableResult
    public func number(errorMessage: String? = nil) -> Validator<Model> {
        let errorMessage = errorMessage ?? ErrorMessage.numberError(name: String(describing: Model.self)).errorDescription
        let rule = ValidationRule<Model>(
            errorMessage: {(String(describing: Model.self), errorMessage)},
            isValid: { $0.isNumber() }
        )
        addRule(rule)
        return self
    }

    /**
     Adds a validation rule to the Validator to check if the string is not empty or contains only white space.

     Use this method to add a validation rule that ensures the input string is not empty and does not consist of only white space characters (e.g., spaces, tabs, newlines).

     - Parameter errorMessage: The error message to display if the validation fails.
     - Returns: The Validator instance with the new validation rule added.

     Example usage:

     The above example creates a `Validator` instance for validating a `String` input. It adds a validation rule using the `notEmpty` method, which checks if the input string is not empty and contains at least one non-white space character. If the input is empty or consists of only white space, the validation fails, and the provided error message will be displayed.

     - Note: The `@discardableResult` attribute allows ignoring the return value if desired. However, it is recommended to capture the returned Validator instance to ensure all validation rules are added.
     */
    @discardableResult
    public func notEmpty(errorMessage: String? = nil) -> Validator<Model> {
        let errorMessage = errorMessage ?? ErrorMessage.notEmptyError(name: String(describing: Model.self)).errorDescription
        let rule = ValidationRule<Model>(
            errorMessage: {(String(describing: Model.self), errorMessage)},
            isValid: { $0.isNotEmpty() }
        )
        addRule(rule)
        return self
    }

    /**
     Extends the Validator type with a method to perform length-based validation on the given model type.

     - Parameters:
     - min: The minimum allowable length of the model's value.
     - max: The maximum allowable length of the model's value.
     - errorMessage: The error message to display if the validation fails.

     - Returns: An instance of the Validator with the new length-based validation rule added.

     - Note: The `@discardableResult` attribute allows the user to ignore the return value of this method if they choose to do so.

     - Remark: This method checks the length of the model's value against the specified `min` and `max` values (inclusive on the minimum end and exclusive on the maximum end). The validation will pass if the length of the model's value is greater than or equal to `min` and less than `max`.
     */
    @discardableResult
    public func length(_ min: Int, _ max: Int, errorMessage: String? = nil) -> Validator<Model> {
        let errorMessage = errorMessage ?? ErrorMessage.lengthError(name: String(describing: Model.self), min: min, max: max).errorDescription
        let rule = ValidationRule<Model>(
            errorMessage: {(String(describing: Model.self), errorMessage)},
            isValid: { $0.count >= min && $0.count < max }
        )
        addRule(rule)
        return self
    }

    /**
     Extends the Validator type with a method to perform minimum length validation on the given model type.

     - Parameters:
     - min: The minimum allowable length of the model's value.
     - errorMessage: The error message to display if the validation fails.

     - Returns: An instance of the Validator with the new minimum length validation rule added.

     - Note: The `@discardableResult` attribute allows the user to ignore the return value of this method if they choose to do so.

     - Remark: This method checks the length of the model's value against the specified `min` value. The validation will pass if the length of the model's value is greater than or equal to `min`.
     */
    @discardableResult
    public func minLength(_ length: Int, errorMessage: String? = nil) -> Validator<Model> {
        let errorMessage = errorMessage ?? ErrorMessage.minLengthError(name: String(describing: Model.self), min: length).errorDescription
        let rule = ValidationRule<Model>(
            errorMessage: {(String(describing: Model.self), errorMessage)},
            isValid: { $0.count >= length }
        )
        addRule(rule)
        return self
    }

    /**
     Extends the Validator type with a method to perform maximum length validation on the given model type.

     - Parameters:
     - length: The maximum allowable length of the model's value.
     - errorMessage: The error message to display if the validation fails.

     - Returns: An instance of the Validator with the new maximum length validation rule added.

     - Note: The `@discardableResult` attribute allows the user to ignore the return value of this method if they choose to do so.

     - Remark: This method checks the length of the model's value against the specified `length` value. The validation will pass if the length of the model's value is less than or equal to `length`.
     */
    @discardableResult
    public func  maxLength(_ length: Int, errorMessage: String? = nil) -> Validator<Model> {
        let errorMessage = errorMessage ?? ErrorMessage.maxLengthError(name: String(describing: Model.self), max: length).errorDescription
        let rule = ValidationRule<Model>(
            errorMessage: {(String(describing: Model.self), errorMessage)},
            isValid: { $0.count <= length }
        )
        addRule(rule)
        return self
    }
}
