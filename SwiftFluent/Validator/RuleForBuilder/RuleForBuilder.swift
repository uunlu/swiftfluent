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

    init(keyPath: KeyPath<Model, Value>, validator: Validator<Model>) {
        self.keyPath = keyPath
        self.validator = validator
    }

    public func build() -> Validator<Model> {
        return validator
    }

    public func validate(_ errorMessage: String = "", condition: @escaping (Value) -> Bool) -> RuleForBuilder<Model, Value> {
        let rule = ValidationRule<Model>(errorMessage: {(keyPath.propertyName, errorMessage)}) { model in
            let value = model[keyPath: keyPath]
            return condition(value)
        }

        validator.addRule(rule)
        return self
    }
}

