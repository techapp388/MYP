//
//  RepositoryBaseModel.swift
//  MyProHelper
//
//  Created by Samir on 12/10/20.
//  Copyright © 2020 Benchmark Computing. All rights reserved.
//

import GRDB

protocol RepositoryBaseModel {
    var removed: Bool? { get set }
    init(row: Row)
    func getDataArray() -> [Any]
}

extension RepositoryBaseModel {

    func createDate(with value: DatabaseValueConvertible?) -> Date? {
        return DateManager.stringToDate(string: value as? String ?? "")
    }

    func getDateString(date: Date?) -> String {
        return DateManager.dateToString(date: date)
    }

    func getStringValue(value: String?) -> String {
        return value as String? ?? ""
    }

    func getFloatValue(value: Float?) -> Float {
        return value as Float? ?? 0.0
    }

    func getDoubleValue(value: Double?) -> Double {
        return value as Double? ?? 0.0
    }
    
    func  getIntValue(value: Int?) -> Int {
        return value as Int? ?? 0
    }
    
    func getYesNo(value: Bool?) -> String {
        guard let value = value else {
            return "Yes".localize
        }
        return (value == true) ? "Yes".localize : "No".localize
    }
}
