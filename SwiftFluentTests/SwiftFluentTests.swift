//
//  SwiftFluentTests.swift
//  SwiftFluentTests
//
//  Created by Ugur Unlu on 31/07/2023.
//

import XCTest
import SwiftFluent

final class SwiftFluentTests: XCTestCase {
    func testOnInitValidatorShouldBeValid() throws {
        let sut = Validator<String>()
        let result = sut.validate("")

        XCTAssertTrue(result.isValid)
    }

    func testOnStringEmpty_IsNotValid() throws {
        let sut = Validator<String>()
        sut
            .validate({ !$0.isEmpty}, errorMessage: "Should not be empty")
        let result = sut.validate("")
        XCTAssertFalse(result.isValid)
    }

    func testOnStringNotEmptyAndLongerThanRequiredCharacter_IsValid() throws {
        let password = "myValidPassword"
        let sut = Validator<String>()

        sut
            .validate({ !$0.isEmpty}, errorMessage: "Should not be empty")
            .validate({ $0.count > 5 }, errorMessage: "Should be at least 6 characters")

        let result = sut.validate(password)
        XCTAssertEqual(result.isValid, true, "Expected true but invalid password")
    }

    func testOnForInvalidValidation_ListErrors() throws {
        let password = "foe"
        let sut = Validator<String>()

        let emptyInputError = "Should not be empty."
        let minimumCharacterError = "Should be at least 6 characters."
        sut
            .validate({ !$0.isEmpty}, errorMessage: emptyInputError)
            .validate({ $0.count > 5 }, errorMessage: minimumCharacterError)

        let result = sut.validate(password)
        XCTAssertEqual(result.isValid, false, "Expected true but invalid password")
        XCTAssertEqual(sut.validationErrors.count, 1)
        XCTAssertEqual(sut.validationErrors.first, minimumCharacterError)
    }

    func testEmailFalseForInvalidEmail() throws {
        let email = "ugur@"

        let emailError = "Not a valid email"

        let sut = Validator<String>()

        sut
            .email(errorMessage: emailError)

        let result = sut.validate(email)

        XCTAssertFalse(result.isValid)
        XCTAssertEqual(sut.validationErrors.first, emailError)
    }

    func testForvalidEmailIsValid() throws {
        let email = "ugur@gmail.com"

        let emailError = "Not a valid email"

        let sut = Validator<String>()

        sut
            .email(errorMessage: emailError)

        let result = sut.validate(email)

        XCTAssertTrue(result.isValid)
        XCTAssertEqual(sut.validationErrors.first, nil)
    }

    func testNumberOnlyNotValid() throws {
        let numberOnlyString = "1234u"

        let invalidNumberError = "Not a valid number"

        let sut = Validator<String>()

        sut
            .number(errorMessage: invalidNumberError)

        let result = sut.validate(numberOnlyString)
        XCTAssertFalse(result.isValid)
    }

    func testNumberOnlyValid() throws {
        let numberOnlyString = "1234"

        let invalidNumberError = "Not a valid number"

        let sut = Validator<String>()

        sut
            .email(errorMessage: invalidNumberError)

        let result = sut.validate(numberOnlyString)
        XCTAssertFalse(result.isValid)
    }

    func testNotEmptyIsValidFalse() throws {
        let emptyOrWhiteSpaceString = "    "

        let notEmptyError = "It is an empty string."

        let sut = Validator<String>()

        sut.notEmpty(errorMessage: notEmptyError)

        let result = sut.validate(emptyOrWhiteSpaceString)
        XCTAssertFalse(result.isValid)
    }

    func testNotEmptyIsValidTrue() throws {
        let notEmptyString = "not empty string"

        let notEmptyError = "It is an empty string."

        let sut = Validator<String>()

        sut.notEmpty(errorMessage: notEmptyError)

        let result = sut.validate(notEmptyString)
        XCTAssertTrue(result.isValid)
    }

    func testNotEqualIsValidTrue() throws {
        let notEqualString = "not equal to this string"

        let notEqualError = "Equal to string whereas expected to be not equal."

        let sut = Validator<String>()

        sut.notEqual(to: "some string", errorMessage: notEqualError)

        let result = sut.validate(notEqualString)
        XCTAssertTrue(result.isValid)
    }

    func testNotEqualIsValidFalse() throws {
        let notEqualString = "not equal to this string"

        let notEqualError = "Equal to string whereas expected to be not equal."

        let sut = Validator<String>()

        sut.notEqual(to: notEqualString, errorMessage: notEqualError)

        let result = sut.validate(notEqualString)
        XCTAssertFalse(result.isValid)
    }
}

