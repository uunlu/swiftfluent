//
//  Validator.swift
//  SwiftFluent
//
//  Created by Ugur Unlu on 31/07/2023.
//

import Foundation

struct ValidationRule<Model> {
    var errorMessage: () -> (String, String)
    let isValid: (Model) -> Bool

    init(errorMessage: @escaping () -> (String, String), isValid: @escaping (Model) -> Bool) {
        self.errorMessage = errorMessage
        self.isValid = isValid
    }

    init(isValid: @escaping (Model) -> Bool) {
        self.errorMessage = { ("", "") }
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
    private(set) public var validationsMap: [String: [String]] = [:]

    public init() { }

    func addRule(_ rule: ValidationRule<Model>) {
        validationRules.append(rule)
    }

    public func validate(_ model: Model) -> ValidationResult {
        let invalidErrors = validationRules
            .filter { !$0.isValid(model) }
            .compactMap { $0.errorMessage } // Filter out nil errorMessage
            .map { errorMessage -> (String, String) in // Use a default message if errorMessage is nil
                if !errorMessage().1.isEmpty {
                    return errorMessage()
                } else {
                    return ("", "Validation failed.")
                }
            }

        validationErrors = invalidErrors.map { $0.1}

        for (propertyKey, errorMessage) in invalidErrors {
            if var errors = validationsMap[propertyKey] {
                errors.append(errorMessage)
                validationsMap[propertyKey] = errors
            } else {
                validationsMap[propertyKey] = [errorMessage]
            }
        }

        return invalidErrors.isEmpty ? .valid : .invalid(errors: invalidErrors.map { $0.1})
    }

    public func errorFor<Value>(keyPath: KeyPath<Model, Value>) -> [String]? {
        validationsMap[keyPath.propertyName]
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
    public func validate(_ condition: @escaping (Model) -> Bool, errorMessage: String? = nil) -> Validator<Model> {
        let error = errorMessage ?? "Validation failed."
        let rule = ValidationRule<Model>(
            errorMessage: { (String(describing: Model.self), error) },
            isValid: condition
        )
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
