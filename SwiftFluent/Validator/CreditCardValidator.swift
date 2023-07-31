//
//  CreditCardValidator.swift
//  SwiftFluent
//
//  Created by Ugur Unlu on 31/07/2023.
//

import Foundation

struct CreditCardValidator {
    static func isValid(_ creditCardNumber: String) -> Bool {
        // Remove any non-digit characters from the credit card number
        let sanitizedCreditCardNumber = creditCardNumber.filter { $0.isNumber }

        // Check if the credit card number contains at least 13 digits and passes the Luhn algorithm
        return sanitizedCreditCardNumber.count >= 13 && passesLuhnAlgorithm(sanitizedCreditCardNumber)
    }

    private static func passesLuhnAlgorithm(_ creditCardNumber: String) -> Bool {
        let reversedDigits = creditCardNumber.reversed().map { Int(String($0))! }
        var sum = 0
        for (index, digit) in reversedDigits.enumerated() {
            if index % 2 == 1 {
                let doubledDigit = digit * 2
                sum += doubledDigit > 9 ? doubledDigit - 9 : doubledDigit
            } else {
                sum += digit
            }
        }
        return sum % 10 == 0
    }
}
