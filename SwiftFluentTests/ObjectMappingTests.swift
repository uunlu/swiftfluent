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
            .build()
            .ruleFor(\.name)
            .length(0, 3)
            .build()


        let result = validator.validate(user)

        XCTAssertEqual(result.isValid, false)
        XCTAssertEqual(validator.validationErrors.first, "The length of ‘email’ must be between 5 and 10 characters.")
        XCTAssertEqual(validator.validationErrors.last, "The length of ‘name’ must be between 0 and 3 characters.")
    }

    func testObjectFieldValidation_onEmailNotValid() {
        let user = makeSUT(email: "invalid@email")

        let validator = Validator<User>()
            .ruleFor(\.email)
            .length(5, 10)
            .email()
            .build()

        let result = validator.validate(user)

        XCTAssertEqual(result.isValid, false)
        XCTAssertEqual(validator.validationErrors.first, "The length of ‘email’ must be between 5 and 10 characters.")
        XCTAssertEqual(validator.validationErrors.last, "'email' is not a valid email address.")
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

    func testObjectLessThan_onIsValidFalse() throws {
        let user = makeSUT(name: "name")

        let validator = Validator<User>()
            .ruleFor(\.age)
            .lessThan(10)
            .ruleFor(\.name)
            .lessThan("good")
            .build()

        let result = validator.validate(user)


        XCTAssertFalse(result.isValid)
        XCTAssertEqual(validator.validationErrors.count, 2)
        XCTAssertEqual(validator.validationErrors.first, "‘age’ must be less than 10.")
    }

    func testObjectGreaterThan_onIsValidTrue() throws {
        let user = makeSUT(name: "name")

        let validator = Validator<User>()
            .ruleFor(\.age)
            .greaterThan(10)
            .ruleFor(\.name)
            .greaterThan("good")
            .build()

        let result = validator.validate(user)


        XCTAssertTrue(result.isValid)
        XCTAssertEqual(validator.validationErrors.count, 0)
    }

    func testObjectGreaterThan_onIsValidFalse() throws {
        let user = makeSUT(name: "name", age: 20)

        let validator = Validator<User>()
            .ruleFor(\.age)
            .greaterThan(25)
            .ruleFor(\.name)
            .greaterThan("not greater")
            .build()

        let result = validator.validate(user)


        XCTAssertFalse(result.isValid)
        XCTAssertEqual(validator.validationErrors.count, 2)
        XCTAssertEqual(validator.validationErrors.first, "‘age’ must be greater than 25.")
    }

    func testObjectLessThanOrEqualTo_onIsValidFalse() throws {
        let user = makeSUT(name: "name", age: 20)

        let validator = Validator<User>()
            .ruleFor(\.age)
            .lessThanOrEqualTo(19)
            .ruleFor(\.name)
            .lessThanOrEqualTo("good")
            .build()

        let result = validator.validate(user)


        XCTAssertFalse(result.isValid)
        XCTAssertEqual(validator.validationErrors.count, 2)
        XCTAssertEqual(validator.validationErrors.first, "‘age’ must be less than or equal to 19.")
    }

    func testObjectLessThanOrEqualTo_onIsValidTrue() throws {
        let user = makeSUT(name: "name", age: 20)

        let validator = Validator<User>()
            .ruleFor(\.age)
            .lessThanOrEqualTo(20)
            .ruleFor(\.name)
            .lessThanOrEqualTo("name")
            .build()

        let result = validator.validate(user)


        XCTAssertTrue(result.isValid)
        XCTAssertEqual(validator.validationErrors.count, 0)
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
