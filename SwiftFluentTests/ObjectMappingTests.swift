//
//  ObjectMappingTests.swift
//  SwiftFluentTests
//
//  Created by Ugur Unlu on 01/08/2023.
//

import XCTest
import SwiftFluent

final class ObjectMappingTests: XCTestCase {

    func testObjectFieldsValidation() throws {
        let user = makeSUT()
        let validator = Validator<User>()

        validator
            .ruleFor(\.name, length: 3...10, errorMessage: "")

        let result = validator.validate(user)

        XCTAssertEqual(result.isValid, true)

    }

    func testObjectFieldValidation_onIsValidFalse() {
        let user = makeSUT()

        let validator = Validator<User>()
            .ruleFor(\.email)
            .length(5, 10)
            .email()
            .ruleFor(\.name)
            .length(0, 3)
            .build()


        let result = validator.validate(user)

        XCTAssertEqual(result.isValid, false)
        XCTAssertEqual(validator.validationErrors.first, "The length of ‘email’ must be between 5 and 10 characters.")
        XCTAssertEqual(validator.validationErrors.last, "The length of ‘name’ must be between 0 and 3 characters.")
    }

    func testObjectCreditCardVAlidation_onIsValidFalse() throws {
        let user = makeSUT()

        let validator = Validator<User>()
            .ruleFor(\.creditCardNumber)
            .creditCard()
            .build()

        let result = validator.validate(user)


        XCTAssertFalse(result.isValid)
        XCTAssertEqual(validator.validationErrors.first, "‘creditCardNumber’ is not a valid credit card number.")
    }

    private func makeSUT(name: String = "a name", age: Int = 20, email: String = "some@mail.com", creditCardNumber: String = "") -> User {
        User(name: name, age: age, email: email, creditCardNumber: creditCardNumber)
    }

    struct User {
        let name: String
        let age: Int
        let email: String
        let creditCardNumber: String
    }

}
