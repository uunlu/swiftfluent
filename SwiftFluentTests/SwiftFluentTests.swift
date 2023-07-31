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

    func testNotEqualIntIsValidTrue() throws {
        let notEqualInt = 10

        let notEqualError = "Equal to string whereas expected to be not equal."

        let sut = Validator<Int>()

        sut.notEqual(to: 0, errorMessage: notEqualError)

        let result = sut.validate(notEqualInt)
        XCTAssertTrue(result.isValid)
    }

    func testNotEqualIntIsValidFalse() throws {
        let notEqualInt = 10

        let notEqualError = "Equal to string whereas expected to be not equal."

        let sut = Validator<Int>()

        sut.notEqual(to: 10, errorMessage: notEqualError)

        let result = sut.validate(notEqualInt)
        XCTAssertFalse(result.isValid)
    }

    func testNotNullIsValidFalse() throws {
        let notNilString: String? = nil

        let notNilError = "Expected not nil but received nil instead"

        let sut = Validator<String?>()

        sut.notNil(errorMessage: notNilError)

        let result = sut.validate(notNilString)
        XCTAssertFalse(result.isValid)
    }

    func testNotNullIsValidTrue() throws {
        let notNilString = "not nil to this string"

        let notEqualError = "Expected not nil but received nil instead"

        let sut = Validator<String?>()

        sut.notNil(errorMessage: notEqualError)

        let result = sut.validate(notNilString)
        XCTAssertTrue(result.isValid)
    }

    func testNotNullCheckForIntIsValidFalse() throws {
        let notNilString: Int? = nil

        let notEqualError = "Expected not nil but received nil instead"

        let sut = Validator<Int?>()

        sut.notNil(errorMessage: notEqualError)

        let result = sut.validate(notNilString)
        XCTAssertFalse(result.isValid)
    }

    func testNotNullCheckForIntIsValidTrue() throws {
        let notNilString: Int? = 10

        let notEqualError = "Expected not nil but received nil instead"

        let sut = Validator<Int?>()

        sut.notNil(errorMessage: notEqualError)

        let result = sut.validate(notNilString)
        XCTAssertTrue(result.isValid)
    }

    func testEqualIntIsValidFalse() throws {
        let equalInt = 10

        let notEqualError = "Equal to string whereas expected to be not equal."

        let sut = Validator<Int>()

        sut.equal(to: 0, errorMessage: notEqualError)

        let result = sut.validate(equalInt)
        XCTAssertFalse(result.isValid)
    }

    func testEqualIntIsValidTrue() throws {
        let equalInt = 10

        let notEqualError = "Equal to string whereas expected to be not equal."

        let sut = Validator<Int>()

        sut.equal(to: 10, errorMessage: notEqualError)

        let result = sut.validate(equalInt)
        XCTAssertTrue(result.isValid)
    }

    func testEqualForStringIsValidTrue() throws {
        let equalString = "equal string"

        let notEqualError = "Expected to be equal to \(equalString)"

        let sut = Validator<String>()

        sut.equal(to: "equal string", errorMessage: notEqualError)

        let result = sut.validate(equalString)
        XCTAssertTrue(result.isValid)
    }

    func testEqualForOptionalIsValidTrue() throws {
        let equalOptional: Bool? = nil

        let notEqualError = "Expected to be equal to nil, whereas result is not nil"

        let sut = Validator<Bool?>()

        sut.equal(to: nil, errorMessage: notEqualError)

        let result = sut.validate(equalOptional)
        XCTAssertTrue(result.isValid)
    }

    func testLengthRangeIsValidFalse() throws {
        let equalOptional: String = "some string"
        let minCharacter = 2
        let maxCharacter = 5
        let notEqualError = "Expected to be between \(minCharacter) to \(maxCharacter) "

        let sut = Validator<String>()

        sut.length(minCharacter, maxCharacter, errorMessage: notEqualError)

        let result = sut.validate(equalOptional)
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(sut.validationErrors.first, notEqualError)
    }

    func testMinLengtIsValidFalse() throws {
        let equalOptional: String = "some string"
        let minCharacter = 20
        let notEqualError = "Expected to be at least \(minCharacter) characters"

        let sut = Validator<String>()

        sut.minLength(minCharacter, errorMessage: notEqualError)

        let result = sut.validate(equalOptional)
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(sut.validationErrors.first, notEqualError)
    }

    func testMinLengtIsValidTrue() throws {
        let equalOptional: String = "some string"
        let minCharacter = 5
        let notEqualError = "Expected to be at least \(minCharacter) characters"

        let sut = Validator<String>()

        sut.minLength(minCharacter, errorMessage: notEqualError)

        let result = sut.validate(equalOptional)
        XCTAssertTrue(result.isValid)
    }

    func testMaxLengtIsValidFalse() throws {
        let equalOptional: String = "some string"
        let maxCharacter = 20
        let notEqualError = "Expected to be at most \(maxCharacter) characters"

        let sut = Validator<String>()

        sut.maxLength(maxCharacter, errorMessage: notEqualError)

        let result = sut.validate(equalOptional)
        XCTAssertTrue(result.isValid)
    }

    func testMaxLengtIsValidTrue() throws {
        let equalOptional: String = "some string"
        let minCharacter = 5
        let notEqualError = "Expected to be at most \(minCharacter) characters"

        let sut = Validator<String>()

        sut.maxLength(minCharacter, errorMessage: notEqualError)

        let result = sut.validate(equalOptional)
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(sut.validationErrors.first, notEqualError)
    }

    func testLessThanIsValidTrue() throws {
        let value: Int =  10
        let lessThan = 20
        let lessThanError = "Expected to be less than \(lessThan)"

        let sut = Validator<Int>()

        sut.lessThan(lessThan, errorMessage: lessThanError)

        let result = sut.validate(value)
        XCTAssertTrue(result.isValid)
    }

    func testLessThanIsValidFalse() throws {
        let value: Int =  10
        let lessThan = 5
        let lessThanError = "Expected to be less than \(lessThan)"

        let sut = Validator<Int>()

        sut.lessThan(lessThan, errorMessage: lessThanError)

        let result = sut.validate(value)
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(sut.validationErrors.first, lessThanError)
    }

    func testLessThanOrEqualToIsValidTrue() throws {
        let value: Int =  10
        let lessThan = 10
        let lessThanError = "Expected to be less than or equal to \(lessThan)"

        let sut = Validator<Int>()

        sut.lessThanOrEqualTo(lessThan, errorMessage: lessThanError)

        let result = sut.validate(value)
        XCTAssertTrue(result.isValid)
    }

    func testLessThanOrEqualToIsValidFalse() throws {
        let value: Int =  10
        let lessThan = 9
        let lessThanOrEqualToError = "Expected to be less than or equal to \(lessThan)"

        let sut = Validator<Int>()

        sut.lessThanOrEqualTo(lessThan, errorMessage: lessThanOrEqualToError)

        let result = sut.validate(value)
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(sut.validationErrors.first, lessThanOrEqualToError)
    }

    func testGreaterThanIsValidTrue() throws {
        let value: Int =  10
        let greaterThan = 9
        let greaterThanError = "Expected to be greater than \(greaterThan)"

        let sut = Validator<Int>()

        sut.greaterThan(greaterThan, errorMessage: greaterThanError)

        let result = sut.validate(value)
        XCTAssertTrue(result.isValid)
    }

    func testGreaterThanIsValidFalse() throws {
        let value: Int =  10
        let greaterThan = 11
        let greaterThanError = "Expected to be greater than \(greaterThan)"

        let sut = Validator<Int>()

        sut.greaterThan(greaterThan, errorMessage: greaterThanError)

        let result = sut.validate(value)
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(sut.validationErrors.first, greaterThanError)
    }

    func testGreaterThanOrEqualToIsValidTrue() throws {
        let value: Int =  10
        let greaterThanOrEqualTo = 10
        let greaterThanOrEqualToError = "Expected to be greater than or equal to \(greaterThanOrEqualTo)"

        let sut = Validator<Int>()

        sut.greaterThanOrEqualTo(greaterThanOrEqualTo, errorMessage: greaterThanOrEqualToError)

        let result = sut.validate(value)
        XCTAssertTrue(result.isValid)
    }

    func testGreaterThanOrEqualToIsValidFalse() throws {
        let value: Int =  10
        let greaterThanOrEqualTo = 11
        let greaterThanOrEqualToError = "Expected to be greater than or equal to \(greaterThanOrEqualTo)"

        let sut = Validator<Int>()

        sut.greaterThanOrEqualTo(greaterThanOrEqualTo, errorMessage: greaterThanOrEqualToError)

        let result = sut.validate(value)
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(sut.validationErrors.first, greaterThanOrEqualToError)
    }

    func testCreditCardIsValidTrue() throws {
        let creditCard = "374245455400126"
        let invalidCreditCardError = "Not a valid credit card"

        let sut = Validator<String>()

        sut.creditCard(errorMessage: invalidCreditCardError)

        let result = sut.validate(creditCard)

        XCTAssertTrue(result.isValid)
    }

    func testCreditCardIsValidFalse() throws {
        let creditCard = ""
        let invalidCreditCardError = "Not a valid credit card"

        let sut = Validator<String>()

        sut.creditCard(errorMessage: invalidCreditCardError)

        let result = sut.validate(creditCard)

        XCTAssertFalse(result.isValid)
        XCTAssertEqual(sut.validationErrors.first, invalidCreditCardError)
    }

}

