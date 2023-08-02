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
}


public extension RuleForBuilder {

    func creditCard(errorMessage: String = "") -> RuleForBuilder<Model, Value> where Value == String {
        let rule = ValidationRule<Model>() { model in
            let value = model[keyPath: keyPath]
            return CreditCardValidator.isValid(value)
        }

        let defaultMessage = "‘\(keyPath.propertyName)’ is not a valid credit card number."
        validator.addRule(ValidationRule(errorMessage: { defaultMessage }, isValid: rule.isValid))
        return self
    }

    func build() -> Validator<Model> {
        return validator
    }
}


extension String {
    var keyPathValue: String {
        String(self.split(separator: ".").last ?? "")
    }
}

extension KeyPath {
    var propertyName: String {
        String(describing: self).components(separatedBy: ".").last ?? "Unknown"
    }
}
