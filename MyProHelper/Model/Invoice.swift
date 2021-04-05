//
//  Invoice.swift
//  MyProHelper
//
//  Created by Deep on 1/31/21.
//  Copyright © 2021 Benchmark Computing. All rights reserved.
//

import Foundation

import GRDB

struct Invoice: RepositoryBaseModel {
    
    var invoiceID                     : Int?
    var customerID                    : Int?
    var jobID                         : Int?
    var description                   : String?
    var priceQuoted                   : Float?
    var priceEstimate                 : Bool?
    var priceFixedPrice               : Bool?
    var invoiceAdjustement            : Float?
    var percentDiscount               : Float?
    var totalInvoiceAmount            : Float?
    var dateCompleted                 : Date?
    var dateCreated                   : Date?
    var dateModified                  : Date?
    var status                        : String?
    var priceExpires                  : Date?
    var isInvoiceCreated              : Date?
    var isInvoiceFinal                : Bool?
    var dateApproved                  : Date?
    var ApprovedBy                    : Int?
    var sampleInvoice                 : Bool?
    var removed                       : Bool?
    var removedDate                   : Date?
    var numberOfAttachments           : Int?
    var customer                      : Customer?
    var job                           : Job?
    
    init() {
        customer    = Customer()
        job         = Job()
        dateCreated = Date()
    }
    
    init(row: GRDB.Row) {
        let column = RepositoryConstants.Columns.self
        
        invoiceID                   = row[column.INVOICE_ID]
        customerID                  = row[column.CUSTOMER_ID]
        jobID                       = row[column.JOB_ID]
        description                 = row[column.DESCRIPTION]
        priceQuoted                 = row[column.PRICE_QUOTED]
        priceEstimate               = row[column.PRICE_ESTIMATE]
        priceFixedPrice             = row[column.PRICE_FIXED_PRICE]
        invoiceAdjustement          = row[column.INVOICE_ADJUSTEMENT]
        percentDiscount             = row[column.PERCENT_DISCOUNT]
        totalInvoiceAmount          = row[column.TOTAL_INVOICE_AMOUNT]
        dateCompleted               = row[column.DATE_COMPLETED]
        dateCreated                 = createDate(with: row[column.DATE_CREATED])
        dateModified                = createDate(with: row[column.DATE_MODIFIED])
        status                      = row[column.STATUS]
        priceExpires                = row[column.PRICE_EXPIRES]
        isInvoiceCreated            = createDate(with: row[column.IS_INVOICE_CREATED])
        isInvoiceFinal              = row[column.IS_INVOICE_FINAL]
        dateApproved                = createDate(with: row[column.DATE_APPROVED])
        ApprovedBy                  = row[column.APPROVED_BY]
        sampleInvoice               = row[column.SAMPLE_INVOICE]
        removed                     = row[column.REMOVED]
        removedDate                 = createDate(with: row[column.REMOVED_DATE])
        numberOfAttachments         = row[column.NUMBER_OF_ATTACHMENTS]
        
        customer                    = Customer(row: row)
        job                         = Job(row: row)

    }
    
    func getCustomerName() -> String {
        return (customer?.customerName ?? "")
    }
    
    private func getYesNo(value: Bool?) -> String {
        guard let value = value else {
            return "Yes".localize
        }
        return (value == true) ? "Yes".localize : "No".localize
    }
    
    func getDataArray() -> [Any] {
        
        return [
            getCustomerName(),
            getStringValue(value: description),
            getFloatValue(value: totalInvoiceAmount),
            getFloatValue(value: priceQuoted),
            getFloatValue(value: invoiceAdjustement),
            getYesNo(value: priceEstimate),
            getStringValue(value: status),
            getYesNo(value: priceFixedPrice),
            getIntValue(value: numberOfAttachments),
            getDateString(date: priceExpires),
            getDateString(date: dateCompleted)
        ]
    }
    
    mutating func updateModifyDate() {
        dateModified = Date()
    }
}
