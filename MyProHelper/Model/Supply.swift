//
//  Supply.swift
//  MyProHelper
//
//
//  Created by Deep on 1/31/21.
//  Copyright © 2021 Benchmark Computing. All rights reserved.
//

import GRDB

struct Supply: RepositoryBaseModel {
    
    var supplyId              : Int?
    var supplyName            : String?
    var description         : String?
    var removed             : Bool?
    var removedDate         : Date?
    var numberOfAttachments : Int?
    
    init() { }
    
    init(row: GRDB.Row) {
        let column = RepositoryConstants.Columns.self
        
        supplyId               = row[column.SUPPLY_ID]
        supplyName             = row[column.SUPPLY_NAME]
        description            = row[column.DESCRIPTION]
        removed                = row[column.REMOVED]
        removedDate            = createDate(with: column.REMOVED_DATE)
        numberOfAttachments    = row[column.NUMBER_OF_ATTACHMENTS]
    }
    
    func getDataArray() -> [Any] {
        return [
            getStringValue(value: supplyName),
            getStringValue(value: description),
            getIntValue(value: numberOfAttachments)
        ]
    }
}
