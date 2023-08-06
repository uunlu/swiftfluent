//
//  Utilities.swift
//  SwiftFluentTests
//
//  Created by Ugur Unlu on 06/08/2023.
//

import Foundation

internal func makeSUT(
    name: String = "a name",
    age: Int = 20,
    email: String = "some@mail.com",
    creditCardNumber: String = "",
    favoriteBooks: [String] = [],
    profileImageURL: String? = nil
) -> User {
    User(
        name: name,
        age: age,
        email: email,
        creditCardNumber: creditCardNumber,
        favoriteBooks: favoriteBooks,
        profileImageURL: profileImageURL
    )
}

internal struct User {
    let name: String
    let age: Int
    let email: String
    let creditCardNumber: String
    let favoriteBooks: [String]
    let profileImageURL: String?
}
