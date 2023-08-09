//
//  ErrorMessage.swift
//  SwiftFluent
//
//  Created by Ugur Unlu on 07/08/2023.
//

import Foundation

enum ErrorMessage: Error, LocalizedError {
    case lengthError(name: String, min: Int, max: Int)
    case minLengthError(name: String, min: Int)
    case maxLengthError(name: String, max: Int)
    // Extension String
    case emailError(name: String)
    case creditCardError(name: String)
    case numberError(name: String)
    case urlError(name: String)
    // Extension Comparable
    case lessThanError(name: String, max: String)
    case lessThanOrEqualToError(name: String, max: String)
    case greaterThanError(name: String, min: String)
    case greaterThanOrEqualToError(name: String, min: String)
    // Extension Collection
    case notEmptyError(name: String)
    // Extension Optional
    case notNilError(name: String)
    // Extension Equatable
    case equalError(name: String, value: String)
    case notEqualError(name: String, value: String)
    case defaultError

    var errorDescription: String {
        switch self {
            case .lengthError(let name, let min, let max):
                return NSLocalizedString("The length of ‘\(name)’ must be between \(min) and \(max) characters.", comment: "")
            case .minLengthError(let name, let min):
                return NSLocalizedString("The length of ‘\(name)’ must be \(min) characters or more.", comment: "")
            case .maxLengthError(let name, let max):
                return NSLocalizedString("The length of ‘\(name)’ must be \(max) characters or fewer.", comment: "")
            case .emailError(let name):
                return NSLocalizedString("'\(name)' is not a valid email address.", comment: "")
            case .creditCardError(let name):
                return NSLocalizedString("‘\(name)‘ is not a valid credit card number.", comment: "")
            case .numberError(let name):
                return NSLocalizedString("‘\(name)‘ is not a valid number.", comment: "")
            case .urlError(let name):
                return NSLocalizedString("‘\(name)‘ is not a valid URL.", comment: "")
            case .lessThanError(let name, let max):
                return NSLocalizedString("‘\(name)’ must be less than \(max).", comment: "")
            case .lessThanOrEqualToError(let name, let max):
                return NSLocalizedString("‘\(name)’ must be less than or equal to \(max).", comment: "")
            case .greaterThanError(let name, let min):
                return NSLocalizedString("‘\(name)’ must be greater than \(min).", comment: "")
            case .greaterThanOrEqualToError(let name, let min):
                return NSLocalizedString("‘\(name)’ must be greater than or equal to \(min).", comment: "")
            case .notEmptyError(let name):
                return NSLocalizedString("‘\(name)’ should not be empty.", comment: "")
            case .notNilError(let name):
                return NSLocalizedString("‘\(name)’ must not be nil.", comment: "")
            case .equalError(let name, let value):
                return NSLocalizedString("‘\(name)’ should be equal to \(value).", comment: "")
            case .notEqualError(let name, let value):
                return NSLocalizedString("‘\(name)’ should not be equal to \(value).", comment: "")
            case .defaultError:
                return NSLocalizedString("Invalid property", comment: "")
        }
    }
}
