//
//  KeyPath+Extensions.swift
//  SwiftFluent
//
//  Created by Ugur Unlu on 02/08/2023.
//

import Foundation

extension KeyPath {
    var propertyName: String {
        String(describing: self).components(separatedBy: ".").last ?? "Unknown"
    }
}
