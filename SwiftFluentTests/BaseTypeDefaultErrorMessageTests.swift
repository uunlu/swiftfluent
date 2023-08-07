//
//  BaseTypeDefaultErrorMessageTests.swift
//  SwiftFluentTests
//
//  Created by Ugur Unlu on 07/08/2023.
//

import XCTest
@testable import SwiftFluent

final class BaseTypeDefaultErrorMessageTests: XCTestCase {

    func testDefaultErrorMessages() throws {
        let validator = Validator<String>()
        let anotherValidator = Validator<String>()
        let intValidator = Validator<Int>()
        let nullableValidator = Validator<String?>()

        validator
            .email()
            .minLength(100)
            .maxLength(0)
            .length(0, 0)
            .notEqual("some value")
            .creditCard()
            .equal("")

        anotherValidator
            .notEmpty()

        intValidator
            .notEqual(10)
            .lessThan(0)
            .lessThanOrEqualTo(9)
            .greaterThan(10)
            .greaterThanOrEqualTo(11)

        nullableValidator
            .notNil()

        _ = validator.validate("some value")
        _ = anotherValidator.validate("")
        _ = intValidator.validate(10)
        _ = nullableValidator.validate(nil)

        let emailErrorForString = ErrorMessage.emailError(name: "String").errorDescription
        let minLengthErrorForString = ErrorMessage.minLengthError(name: "String", min: 100).errorDescription
        let maxLengthErrorForString = ErrorMessage.maxLengthError(name: "String", max: 0).errorDescription
        let lengthErrorForString = ErrorMessage.lengthError(name: "String", min: 0, max: 0).errorDescription
        let notEqualErrorForString = ErrorMessage.notEqualError(name: "String", value: "some value").errorDescription
        let creditCardErrorForString = ErrorMessage.creditCardError(name: "String").errorDescription
        let equalErrorForString = ErrorMessage.equalError(name: "String", value: "").errorDescription

        let expectedErrorsForStringType = [
            emailErrorForString,
            minLengthErrorForString,
            maxLengthErrorForString,
            lengthErrorForString,
            notEqualErrorForString,
            creditCardErrorForString,
            equalErrorForString
        ]

        let expectedErrorsForAnotherStringType = [
            ErrorMessage.notEmptyError(name: "String").errorDescription
        ]

        let expectedErrorsForIntValidatorType = [
            ErrorMessage.notEqualError(name: "Int", value: "10").errorDescription,
            ErrorMessage.lessThanError(name: "Int", max: "0").errorDescription,
            ErrorMessage.lessThanOrEqualToError(name: "Int", max: "9").errorDescription,
            ErrorMessage.greaterThanError(name: "Int", min: "10").errorDescription,
            ErrorMessage.greaterThanOrEqualToError(name: "Int", min: "11").errorDescription
        ]

        let expectedErrorsForNullableValidatorType = [
            ErrorMessage.notNilError(name: "Optional<String>").errorDescription
        ]

        XCTAssertEqual(validator.validationErrors, expectedErrorsForStringType)
        XCTAssertEqual(anotherValidator.validationErrors, expectedErrorsForAnotherStringType)
        XCTAssertEqual(intValidator.validationErrors, expectedErrorsForIntValidatorType)
        XCTAssertEqual(nullableValidator.validationErrors, expectedErrorsForNullableValidatorType)
    }

}
