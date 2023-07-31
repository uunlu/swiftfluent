//
//  Validator.swift
//  SwiftFluent
//
//  Created by Ugur Unlu on 31/07/2023.
//

import Foundation

public struct ValidationRule<Model> {
    public let errorMessage: String
    public let isValid: (Model) -> Bool
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

    public init() { }

    public init(validationRules: [ValidationRule<Model>]) {
        self.validationRules = validationRules
    }

    func addRule(_ rule: ValidationRule<Model>) {
        validationRules.append(rule)
    }

    public func validate(_ model: Model) -> ValidationResult {
        let invalidErrors = validationRules
            .filter { !$0.isValid(model) }
            .map { $0.errorMessage }

        return invalidErrors.isEmpty ? .valid : .invalid(errors: invalidErrors)
    }
}

extension Validator {
    // Add more validate() methods for other property types like String, Int, etc.
    @discardableResult
    public func validate(_ condition: @escaping (Model) -> Bool, errorMessage: String) -> Validator<Model> {
        let rule = ValidationRule<Model>(
            errorMessage: errorMessage,
            isValid: condition
        )
        addRule(rule)
        return self
    }
}
