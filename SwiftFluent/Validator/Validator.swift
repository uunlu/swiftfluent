//
//  Validator.swift
//  SwiftFluent
//
//  Created by Ugur Unlu on 31/07/2023.
//

import Foundation

public struct ValidationRule<Model> {
    public let errorMessage: String
    public let isValid: (Model) -> Bool
}

public enum ValidationResult {
    case valid
    case invalid(errors: [String])

    public var isValid: Bool {
        if case .valid = self {
            return true
        }
        return false
    }
}

public class Validator<Model> {
    private var validationRules: [ValidationRule<Model>] = []
    private(set) public var validationErrors: [String] = []

    public init() { }

    public init(validationRules: [ValidationRule<Model>]) {
        self.validationRules = validationRules
    }

    func addRule(_ rule: ValidationRule<Model>) {
        validationRules.append(rule)
    }

    public func validate(_ model: Model) -> ValidationResult {
        let invalidErrors = validationRules
            .filter { !$0.isValid(model) }
            .map { $0.errorMessage }

        validationErrors = invalidErrors

        return invalidErrors.isEmpty ? .valid : .invalid(errors: invalidErrors)
    }
}

extension Validator {
    /**
    Adds a validation rule to the Validator for the specified condition.

    Use this method to add a custom validation rule to the Validator. The `condition` closure takes a `Model` as input and returns a `Bool`, indicating whether the validation rule is satisfied or not. If the `condition` returns `true`, the validation passes; otherwise, it fails.

    - Parameter condition: A closure that defines the validation rule. It takes a `Model` as input and returns a `Bool` indicating whether the validation rule is satisfied.
    - Parameter errorMessage: The error message to display if the validation fails.
    - Returns: The Validator instance with the new validation rule added.

    Example usage:
     ```
     let validator = Validator<String>()
     .validate({ !$0.isEmpty }, errorMessage: "Input should not be an empty string.")
     ```
     - Note: The `@discardableResult` attribute allows ignoring the return value if desired. However, it is recommended to capture the returned Validator instance to ensure all validation rules are added.
     */
    @discardableResult
    public func validate(_ condition: @escaping (Model) -> Bool, errorMessage: String) -> Validator<Model> {
        let rule = ValidationRule<Model>(
            errorMessage: errorMessage,
            isValid: condition
        )
        addRule(rule)
        return self
    }

    // Add more validate() methods for other property types like String, Int, etc.
}

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
