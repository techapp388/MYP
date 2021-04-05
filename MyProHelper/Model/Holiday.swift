//
//  Holiday.swift
//  MyProHelper
//
//  Created by Samir on 12/23/20.
//  Copyright © 2020 Benchmark Computing. All rights reserved.
//

import GRDB

struct Holiday: RepositoryBaseModel, Codable {
   
    var holidayID           : Int?
    var holidayName         : String?
    var year                : Int?
    var actualDate          : Date?
    var dateCelebrated      : Date?
    var dateModified        : Date?
    var removed             : Bool?
    var removedDate         : Date?
    
    init() { }
    
    init(row: GRDB.Row) {
        holidayID               = row[RepositoryConstants.Columns.HOLIDAY_ID]
        holidayName             = row[RepositoryConstants.Columns.HOLIDAY_NAME]
        year                    = row[RepositoryConstants.Columns.YEAR]
        actualDate              = row[RepositoryConstants.Columns.ACTUAL_DATE]
        dateCelebrated          = row[RepositoryConstants.Columns.DATE_CELEBRATED]
        dateModified          = row[RepositoryConstants.Columns.DATE_MODIFIED]
        removed                 = row[RepositoryConstants.Columns.REMOVED]
        dateCelebrated          = row[RepositoryConstants.Columns.REMOVED]
    }
    
    func getDataArray() -> [Any] {
        let formattedActualDate      = DateManager.dateToString(date: actualDate)
        let formattedDateCelebrated  = DateManager.dateToString(date: dateCelebrated)
        let formattedDateModified    = DateManager.dateToString(date: dateModified)
        
        return [
            self.holidayName            as String?  ??  "",
            self.year                   as Int?  ??  0,
            formattedActualDate         as String? ?? "",
            formattedDateCelebrated     as String? ?? "",
            formattedDateModified       as String? ?? "",
        ]
    }
    
    mutating func updateModifyDate() {
            dateModified = Date()
        }
}
