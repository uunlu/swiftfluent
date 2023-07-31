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
}
