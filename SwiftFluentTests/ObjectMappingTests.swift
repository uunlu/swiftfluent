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
//            .ruleFor(\.name, length: 5...30, errorMessage: "invalid name")
//            .ruleFor(\.email, length: 0...5, errorMessage: "invalid email")

        let result = validator.validate(user)

        XCTAssertEqual(result.isValid, true)

    }

    struct User {
        let name: String
        let age: Int
        let email: String
    }

}
