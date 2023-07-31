//
//  Validator+String.swift
//  SwiftFluent
//
//  Created by Ugur Unlu on 31/07/2023.
//

import Foundation

// MARK: - Validator `String` extensions

extension Validator where Model == String{
    @discardableResult
    public func email(errorMessage: String) -> Validator<Model> {
        let rule = ValidationRule<Model>(
            errorMessage: errorMessage,
            isValid: { $0.isValidEmail() }
        )
        addRule(rule)
        return self
    }

    @discardableResult
    public func number(errorMessage: String) -> Validator<Model> {
        let rule = ValidationRule<Model>(
            errorMessage: errorMessage,
            isValid: { $0.containsOnlyNumbers() }
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
    public func notEmpty(errorMessage: String) -> Validator<Model> {
        let rule = ValidationRule<Model>(
            errorMessage: errorMessage,
            isValid: { $0.isNotEmpty() }
        )
        addRule(rule)
        return self
    }

    /**
     Adds a validation rule to the Validator to check if the string is not equal to a specific value.

     Use this method to add a validation rule that ensures the input string is not equal to the specified `string` value.

     - Parameter string: The string value to compare against.
     - Parameter errorMessage: The error message to display if the validation fails.
     - Returns: The Validator instance with the new validation rule added.

     Example usage:
     The above example creates a `Validator` instance for validating a `String` input. It adds a validation rule using the `notEqual(to:)` method, which checks if the input string is not equal to the provided `string` value. If the input matches the specified value, the validation fails, and the provided error message will be displayed.

     - Note: The `@discardableResult` attribute allows ignoring the return value if desired. However, it is recommended to capture the returned Validator instance to ensure all validation rules are added.
     */
    @discardableResult
    public func notEqual(to value: Model, errorMessage: String) -> Validator<Model> {
        let rule = ValidationRule<Model>(
            errorMessage: errorMessage,
            isValid: { !$0.elementsEqual(value) }
        )
        addRule(rule)
        return self
    }
}

// MARK: - String extensions

fileprivate extension String {
    func isValidEmail() -> Bool {
        // Regular expression pattern to match email addresses
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }

    func containsOnlyNumbers() -> Bool {
        let numbersSet = CharacterSet.decimalDigits
        return self.rangeOfCharacter(from: numbersSet.inverted) == nil
    }
}

fileprivate extension String {
    func isNotEmpty() -> Bool {
        self.isEmpty == false && self.trimmingCharacters(in: .whitespaces).isEmpty == false
    }
}
