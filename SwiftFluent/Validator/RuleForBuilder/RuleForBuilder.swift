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
    func length(_ min: Int, _ max: Int) -> RuleForBuilder<Model, Value> where Value == String {
        let rule = ValidationRule<Model> { model in
            let value = model[keyPath: keyPath]
            return value.count >= min && value.count <= max
        }

        let defaultMessage = "The length of ‘\(keyPath.propertyName)’ must be between \(min) and \(max) characters."
        validator.addRule(ValidationRule(errorMessage: { defaultMessage }, isValid: rule.isValid))
        return self
    }

    class ErrorMessage {
        var message: String

        init(_ message: String) {
            self.message = message
        }
    }

    func email(errorMessage: String = "") -> RuleForBuilder<Model, Value> where Value == String {
        let defaultMessage = errorMessage.isEmpty ?
        "'\(keyPath.propertyName)' is not a valid email address."
        :
        errorMessage
        
        var rule = ValidationRule<Model>(errorMessage: {defaultMessage}) { model in
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            let value = model[keyPath: keyPath]

            return emailPredicate.evaluate(with: value)
        }

//        let defaultMessage = "'\(keyPath.propertyName)' is not a valid email address."

        validator.addRule(rule)
        return self
    }

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
