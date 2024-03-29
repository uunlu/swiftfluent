//
//  ValidationRuleBuilder.swift
//  SwiftFluent
//
//  Created by Ugur Unlu on 01/08/2023.
//

import Foundation

public struct ValidationRuleBuilder<Model, Value> {
    let keyPath: KeyPath<Model, Value>
    let validator: Validator<Model>

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
    /// - Returns: The ValidationRuleBuilder instance with the validation rule added.
    public func validate(_ errorMessage: String? = nil, condition: @escaping (Value) -> Bool) -> ValidationRuleBuilder<Model, Value> {
        let errorMessage = errorMessage ?? ErrorMessage.defaultError.errorDescription
        let rule = ValidationRule<Model>(errorMessage: {(keyPath.propertyName, errorMessage)}) { model in
            let value = model[keyPath: keyPath]
            return condition(value)
        }
        validator.addRule(rule)
        return self
    }
}
