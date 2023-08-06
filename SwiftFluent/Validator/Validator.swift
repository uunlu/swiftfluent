//
//  Validator.swift
//  SwiftFluent
//
//  Created by Ugur Unlu on 31/07/2023.
//

import Foundation

public class Validator<Model> {
    private var validationRules: [ValidationRule<Model>] = []
    private(set) public var validationErrors: [String] = []
    private(set) public var validationErrorsMap: [String: [String]] = [:]

    let defaultErrorMessage = "Invalid result"

    public init() { }

    internal func addRule(_ rule: ValidationRule<Model>) {
        validationRules.append(rule)
    }

    @discardableResult
    public func validate(_ model: Model) -> ValidationResult {
        let invalidErrors = validationRules
            .filter { !$0.isValid(model) }
            .compactMap { $0.errorMessage } // Filter out nil errorMessage
            .map { errorMessage -> (String, String) in // Use a default message if errorMessage is nil
                if !errorMessage().1.isEmpty {
                    return errorMessage()
                } else {
                    return ("", defaultErrorMessage)
                }
            }

        validationErrors = invalidErrors.map { $0.1}

        for (propertyKey, errorMessage) in invalidErrors {
            if var errors = validationErrorsMap[propertyKey] {
                errors.append(errorMessage)
                validationErrorsMap[propertyKey] = errors
            } else {
                validationErrorsMap[propertyKey] = [errorMessage]
            }
        }

        return invalidErrors.isEmpty ? .valid : .invalid(errors: invalidErrors.map { $0.1})
    }

    /// Retrieves the validation error messages for a given property in the model.
    ///
    /// - Parameter keyPath: The key path representing the property in the model.
    /// - Returns: An array of validation error messages for the specified property, or nil if there are no validation errors for the property.
    public func errorFor<Value>(keyPath: KeyPath<Model, Value>) -> [String]? {
        let errors = validationErrorsMap[keyPath.propertyName]

        return errors
    }

    /// Retrieves the validation error messages for a given property in the model and updates the provided `errorMessage` with the first error message, if any.
    /// This method is used to get the error message associated with a specific property and update an `inout` `errorMessage` parameter for easy access to the error message.
    ///
    /// - Parameters:
    ///   - keyPath: The key path representing the property in the model.
    ///   - assign: A reference to a string that will be updated with the first validation error message, if any. If no errors are found, it will be set to an empty string.
    /// - Returns: The Validator instance for further chaining of validation rules.
    @discardableResult
    public func errorFor<Value>(keyPath: KeyPath<Model, Value>, assign: inout String) -> Validator<Model>{
        guard let errors = validationErrorsMap[keyPath.propertyName] else {
            assign = ""
            return self
        }
        assign = errors.first ?? ""

        return self
    }

    /**
     Creates a validation rule for a specific property of the model.

     - Parameter keyPath: The key path of the property to validate.
     - Returns: An instance of `RuleForBuilder` that allows chaining validation rules for the specified property.

     Example usage:
     ```
     let validator = Validator<User>()
     .ruleFor(\.name)
     .notEmpty()
     .maxLength(50)
     .build()
     ```

     The `ruleFor` method is used to define validation rules for a particular property of the model. It returns a `RuleForBuilder` instance that allows you to chain multiple validation rules for the same property. Each rule can be specified using methods like `notEmpty`, `maxLength`, `email`, etc.

     The `@discardableResult` attribute is used to suppress the compiler warning when the return value of this method is not used. However, it is recommended to capture the returned `RuleForBuilder` instance to ensure all validation rules are added to the validator.
     */
    @discardableResult
    public func ruleFor<Value>(_ keyPath: KeyPath<Model, Value>) -> RuleForBuilder<Model, Value> {
        return RuleForBuilder(keyPath: keyPath, validator: self)
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
