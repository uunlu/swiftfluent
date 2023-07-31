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
}
