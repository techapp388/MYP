//
//  ReceiptRepository.swift
//  MyProHelper
//
//
//  Created by Deep on 1/24/21.
//  Copyright © 2021 Benchmark Computing. All rights reserved.
//

import Foundation
import GRDB

class ReceiptRepository: BaseRepository {
    init() {
        super.init(table: .RECEIPTS)
    }

    override func setIdKey() -> String {
        return COLUMNS.RECEIPT_ID
    }
    
    func createReceipt(receipt: Receipt, success: @escaping(_ id: Int64) -> (), failure: @escaping(_ error: Error) -> ()) {
        let arguments: StatementArguments = [
            "customerID"            : receipt.customerId,
            "paymentID"             : receipt.paymentId,
            "invoiceID"             : receipt.invoiceId,
            "amount"                : receipt.amount,
            "dateCreated"           : DateManager.getStandardDateString(date: receipt.dateCreated),
            "dateModified"          : DateManager.getStandardDateString(date: receipt.dateModified),
            "paidInFull"            : receipt.paidInFull,
            "partialPayment"        : receipt.partialPayment,
            "removed"               : receipt.removed,
            "removedDate"           : DateManager.getStandardDateString(date: receipt.removedDate),
            "paymentNote"           : receipt.paymentNote,
            "numberOfAttachments"   : receipt.numberOfAttachment
        ]

        let sql = """
            INSERT INTO \(tableName) (
                \(COLUMNS.CUSTOMER_ID),
                \(COLUMNS.PAYMENT_ID),
                \(COLUMNS.INVOICE_ID),
                \(COLUMNS.AMOUNT),
                \(COLUMNS.DATE_CREATED),
                \(COLUMNS.DATE_MODIFIED),
                \(COLUMNS.PAID_IN_FULL),
                \(COLUMNS.PARTIAL_PAYMENT),
                \(COLUMNS.REMOVED),
                \(COLUMNS.REMOVED_DATE),
                \(COLUMNS.PAYMENT_NOTE),
                \(COLUMNS.NUMBER_OF_ATTACHMENTS))

            VALUES (:customerID,
                    :paymentID,
                    :invoiceID,
                    :amount,
                    :dateCreated,
                    :dateModified,
                    :paidInFull,
                    :partialPayment,
                    :removed,
                    :removedDate,
                    :paymentNote,
                    :numberOfAttachments)
            """
        AppDatabase.shared.executeSQL(sql: sql,
                                      arguments: arguments,
                                      success: { id in
                                        success(id)
                                      },
                                      fail: failure)
    }
    
    func fetchReceipt(showRemoved: Bool, with key: String? = nil, sortBy: ReceiptListField? = nil, sortType: SortType? = nil ,offset: Int, success: @escaping(_ service: [Receipt]) -> (), failure: @escaping(_ error: Error) -> ()) {
        guard let queue = AppDatabase.shared.dbQueue else { return }
        let sortable = makeSortableItems(sortBy: sortBy, sortType: sortType)
        let searchable = makeSearchableItems(key: key)
        let condition = getShowRemoveCondition(showRemoved: showRemoved, searchable: searchable)
        
        let sql = """
        SELECT * FROM \(tableName)
        LEFT JOIN \(TABLES.CUSTOMERS) ON \(tableName).\(COLUMNS.CUSTOMER_ID) = \(TABLES.CUSTOMERS).\(COLUMNS.CUSTOMER_ID)
        LEFT JOIN \(TABLES.INVOICES) ON \(tableName).\(COLUMNS.INVOICE_ID) = \(TABLES.INVOICES).\(COLUMNS.INVOICE_ID)
        \(condition)
        \(sortable)
        LIMIT \(LIMIT) OFFSET \(offset);
        """
        
        do {
            let receipts = try queue.read({ (db) -> [Receipt] in
                var receipts: [Receipt] = []
                let rows = try Row.fetchAll(db,
                                            sql: sql,
                                            arguments: [])
                rows.forEach { (row) in
                    receipts.append(.init(row: row))
                }
                return receipts
            })
            success(receipts)
        }
        catch {
            failure(error)
            print(error)
        }
    }

    private func makeSortableItems(sortBy: ReceiptListField?, sortType: SortType?) -> String {
        guard let sortBy = sortBy, let sortType = sortType else {
            return makeSortableCondition(key:"\(TABLES.CUSTOMERS).\(COLUMNS.CUSTOMER_NAME)",
                                         sortType: .ASCENDING)
        }
        switch sortBy {
        case .CUSTOMER_NAME:
            return makeSortableCondition(key:"\(TABLES.CUSTOMERS).\(COLUMNS.CUSTOMER_NAME)",
                                         sortType: sortType)
        case .INVOICE_DESCRIPTION:
            return makeSortableCondition(key: COLUMNS.DESCRIPTION, sortType: sortType)
        case .AMOUNT:
            return makeSortableCondition(key: COLUMNS.AMOUNT, sortType: sortType)
        case .FULL_PAID:
            return makeSortableCondition(key: COLUMNS.PAID_IN_FULL, sortType: sortType)
        case .PARTIAL_PAYMENT:
            return makeSortableCondition(key: COLUMNS.PARTIAL_PAYMENT, sortType: sortType)
        case .PAYMENT_NOTE:
            return makeSortableCondition(key: COLUMNS.PAYMENT_NOTE, sortType: sortType)
        case .ATTACHMENTS:
            return makeSortableCondition(key: COLUMNS.NUMBER_OF_ATTACHMENTS, sortType: sortType)
        case .CREATED_DATE:
            return makeSortableCondition(key: COLUMNS.DATE_CREATED, sortType: sortType)
        }
    }

    private func makeSearchableItems(key: String?) -> String {
        guard let key = key else { return "" }
        return  makeSearchableCondition(key: key,
                                        fields: [
                                            "\(TABLES.CUSTOMERS).\(COLUMNS.CUSTOMER_NAME)",
                                            "\(TABLES.INVOICES).\(COLUMNS.DESCRIPTION)",
                                            COLUMNS.AMOUNT,
                                            COLUMNS.PAID_IN_FULL,
                                            COLUMNS.PARTIAL_PAYMENT,
                                            COLUMNS.PAYMENT_NOTE,
                                            "\(tableName).\(COLUMNS.NUMBER_OF_ATTACHMENTS)",
                                            COLUMNS.CREATED_DATE
                                            ])
    }
}
