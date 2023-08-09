//
//  ValidationRule.swift
//  SwiftFluent
//
//  Created by Ugur Unlu on 04/08/2023.
//

import Foundation

struct ValidationRule<Model> {
    var errorMessage: () -> (String, String)
    let isValid: (Model) -> Bool

    init(errorMessage: @escaping () -> (String, String), isValid: @escaping (Model) -> Bool) {
        self.errorMessage = errorMessage
        self.isValid = isValid
    }
}
