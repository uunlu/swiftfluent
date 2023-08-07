//
//  BaseTypeDefaultErrorMessageTests.swift
//  SwiftFluentTests
//
//  Created by Ugur Unlu on 07/08/2023.
//

import XCTest
@testable import SwiftFluent

final class BaseTypeDefaultErrorMessageTests: XCTestCase {

    func testExample() throws {
        let validator = Validator<String>()

        validator
            .email()
            .minLength(100)

        _ = validator.validate("some value")

        let emailErrorForString = ErrorMessage.email(name: "String").errorDescription
        let minLengthErrorForString = ErrorMessage.minLengthError(name: "String", min: 100).errorDescription

        let expectedErrorsForStringType = [
            emailErrorForString,
            minLengthErrorForString
        ]

        XCTAssertEqual(validator.validationErrors, expectedErrorsForStringType)
    }

}
