//
//  RuleForBuilder+Comparable.swift
//  SwiftFluent
//
//  Created by Ugur Unlu on 01/08/2023.
//

import Foundation

public extension RuleForBuilder where Value: Comparable {
    func lessThan(_ value: Value, errorMessage: String? = nil) -> RuleForBuilder<Model, Value> {
        let error = errorMessage ?? "‘\(keyPath.propertyName)’ must be less than \(value)."
        let rule = ValidationRule<Model>(errorMessage: {error}) { model in
            let propertyValue = model[keyPath: keyPath]
            return propertyValue < value
        }


        validator.addRule(rule)
        return self
    }
}
