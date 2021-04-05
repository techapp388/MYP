//
//  QuoteRepository.swift
//  MyProHelper
//
//
//  Created by Deep on 1/24/21.
//  Copyright © 2021 Benchmark Computing. All rights reserved.
//

import Foundation
import GRDB

class QuoteRepository: BaseRepository {
    
    init() {
        super.init(table: .QUOTES)
    }
    
    override func setIdKey() -> String {
        return COLUMNS.QUOTE_ID
    }
    
    func fetchQuotes(showRemoved: Bool, with key: String? = nil, sortBy: QuoteEstimateField? = nil, sortType: SortType? = nil ,offset: Int,success: @escaping(_ users: [QuoteEstimate]) -> (), failure: @escaping(_ error: Error) -> ()) {
        
        guard let queue = AppDatabase.shared.dbQueue else { return }
        let sortable = makeSortableItems(sortBy: sortBy, sortType: sortType)
        let searchable = makeSearchableItems(key: key)
        let condition = getShowRemoveCondition(showRemoved: showRemoved, searchable: searchable)
        
        let sql = """
        SELECT * FROM \(tableName)
        LEFT JOIN \(TABLES.CUSTOMERS) ON \(tableName).\(COLUMNS.CUSTOMER_ID) == \(TABLES.CUSTOMERS).\(COLUMNS.CUSTOMER_ID)
            \(condition)
            \(sortable)
        LIMIT \(LIMIT) OFFSET \(offset);
        """
        
        do {
            let quotes = try queue.read({ (db) -> [QuoteEstimate] in
                var quotes: [QuoteEstimate] = []
                let rows = try Row.fetchAll(db,
                                            sql: sql,
                                            arguments: [])
                rows.forEach { (row) in
                    quotes.append(.init(row: row))
                }
                return quotes
            })
            success(quotes)
        }
        catch {
            failure(error)
            print(error)
        }
    }
    
    func insertQuote(quote: QuoteEstimate, success: @escaping(_ quoteId: Int64) -> (), failure: @escaping(_ error: Error) -> ()) {
        let arguments: StatementArguments = [
            "customerID"            : quote.customerID,
            "description"           : quote.description,
            "priceQuoted"           : quote.priceQuoted,
            "priceEstimate"         : quote.priceEstimate,
            "priceFixedPrice"       : quote.priceFixedPrice,
            "dateCreated"           : DateManager.getStandardDateString(date: quote.dateCreated),
            "dateModified"          : DateManager.getStandardDateString(date: quote.dateModified),
            "priceExpires"          : quote.priceExpires,
            "sampleQuote"           : quote.sampleQuote,
            "removed"               : quote.removed,
            "removedDate"           : DateManager.getStandardDateString(date: quote.removedDate),
            "numberOfAttachments"   : quote.numberOfAttachments
        ]
        
        let sql = """
            INSERT INTO \(tableName) (
                \(COLUMNS.CUSTOMER_ID),
                \(COLUMNS.DESCRIPTION),
                \(COLUMNS.PRICE_QUOTED),
                \(COLUMNS.PRICE_ESTIMATE),
                \(COLUMNS.PRICE_FIXED_PRICE),
                \(COLUMNS.DATE_CREATED),
                \(COLUMNS.DATE_MODIFIED),
                \(COLUMNS.PRICE_EXPIRES),
                \(COLUMNS.SAMPLE_QOUTE),
                \(COLUMNS.REMOVED),
                \(COLUMNS.REMOVED_DATE),
                \(COLUMNS.NUMBER_OF_ATTACHMENTS)
            )

            VALUES (:customerID,
                    :description,
                    :priceQuoted,
                    :priceEstimate,
                    :priceFixedPrice,
                    :dateCreated,
                    :dateModified,
                    :priceExpires,
                    :sampleQuote,
                    :removed,
                    :removedDate,
                    :numberOfAttachments
            )
            """
        AppDatabase.shared.executeSQL(sql: sql,
                                     arguments: arguments,
                                     success: { id in
                                        success(id)
                                     },
                                     fail: failure)
    }
    
    func updateQuote(quote: QuoteEstimate, success: @escaping() -> (), failure: @escaping(_ error: Error) -> ())
    {
        let arguments: StatementArguments = [
            "id"                    : quote.quoteId,
            "customerID"            : quote.customerID,
            "description"           : quote.description,
            "priceQuoted"           : quote.priceQuoted,
            "priceEstimate"         : quote.priceEstimate,
            "priceFixedPrice"       : quote.priceFixedPrice,
            "dateCreated"           : DateManager.getStandardDateString(date: quote.dateCreated),
            "dateModified"          : DateManager.getStandardDateString(date: quote.dateModified),
            "priceExpires"          : quote.priceExpires,
            "sampleQuote"           : quote.sampleQuote,
            "removed"               : quote.removed,
            "removedDate"           : DateManager.getStandardDateString(date: quote.removedDate),
            "numberOfAttachments"   : quote.numberOfAttachments
        ]
        
        let sql = """
            UPDATE \(tableName) SET
                \(COLUMNS.CUSTOMER_ID)              = :customerID,
                \(COLUMNS.DESCRIPTION)              = :description,
                \(COLUMNS.PRICE_QUOTED)             = :priceQuoted,
                \(COLUMNS.PRICE_ESTIMATE)           = :priceEstimate,
                \(COLUMNS.PRICE_FIXED_PRICE)        = :priceFixedPrice,
                \(COLUMNS.DATE_CREATED)             = :dateCreated,
                \(COLUMNS.DATE_MODIFIED)            = :dateModified,
                \(COLUMNS.PRICE_EXPIRES)            = :priceExpires,
                \(COLUMNS.SAMPLE_QOUTE)             = :sampleQuote,
                \(COLUMNS.REMOVED)                  = :removed,
                \(COLUMNS.REMOVED_DATE)             = :removedDate,
                \(COLUMNS.NUMBER_OF_ATTACHMENTS)    = :numberOfAttachments
            WHERE \(tableName).\(setIdKey()) = :id;
            """
        
        AppDatabase.shared.executeSQL(sql: sql,
                                     arguments: arguments,
                                     success: { _ in
                                        success()
                                     },
                                     fail: failure)
    }
    
    func deleteQuote(quote: QuoteEstimate, success: @escaping() -> (), failure: @escaping(_ error: Error) -> ()) {
        guard let id = quote.quoteId else { return }
        softDelete(atId: id, success: success, fail: failure)
    }
    
    func restoreQuote(quote: QuoteEstimate, success: @escaping() -> (), failure: @escaping(_ error: Error) -> ()) {
        guard let id = quote.quoteId else { return }
        restoreItem(atId: id, success: success, fail: failure)
    }
    
    
    private func makeSortableItems(sortBy: QuoteEstimateField?, sortType: SortType?) -> String {
        guard let sortBy = sortBy, let sortType = sortType else {
            return makeSortableCondition(key: COLUMNS.CUSTOMER_NAME, sortType: .ASCENDING)
        }
        switch sortBy {
            case .CUSOTMER_NAME:
                return makeSortableCondition(key: COLUMNS.CUSTOMER_NAME, sortType: sortType)
            case .DESCRIPTION:
                return makeSortableCondition(key: COLUMNS.DESCRIPTION, sortType: sortType)
            case .PRICE_QUOTED:
                return makeSortableCondition(key: COLUMNS.PRICE_QUOTED, sortType: sortType)
            case .PRICE_ESTIMATE:
                return makeSortableCondition(key: COLUMNS.PRICE_ESTIMATE, sortType: sortType)
            case .FIXED_PRICE:
                return makeSortableCondition(key: COLUMNS.PRICE_FIXED_PRICE, sortType: sortType)
            case .QUOTE_EXPIRATION:
                return makeSortableCondition(key: COLUMNS.PRICE_EXPIRES, sortType: sortType)
            case .ATTACHMENTS:
                return makeSortableCondition(key: COLUMNS.NUMBER_OF_ATTACHMENTS, sortType: sortType)
        }
    }
    
    private func makeSearchableItems(key: String?) -> String {
        guard let key = key else { return "" }
        return makeSearchableCondition(key: key,
                                       fields: [
                                        COLUMNS.CUSTOMER_NAME,
                                        COLUMNS.DESCRIPTION,
                                        COLUMNS.PRICE_QUOTED,
                                        COLUMNS.PRICE_ESTIMATE,
                                        COLUMNS.PRICE_FIXED_PRICE,
                                        COLUMNS.PRICE_EXPIRES,
                                        COLUMNS.NUMBER_OF_ATTACHMENTS])
    }
}
