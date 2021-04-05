//
//  JobDetail.swift
//  MyProHelper
//
//
//  Created by Deep on 1/31/21.
//  Copyright © 2021 Benchmark Computing. All rights reserved.
//

import GRDB

struct JobDetail: RepositoryBaseModel {

    var jobDetailID              : Int?
    var jobID                    : Int?
    var customerID               : Int?
    var details                  : String?
    var createdBy                : Int?
    var createdDate              : Date?
    var modifiedBy               : Int?
    var modifiedDate             : Date?
    var removed                  : Bool?
    var removedDate              : Date?
    var numberOfAttachments      : Int?
    var customer                 : Customer?
    var scheduledJob             : Job?
    var worker                   : Worker?
    
    init() {
        createdDate          = Date()
        customer             = Customer()
        scheduledJob         = Job()
        worker               = Worker()
    }
    
    init(row: GRDB.Row) {
        let column = RepositoryConstants.Columns.self
        
        jobDetailID            = row[column.JOB_DETAIL_ID]
        jobID                  = row[column.JOB_ID]
        customerID             = row[column.CUSTOMER_ID]
        details                = row[column.DETAILS]
        createdBy              = row[column.CREATED_BY]
        createdDate            = createDate(with: row[column.CREATED_DATE])
        modifiedBy             = row[column.MODIFIED_BY]
        modifiedDate           = createDate(with: row[column.MODIFIED_DATE])
        removed                = row[column.REMOVED]
        removedDate            = createDate(with: row[column.REMOVED_DATE])
        numberOfAttachments    = row[column.NUMBER_OF_ATTACHMENTS]
        customer               = Customer(row: row)
        scheduledJob           = Job(row: row)
        worker                 = Worker(row: row)
    }
    
    func getDataArray() -> [Any] {
        
        return [
            getStringValue(value: customer?.customerName),
            getStringValue(value: scheduledJob?.jobShortDescription),
            getStringValue(value: details),
            getDateString(date: createdDate),
            getIntValue(value: numberOfAttachments)
        ]
    }
    
    mutating func updateModifyDate() {
        modifiedDate = Date()
    }
}

