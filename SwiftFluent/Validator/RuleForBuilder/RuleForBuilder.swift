//
//  RuleForBuilder.swift
//  SwiftFluent
//
//  Created by Ugur Unlu on 01/08/2023.
//

import Foundation

public struct RuleForBuilder<Model, Value> {
    let keyPath: KeyPath<Model, Value>
    let validator: Validator<Model>

    enum ErrorMessage: Error, LocalizedError {
        case lengthError(name: String, min: Int, max: Int)
        case minLengthError(name: String, min: Int)
        case maxLengthError(name: String, max: Int)
        // Extension String
        case email(name: String)
        case creditCard(name: String)
        // Extension Comparable
        case lessThanError(name: String, max: String)
        case lessThanOrEqualToError(name: String, max: String)
        case greaterThanError(name: String, min: String)
        case greaterThanOrEqualToError(name: String, min: String)
        // Extension Collection
        case notEmptyError(name: String)
        // Extension Optional
        case notNilError(name: String)
        // Extension Equatable
        case equalError(name: String, value: String)
        case notEqualError(name: String, value: String)

        var errorDescription: String {
            switch self {
                case .lengthError(let name, let min, let max):
                    return NSLocalizedString("The length of ‘\(name)’ must be between \(min) and \(max) characters.", comment: "")
                case .minLengthError(let name, let min):
                    return NSLocalizedString("The length of ‘\(name)’ must be \(min) characters or more.", comment: "")
                case .maxLengthError(let name, let max):
                    return NSLocalizedString("The length of ‘\(name)’ must be \(max) characters or fewer.", comment: "")
                case .email(let name):
                    return NSLocalizedString("'\(name)' is not a valid email address.", comment: "")
                case .creditCard(let name):
                    return NSLocalizedString("‘\(name)‘ is not a valid credit card number.", comment: "")
                case .lessThanError(let name, let max):
                    return NSLocalizedString("‘\(name)’ must be less than \(max).", comment: "")
                case .lessThanOrEqualToError(let name, let max):
                    return NSLocalizedString("‘\(name)’ must be less than or equal to \(max).", comment: "")
                case .greaterThanError(let name, let min):
                    return NSLocalizedString("‘\(name)’ must be greater than \(min).", comment: "")
                case .greaterThanOrEqualToError(let name, let min):
                    return NSLocalizedString("‘\(name)’ must be greater than or equal to \(min).", comment: "")
                case .notEmptyError(let name):
                    return NSLocalizedString("‘\(name)’ should not be empty.", comment: "")
                case .notNilError(let name):
                    return NSLocalizedString("‘\(name)’ must not be nil.", comment: "")
                case .equalError(let name, let value):
                    return NSLocalizedString("‘\(name)’ should be equal to \(value).", comment: "")
                case .notEqualError(let name, let value):
                    return NSLocalizedString("‘\(name)’ should not be equal to \(value).", comment: "")

            }
        }
    }


    init(keyPath: KeyPath<Model, Value>, validator: Validator<Model>) {
        self.keyPath = keyPath
        self.validator = validator
    }

    @discardableResult
    public func build() -> Validator<Model> {
        return validator
    }

    /// Adds a validation rule to the builder for the specified property.
    ///
    /// - Parameters:
    ///   - errorMessage: The error message to display if the validation fails. If not provided, a default error message will be used.
    ///   - condition: The condition that must be satisfied for the validation to pass.
    /// - Returns: The RuleForBuilder instance with the validation rule added.
    public func validate(_ errorMessage: String, condition: @escaping (Value) -> Bool) -> RuleForBuilder<Model, Value> {
        let rule = ValidationRule<Model>(errorMessage: {(keyPath.propertyName, errorMessage)}) { model in
            let value = model[keyPath: keyPath]
            return condition(value)
        }
        validator.addRule(rule)
        return self
    }
}

