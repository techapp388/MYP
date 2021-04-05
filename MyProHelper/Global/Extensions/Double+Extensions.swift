//
//  Double+Extensions.swift
//  MyProHelper
//
//

import Foundation

extension Double {
    var stringValue: String {
        get {
            return String(format: "%.2f", self)
        }
    }
}
