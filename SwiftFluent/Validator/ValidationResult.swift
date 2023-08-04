//
//  ValidationResult.swift
//  SwiftFluent
//
//  Created by Ugur Unlu on 04/08/2023.
//

import Foundation

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
