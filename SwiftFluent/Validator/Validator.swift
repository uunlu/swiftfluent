//
//  Validator.swift
//  SwiftFluent
//
//  Created by Ugur Unlu on 31/07/2023.
//

import Foundation

public struct ValidationRule<Model> {
    public var errorMessage: () -> String
    public let isValid: (Model) -> Bool

    init(errorMessage: @escaping () -> String, isValid: @escaping (Model) -> Bool) {
        self.errorMessage = errorMessage
        self.isValid = isValid
    }

    init(isValid: @escaping (Model) -> Bool) {
        self.errorMessage = { "" }
        self.isValid = isValid
    }
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

    func addError(_ error: String) {
        validationErrors.append(error)
    }

    public func validate(_ model: Model) -> ValidationResult {
        let invalidErrors = validationRules
                    .filter { !$0.isValid(model) }
                    .compactMap { $0.errorMessage } // Filter out nil errorMessage
                    .map { errorMessage -> String in // Use a default message if errorMessage is nil
                        if !errorMessage().isEmpty {
                            return errorMessage()
                        } else {
                            return "Validation failed."
                        }
                    }

                validationErrors = invalidErrors

                return invalidErrors.isEmpty ? .valid : .invalid(errors: invalidErrors)
    }
}

// MARK: - Custom validator extension

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
            isValid: condition
        )
        addRule(rule)
        return self
    }
}


extension Validator {
    @discardableResult
    public func ruleFor(_ keyPath: KeyPath<Model, String>, length range: ClosedRange<Int>, errorMessage: String) -> Validator<Model> {
        var message = errorMessage
        var validator = Validator<String>()
        let rule = ValidationRule<Model>(errorMessage: { message} ) { model in
            let value = model[keyPath: keyPath]
            if message.isEmpty {
                message = "‘\(value.self)’ must be between \(range.lowerBound) and \(range.upperBound) characters. You entered \(value.count) characters."
            }

            return validator
                .length(range.lowerBound, range.upperBound, errorMessage: message)
                .validate(value)
                .isValid
        }
        
        addRule(rule)
        return self
    }

    @discardableResult
    public func ruleFor(_ keyPath: KeyPath<Model, String>, maxLength length: Int, errorMessage: String = "") -> Validator<Model>{
        var message = errorMessage

        var rule = ValidationRule<Model>() { model in
            let value = model[keyPath: keyPath]
            if message.isEmpty {
                message = "The length of ‘\(value.self)’ must be \(length) characters or fewer. You entered \(value.count) characters."
            }
            return Validator<String>().maxLength(length, errorMessage: errorMessage).validate(value).isValid
        }
        rule.errorMessage = { message }
        addRule(rule)
        return self
    }
}

public extension Validator {
    @discardableResult
    func ruleFor<Value>(_ keyPath: KeyPath<Model, Value>) -> RuleForBuilder<Model, Value> {
        return RuleForBuilder(keyPath: keyPath, validator: self)
    }
}
