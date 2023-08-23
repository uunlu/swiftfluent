//
//  RuleForBuilderErrorTests.swift
//  SwiftFluentTests
//
//  Created by Ugur Unlu on 06/08/2023.
//

import XCTest
@testable import SwiftFluent

final class RuleForBuilderErrorTests: XCTestCase {

    func testLengthProvidesDefaultErrorMessage_onNoCustomErrorMessage() throws {
        let model = makeSUT(email: "")

        let validator = Validator<User>()

        let result = validator
            .ruleFor(\.name)
            .length(0, 0)
            .minLength(100)
            .email()
            .creditCard()
            .maxLength(0)
            .lessThan("0")
            .lessThanOrEqualTo("0")
            .greaterThan("zzz")
            .greaterThanOrEqualTo("zzz")
            .equal("")
            .notEqual("a name")
            .ruleFor(\.age)
            .lessThan(0)
            .lessThanOrEqualTo(0)
            .greaterThan(100)
            .greaterThanOrEqualTo(100)
            .equal(0)
            .ruleFor(\.email)
            .notEmpty()
            .ruleFor(\.profileImageURL)
            .notNil()
            .build()

        validator.validate(model)

        let errorsForName: [String] = result.errorFor(keyPath: \.name)
        let errorsForAge: [String] = result.errorFor(keyPath: \.age)
        let errorsForEmail: [String] = result.errorFor(keyPath: \.email)
        let errorsForProfileImageURL: [String] = result.errorFor(keyPath: \.profileImageURL)

        let expectedNameLengthErrorMessage = ErrorMessage.lengthError(name: "name", min: 0, max: 0).errorDescription
        let expectedNameMinLengthErrorMessage = ErrorMessage.minLengthError(name: "name", min: 100).errorDescription
        let expectedNameEmailErrorMessage = ErrorMessage.emailError(name: "name").errorDescription
        let expectedNameCreditcardErrorMessage = ErrorMessage.creditCardError(name: "name").errorDescription
        let expectedNameMaxLengthErrorMessage = ErrorMessage.maxLengthError(name: "name", max: 0).errorDescription
        let expectedNameLessThanErrorMessage = ErrorMessage.lessThanError(name: "name", max: "0").errorDescription
        let expectedNameLessThanOrEqualToErrorMessage = ErrorMessage.lessThanOrEqualToError(name: "name", max: "0").errorDescription
        let expectedNameGreaterThanErrorMessage = ErrorMessage.greaterThanError(name: "name", min: "zzz").errorDescription
        let expectedNameGreaterThanOrEqualToErrorMessage = ErrorMessage.greaterThanOrEqualToError(name: "name", min: "zzz").errorDescription
        let expectedNameEqualErrorMessage = ErrorMessage.equalError(name: "name", value: "").errorDescription
        let expectedNameNotEqualErrorMessage = ErrorMessage.notEqualError(name: "name", value: "a name").errorDescription

        let expectedAgeLessThanErrorMessage = ErrorMessage.lessThanError(name: "age", max: "0").errorDescription
        let expectedAgeLessThanOrEqualToErrorMessage = ErrorMessage.lessThanOrEqualToError(name: "age", max: "0").errorDescription
        let expectedAgeGreaterThanErrorMessage = ErrorMessage.greaterThanError(name: "age", min: "100").errorDescription
        let expectedAgeGreaterThanOrEqualToErrorMessage = ErrorMessage.greaterThanOrEqualToError(name: "age", min: "100").errorDescription
        let expectedAgeEqualErrorMessage = ErrorMessage.equalError(name: "age", value: "0").errorDescription

        let expectedEmailNotEmptyErrorMessage = ErrorMessage.notEmptyError(name: "email").errorDescription

        let expectedProfileImageURLNotNilErrorMessage = ErrorMessage.notNilError(name: "profileImageURL").errorDescription

        let expectedErrorsForName = [
            expectedNameLengthErrorMessage,
            expectedNameMinLengthErrorMessage,
            expectedNameEmailErrorMessage,
            expectedNameCreditcardErrorMessage,
            expectedNameMaxLengthErrorMessage,
            expectedNameLessThanErrorMessage,
            expectedNameLessThanOrEqualToErrorMessage,
            expectedNameGreaterThanErrorMessage,
            expectedNameGreaterThanOrEqualToErrorMessage,
            expectedNameEqualErrorMessage,
            expectedNameNotEqualErrorMessage
        ]

        let expectedErrorsForAge = [
            expectedAgeLessThanErrorMessage,
            expectedAgeLessThanOrEqualToErrorMessage,
            expectedAgeGreaterThanErrorMessage,
            expectedAgeGreaterThanOrEqualToErrorMessage,
            expectedAgeEqualErrorMessage
        ]

        let expectedErrorsForEmail = [
            expectedEmailNotEmptyErrorMessage
        ]

        let expectedErrorsForProfileImageURL = [
            expectedProfileImageURLNotNilErrorMessage
        ]

        XCTAssertEqual(expectedErrorsForName, errorsForName)
        XCTAssertEqual(expectedErrorsForAge, errorsForAge)
        XCTAssertEqual(expectedErrorsForEmail, errorsForEmail)
        XCTAssertEqual(expectedErrorsForProfileImageURL, errorsForProfileImageURL)
    }
}
