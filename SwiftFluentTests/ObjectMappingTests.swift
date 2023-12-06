//
//  ObjectMappingTests.swift
//  SwiftFluentTests
//
//  Created by Ugur Unlu on 01/08/2023.
//

import XCTest
import SwiftFluent

final class ObjectMappingTests: XCTestCase {

    private let validCreditCardNumber = "3566002020360505"

    func testObjectFieldsValidation() throws {
        let user = makeSUT()
        let validator = Validator<User>()
            .ruleFor(\.name)
            .length(0, 10)
            .build()

        let result = validator.validate(user)

        XCTAssertEqual(result.isValid, true)
    }

    func testObjectFieldValidation_onIsValidFalse() {
        let user = makeSUT()

        let validator = Validator<User>()
            .ruleFor(\.email)
            .length(5, 10)
            .email()
            .build()
            .ruleFor(\.name)
            .length(0, 3)
            .build()

        let result = validator.validate(user)

        XCTAssertEqual(result.isValid, false)
        XCTAssertEqual(validator.validationErrors.first, "The length of ‘email’ must be between 5 and 10 characters.")
        XCTAssertEqual(validator.validationErrors.last, "The length of ‘name’ must be between 0 and 3 characters.")
    }

    func testObjectFieldValidation_onEmailNotValid() {
        let user = makeSUT(email: "invalid@email")

        let validator = Validator<User>()
            .ruleFor(\.email)
            .length(5, 10)
            .email()
            .build()

        let result = validator.validate(user)

        XCTAssertEqual(result.isValid, false)
        XCTAssertEqual(validator.validationErrors.first, "The length of ‘email’ must be between 5 and 10 characters.")
        XCTAssertEqual(validator.validationErrors.last, "'email' is not a valid email address.")
    }

    func testObjectCreditCardVAlidation_onIsValidFalse() throws {
        let user = makeSUT(creditCardNumber: "")

        let validator = Validator<User>()
            .ruleFor(\.creditCardNumber)
            .creditCard()
            .notEmpty()
            .build()

        let result = validator.validate(user)

        let expectedError = "‘creditCardNumber‘ is not a valid credit card number."
        XCTAssertFalse(result.isValid)
        XCTAssertEqual(validator.validationErrors.first, expectedError)
    }

    func testObjectCreditCardVAlidation_onIsValidTrue() throws {
        let user = makeSUT(creditCardNumber: validCreditCardNumber)

        let validator = Validator<User>()
            .ruleFor(\.creditCardNumber)
            .creditCard()
            .notEmpty()
            .build()

        let result = validator.validate(user)

        XCTAssertTrue(result.isValid)
        XCTAssertEqual(validator.validationErrors.count, 0)
    }

    func testObjectLessThan_onIsValidFalse() throws {
        let user = makeSUT(name: "name")

        let validator = Validator<User>()
            .ruleFor(\.age)
            .lessThan(10)
            .ruleFor(\.name)
            .lessThan("good")
            .build()

        let result = validator.validate(user)

        XCTAssertFalse(result.isValid)
        XCTAssertEqual(validator.validationErrors.count, 2)
        XCTAssertEqual(validator.validationErrors.first, "‘age’ must be less than 10.")
    }

    func testObjectGreaterThan_onIsValidTrue() throws {
        let user = makeSUT(name: "name")

        let validator = Validator<User>()
            .ruleFor(\.age)
            .greaterThan(10)
            .ruleFor(\.name)
            .greaterThan("good")
            .build()

        let result = validator.validate(user)

        XCTAssertTrue(result.isValid)
        XCTAssertEqual(validator.validationErrors.count, 0)
    }

    func testObjectGreaterThan_onIsValidFalse() throws {
        let user = makeSUT(name: "name", age: 20)

        let validator = Validator<User>()
            .ruleFor(\.age)
            .greaterThan(25)
            .ruleFor(\.name)
            .greaterThan("not greater")
            .build()

        let result = validator.validate(user)

        XCTAssertFalse(result.isValid)
        XCTAssertEqual(validator.validationErrors.count, 2)
        XCTAssertEqual(validator.validationErrors.first, "‘age’ must be greater than 25.")
    }

    func testObjectLessThanOrEqualTo_onIsValidFalse() throws {
        let user = makeSUT(name: "name", age: 20)

        let validator = Validator<User>()
            .ruleFor(\.age)
            .lessThanOrEqualTo(19)
            .ruleFor(\.name)
            .lessThanOrEqualTo("good")
            .build()

        let result = validator.validate(user)

        XCTAssertFalse(result.isValid)
        XCTAssertEqual(validator.validationErrors.count, 2)
        XCTAssertEqual(validator.validationErrors.first, "‘age’ must be less than or equal to 19.")
    }

    func testObjectLessThanOrEqualTo_onIsValidTrue() throws {
        let user = makeSUT(name: "name", age: 20)

        let validator = Validator<User>()
            .ruleFor(\.age)
            .lessThanOrEqualTo(20)
            .ruleFor(\.name)
            .lessThanOrEqualTo("name")
            .build()

        let result = validator.validate(user)

        XCTAssertTrue(result.isValid)
        XCTAssertEqual(validator.validationErrors.count, 0)
    }

    func testObjectgreaterThanOrEqualTo_onIsValidFalse() throws {
        let user = makeSUT(name: "name", age: 20)

        let validator = Validator<User>()
            .ruleFor(\.age)
            .greaterThanOrEqualTo(21)
            .ruleFor(\.name)
            .greaterThanOrEqualTo("x name")
            .build()

        let result = validator.validate(user)

        XCTAssertFalse(result.isValid)
        XCTAssertEqual(validator.validationErrors.count, 2)
        XCTAssertEqual(validator.validationErrors.first, "‘age’ must be greater than or equal to 21.")
    }

    func testObjectgreaterThanOrEqualTo_onIsValidTrue() throws {
        let user = makeSUT(name: "name", age: 20)

        let validator = Validator<User>()
            .ruleFor(\.age)
            .greaterThanOrEqualTo(20)
            .ruleFor(\.name)
            .greaterThanOrEqualTo("name")
            .build()

        let result = validator.validate(user)

        XCTAssertTrue(result.isValid)
        XCTAssertEqual(validator.validationErrors.count, 0)
    }

    func testObjectNotNil_onIsValidFalse() throws {
        let user = makeSUT()

        let validator = Validator<User>()
            .ruleFor(\.age)
            .greaterThan(18)
            .ruleFor(\.profileImageURL)
            .notNil()
            .build()

        let result = validator.validate(user)

        XCTAssertFalse(result.isValid)
        XCTAssertEqual(validator.validationErrors.count, 1)
        XCTAssertEqual(validator.validationErrors.first, "‘profileImageURL’ must not be nil.")
    }

    func testObjectNotNil_onIsValidTrue() throws {
        let user = makeSUT(profileImageURL: "https://www.some-image.com")

        let validator = Validator<User>()
            .ruleFor(\.age)
            .greaterThan(18)
            .ruleFor(\.profileImageURL)
            .notNil()
            .build()

        let result = validator.validate(user)

        XCTAssertTrue(result.isValid)
        XCTAssertEqual(validator.validationErrors.count, 0)
    }

    func testObjectNotEmpty_onIsValidFalse() throws {
        let user = makeSUT()

        let validator = Validator<User>()
            .ruleFor(\.age)
            .greaterThan(18)
            .ruleFor(\.profileImageURL)
            .notNil()
            .ruleFor(\.favoriteBooks)
            .notEmpty()
            .build()

        let result = validator.validate(user)

        XCTAssertFalse(result.isValid)
        XCTAssertEqual(validator.validationErrors.count, 2)
        XCTAssertEqual(validator.validationErrors.first, "‘profileImageURL’ must not be nil.")
        XCTAssertEqual(validator.validationErrors.last, "‘favoriteBooks’ should not be empty.")
    }

    func testObjectNotEmpty_onIsValidTrue() throws {
        let user = makeSUT(favoriteBooks: ["Alquimista"], profileImageURL: "https://some-image.com")

        let validator = Validator<User>()
            .ruleFor(\.age)
            .greaterThan(18)
            .ruleFor(\.profileImageURL)
            .notNil()
            .ruleFor(\.favoriteBooks)
            .notEmpty()
            .build()

        let result = validator.validate(user)

        XCTAssertTrue(result.isValid)
        XCTAssertEqual(validator.validationErrors.count, 0)
    }

    func testObjectEqual_onIsValidFalse() throws {
        let user = makeSUT(favoriteBooks: ["Alquimista"], profileImageURL: "https://some-image.com")
        let notEqualUrlString: String? = "https://not-equal.com"

        let validator = Validator<User>()
            .ruleFor(\.age)
            .equal(18)
            .ruleFor(\.profileImageURL)
            .notNil()
            .equal(notEqualUrlString)
            .ruleFor(\.favoriteBooks)
            .notEmpty()
            .equal([])
            .build()

        let result = validator.validate(user)

        XCTAssertFalse(result.isValid)
        XCTAssertEqual(validator.validationErrors.count, 3)
        XCTAssertEqual(validator.validationErrors.first, "‘age’ should be equal to 18.")
        XCTAssertEqual(validator.validationErrors[1], "‘profileImageURL’ should be equal to \(String(describing: notEqualUrlString)).")
        XCTAssertEqual(validator.validationErrors.last, "‘favoriteBooks’ should be equal to [].")
    }

    func testObjectEqual_onIsValidTrue() throws {
        let user = makeSUT(favoriteBooks: ["Alquimista"], profileImageURL: "https://some-image.com")

        let validator = Validator<User>()
            .ruleFor(\.age)
            .equal(20)
            .ruleFor(\.profileImageURL)
            .notNil()
            .equal("https://some-image.com")
            .ruleFor(\.favoriteBooks)
            .notEmpty()
            .equal(["Alquimista"])
            .build()

        let result = validator.validate(user)

        XCTAssertTrue(result.isValid)
        XCTAssertEqual(validator.validationErrors.count, 0)
    }

    func testObjectNotEqual_onIsValidFalse() throws {
        let books = ["Alquimista"]
        let profileImageURL: String? = "https://some-image.com"
        let user = makeSUT(favoriteBooks: books, profileImageURL: profileImageURL)

        let validator = Validator<User>()
            .ruleFor(\.age)
            .notEqual(20)
            .ruleFor(\.profileImageURL)
            .notNil()
            .notEqual(profileImageURL)
            .ruleFor(\.favoriteBooks)
            .notEmpty()
            .notEqual(["Alquimista"])
            .build()

        let result = validator.validate(user)

        XCTAssertFalse(result.isValid)
        XCTAssertEqual(validator.validationErrors.count, 3)
        XCTAssertEqual(validator.validationErrors.first, "‘age’ should not be equal to 20.")
        XCTAssertEqual(validator.validationErrors[1], "‘profileImageURL’ should not be equal to \(String(describing: profileImageURL)).")
        XCTAssertEqual(validator.validationErrors.last, "‘favoriteBooks’ should not be equal to \(books).")
    }

    func testObjectNotEqual_onIsValidTrue() throws {
        let books = [String]()
        let profileImageURL: String? = "https://some-image.com"
        let user = makeSUT(favoriteBooks: ["Alquimista"], profileImageURL: profileImageURL)

        let validator = Validator<User>()
            .ruleFor(\.age)
            .notEqual(21)
            .ruleFor(\.profileImageURL)
            .notNil()
            .notEqual("")
            .ruleFor(\.favoriteBooks)
            .notEmpty()
            .notEqual(books)
            .build()

        let result = validator.validate(user)

        XCTAssertTrue(result.isValid)
        XCTAssertEqual(validator.validationErrors.count, 0)
    }

    func testObjectLength_onIsValidFalse() throws {
        let user = makeSUT(name: "foe")

        let validator = Validator<User>()
            .ruleFor(\.name)
            .length(5, 25)
            .ruleFor(\.email)
            .length(0, 5)
            .build()

        let result = validator.validate(user)

        XCTAssertFalse(result.isValid)
        XCTAssertEqual(validator.validationErrors.count, 2)
        XCTAssertEqual(validator.validationErrors.first, "The length of ‘name’ must be between 5 and 25 characters.")
        XCTAssertEqual(validator.validationErrors.last, "The length of ‘email’ must be between 0 and 5 characters.")
    }

    func testObjectLength_onIsValidTrue() throws {
        let user = makeSUT(name: "foe")

        let validator = Validator<User>()
            .ruleFor(\.name)
            .length(3, 25)
            .ruleFor(\.email)
            .length(5, 25)
            .build()

        let result = validator.validate(user)

        XCTAssertTrue(result.isValid)
        XCTAssertEqual(validator.validationErrors.count, 0)
    }

    func testObjectMaxLength_onIsValidFalse() throws {
        let user = makeSUT(name: "some long name")

        let validator = Validator<User>()
            .ruleFor(\.name)
            .maxLength(5)
            .ruleFor(\.email)
            .maxLength(5)
            .build()

        let result = validator.validate(user)

        XCTAssertFalse(result.isValid)
        XCTAssertEqual(validator.validationErrors.count, 2)
        XCTAssertEqual(validator.validationErrors.first, "The length of ‘name’ must be 5 characters or fewer.")
        XCTAssertEqual(validator.validationErrors.last, "The length of ‘email’ must be 5 characters or fewer.")
    }

    func testObjectMaxLength_onIsValidTrue() throws {
        let user = makeSUT(name: "some long name")

        let validator = Validator<User>()
            .ruleFor(\.name)
            .maxLength(25)
            .ruleFor(\.email)
            .maxLength(25)
            .build()

        let result = validator.validate(user)

        XCTAssertTrue(result.isValid)
        XCTAssertEqual(validator.validationErrors.count, 0)
    }

    func testObjectMinLength_onIsValidFalse() throws {
        let user = makeSUT(name: "name")

        let validator = Validator<User>()
            .ruleFor(\.name)
            .minLength(5)
            .ruleFor(\.email)
            .minLength(25)
            .build()

        let result = validator.validate(user)

        XCTAssertFalse(result.isValid)
        XCTAssertEqual(validator.validationErrors.count, 2)
        XCTAssertEqual(validator.validationErrors.first, "The length of ‘name’ must be 5 characters or more.")
        XCTAssertEqual(validator.validationErrors.last, "The length of ‘email’ must be 25 characters or more.")
    }

    func testObjectMinLength_onIsValidTrue() throws {
        let user = makeSUT(name: "a name")

        let validator = Validator<User>()
            .ruleFor(\.name)
            .minLength(5)
            .ruleFor(\.email)
            .minLength(5)
            .build()

        let result = validator.validate(user)

        XCTAssertTrue(result.isValid)
        XCTAssertEqual(validator.validationErrors.count, 0)
    }

    func testObjectCustomValidation_onIsValidFalse() throws {
        let notValidEmail = "mail@hotmail.com"
        let user = makeSUT(name: "a name", email: notValidEmail)

        func isFreeEmail(_ email: String) -> Bool {
            let freeEmailDomains = [
                "gmail.com",
                "yahoo.com",
                "outlook.com",
                "hotmail.com"
            ]
            guard let domain = email.split(separator: "@").last else {
                return false
            }
            let lowercaseDomain = String(domain).lowercased()
            return freeEmailDomains.contains(lowercaseDomain)
        }

        let errorMessage = "This domain email address is not accepted."
        let validator = Validator<User>()
            .ruleFor(\.name)
            .minLength(5)
            .ruleFor(\.email)
            .validate(errorMessage) { isFreeEmail($0) == false }
            .build()

        let result = validator.validate(user)

        XCTAssertFalse(result.isValid)
        XCTAssertEqual(validator.validationErrors.count, 1)
        XCTAssertEqual(validator.validationErrors.first, errorMessage)
    }

    func testObjectValidationMapErrors() throws {
        let user = makeSUT(name: "name")

        let validator = Validator<User>()
            .ruleFor(\.name)
            .minLength(5)
            .equal("another name")
            .ruleFor(\.email)
            .minLength(25)
            .build()

        let result = validator.validate(user)
        XCTAssertFalse(result.isValid)
        let errorForName: [String] = validator.errorFor(keyPath: \.name)
        XCTAssertEqual(
            errorForName,
            [
                "The length of ‘name’ must be 5 characters or more.",
                "‘name’ should be equal to another name."
            ]
        )
    }

    func testObjectValidationMapErrorsForKey_onIsValidFalse() throws {
        let user = makeSUT(name: "name")

        let validator = Validator<User>()
            .ruleFor(\.name)
            .minLength(5)
            .equal("another name")
            .ruleFor(\.email)
            .minLength(25)
            .build()

        let result = validator.validate(user)
        let nameErrors: [String] = validator.errorFor(keyPath: \.name)
        let expectedErrorsForName = [
            "The length of ‘name’ must be 5 characters or more.",
            "‘name’ should be equal to another name."
        ]
        XCTAssertFalse(result.isValid)
        let errorsForName: [String] = validator.errorFor(keyPath: \.name)
        XCTAssertEqual(
            errorsForName,
            expectedErrorsForName
        )
        XCTAssertEqual(nameErrors, expectedErrorsForName)
    }

    func testObjectNumber_onIsValidFalse() throws {
        let user = makeSUT(creditCardNumber: "12121a")

        let validator = Validator<User>()
            .ruleFor(\.creditCardNumber)
            .number()
            .build()

        let result = validator.validate(user)

        XCTAssertFalse(result.isValid)
        XCTAssertEqual(validator.validationErrors.count, 1)
        XCTAssertEqual(validator.validationErrors.first, "‘creditCardNumber‘ is not a valid number.")
    }

    func testObjectNumber_onIsValidTrue() throws {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale.current
        let decimalNumber: Decimal = 1213231/100
        let numberString = numberFormatter.string(for: decimalNumber) ?? ""

        let user = makeSUT(creditCardNumber: numberString)

        let validator = Validator<User>()
            .ruleFor(\.creditCardNumber)
            .number()
            .build()

        let result = validator.validate(user)

        XCTAssertTrue(result.isValid)
        XCTAssertEqual(validator.validationErrors.count, 0)
    }

    func testObjectURL_onIsValidFalse() throws {
        let user = makeSUT(creditCardNumber: "12121a")

        let validator = Validator<User>()
            .ruleFor(\.profileImageURL)
            .url()
            .ruleFor(\.name)
            .url()
            .build()

        let result = validator.validate(user)

        XCTAssertFalse(result.isValid)
        XCTAssertEqual(validator.validationErrors.count, 2)
        XCTAssertEqual(validator.validationErrors.first, "‘profileImageURL‘ is not a valid URL.")
    }
}
