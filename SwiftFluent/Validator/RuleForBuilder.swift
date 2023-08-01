//
//  RuleForBuilder.swift
//  SwiftFluent
//
//  Created by Ugur Unlu on 01/08/2023.
//

import Foundation

public struct RuleForBuilder<Model, Value> {
    private let keyPath: KeyPath<Model, Value>
    private let validator: Validator<Model>

    init(keyPath: KeyPath<Model, Value>, validator: Validator<Model>) {
        self.keyPath = keyPath
        self.validator = validator
    }

    @discardableResult
    public func length(
        _ min: Int,
        _ max: Int,
        errorMessage: String = ""
    ) -> Validator<Model> where Value == String {
        var userInputLength = 0
        var rule = ValidationRule<Model> { model in
            let value = model[keyPath: keyPath]
            userInputLength = value.count
            self.validator.addError(errorMessage)
            return userInputLength >= min && userInputLength < max
        }

        if errorMessage.isEmpty {
            rule.errorMessage = "The length of ‘\(Value.self)’ must be \(min) to \(max) characters."
               } else {
                   rule.errorMessage = errorMessage
               }
        validator.addRule(rule)
        return validator
    }
}
