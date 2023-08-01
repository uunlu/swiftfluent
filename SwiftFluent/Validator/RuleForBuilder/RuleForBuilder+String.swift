////
////  RuleForBuilder+String.swift
////  SwiftFluent
////
////  Created by Ugur Unlu on 01/08/2023.
////
//
//import Foundation
//
//public extension RuleForBuilder {
//    /**
//     Adds a validation rule to the Validator for checking the length of a String property.
//
//     Use this method to add a length validation rule to the Validator for a specific String property. The `min` and `max` parameters define the minimum and maximum lengths (inclusive) that the property value should have to pass the validation.
//
//     - Parameters:
//     - min: The minimum allowed length of the String.
//     - max: The maximum allowed length of the String.
//     - errorMessage: The error message to display if the validation fails. If `errorMessage` is not provided, a default error message will be used.
//     - Returns: The Validator instance with the new validation rule added.
//
//     Example usage:
//     ```
//     let validator = Validator<User>()
//     .ruleFor(.email)
//     .length(5, 10, errorMessage: "Email must be between 5 and 10 characters.")
//     .ruleFor(.name)
//     .length(0, 10) // Uses the default error message.
//     ```
//     - Note: The `@discardableResult` attribute allows ignoring the return value if desired. However, it is recommended to capture the returned Validator instance to ensure all validation rules are added.
//     */
//    @discardableResult
//    func length(
//        _ min: Int,
//        _ max: Int,
//        errorMessage: String = ""
//    ) -> Validator<Model> where Value == String {
//        var userInputLength = 0
//        var rule = ValidationRule<Model> { model in
//            let value = model[keyPath: keyPath]
//            userInputLength = value.count
//            self.validator.addError(errorMessage)
//            return userInputLength >= min && userInputLength < max
//        }
//
//        if errorMessage.isEmpty {
//            rule.errorMessage = { "The length of ‘\(keyPath)’ must be \(min) to \(max) characters." }
//        } else {
//            rule.errorMessage = { errorMessage }
//        }
//        validator.addRule(rule)
//        return validator
//    }
//
//    @discardableResult
//    func email(errorMessage: String = "") -> Validator<Model> where Value == String {
//        var errorMessageClosure: (() -> String)?
//        var rule = ValidationRule<Model>() { model in
//            let value = model[keyPath: keyPath]
//            errorMessageClosure = { "\(value)’ is not a valid email address." }
//            return value.isValidEmail()
//        }
//        if errorMessage.isEmpty {
//            rule.errorMessage = errorMessageClosure ?? { "" }
//        }else {
//            rule.errorMessage = { errorMessage }
//        }
//
//        validator.addRule(rule)
//        return validator
//    }
//}
//
