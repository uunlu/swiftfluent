//
//  Validator+RuleFor.swift
//  LoginBuddyUIKit
//
//  Created by Ugur Unlu on 01/08/2023.
//

import Foundation

extension Validator {
    @discardableResult
    public func ruleFor<Value>(_ keyPath: KeyPath<Model, Value>, length range: ClosedRange<Int>, errorMessage: String) -> Validator<Model> where Value == String {
        var rule = ValidationRule<Model>(errorMessage: "") { model in
            let value = model[keyPath: keyPath]
            return range.contains(value.count)
        }
        rule.errorMessage = errorMessage
        addRule(rule)
        return self
    }

    @discardableResult
    public func ruleFor<Value>(_ keyPath: KeyPath<Model, Value>, maxLength length: Int, errorMessage: String) -> Validator<Model> where Value == String {
        self.ruleFor(keyPath, maxLength: length, errorMessage: errorMessage, isValid: length)
        var rule = ValidationRule<Model>(errorMessage: "") { model in
            let value = model[keyPath: keyPath]
            return value.count < length
        }
        rule.errorMessage = errorMessage
        addRule(rule)
        return self
    }

    @discardableResult
    public func ruleFor<Value>(_ keyPath: KeyPath<Model, Value>, maxLength length: Int, errorMessage: String, isValid: @escaping (Model) -> Bool) -> Validator<Model> where Value == String {
        let rule = ValidationRule<Model> { model in
            return isValid(model)
        }
        rule.errorMessage = errorMessage
        addRule(rule)
        return self
    }

}
