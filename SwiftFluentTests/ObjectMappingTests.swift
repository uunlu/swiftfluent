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
        let user = User(name: "a name", age: 10, email: "some@email.com")
        let validator = Validator<User>()

        validator
            .ruleFor(\.name, length: 3...10, errorMessage: "")

        let result = validator.validate(user)

        XCTAssertEqual(result.isValid, true)

    }

    func testObjectFieldValidation_onIsValidFalse() {
        let user = User(name: "a name", age: 10, email: "some@email.com")

        let validator = Validator<User>()
            .ruleFor(\.email)
            .length(5, 10)
            .ruleFor(\.name)
            .length(0, 3)

        let result = validator.validate(user)

        XCTAssertEqual(result.isValid, false)
        XCTAssertEqual(validator.validationErrors.first, "The length of ‘String’ must be 5 to 10 characters.")
        XCTAssertEqual(validator.validationErrors.last, "The length of ‘String’ must be 0 to 3 characters.")
    }

    struct User {
        let name: String
        let age: Int
        let email: String
    }

}
