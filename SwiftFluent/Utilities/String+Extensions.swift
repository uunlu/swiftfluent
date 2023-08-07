//
//  String+Extensions.swift
//  SwiftFluent
//
//  Created by Ugur Unlu on 07/08/2023.
//

import Foundation

// MARK: - String extensions

extension String {
    func isValidEmail(customRegex: String? = nil) -> Bool {
        let emailRegex = customRegex ?? "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)

        return emailPredicate.evaluate(with: self)
    }

    func isNumber() -> Bool {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale.current
        return numberFormatter.number(from: self) != nil
    }
}

extension String {
    func isNotEmpty() -> Bool {
        self.isEmpty == false && self.trimmingCharacters(in: .whitespaces).isEmpty == false
    }
}
