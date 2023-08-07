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

        _ = validator.validate("some value")

        let emailErrorForString = ErrorMessage.email(name: "String").errorDescription

        let expectedErrorsForStringType = [
            emailErrorForString
        ]

        XCTAssertEqual(validator.validationErrors, expectedErrorsForStringType)
    }

}
