//
//  PartsDBService.swift
//  MyProHelper
//
//
//  Created by Rajeev Verma on 10/06/1942 Saka.
//  Copyright © 2020 Benchmark Computing. All rights reserved.
//

import GRDB

class PartRepository: BaseRepository {
    
    
    init() {
        super.init(table: .PARTS)
        createSelectedLayoutTable()
    }
    
    override func setIdKey() -> String {
        return COLUMNS.PART_ID
    }
    private func createSelectedLayoutTable() {
       let sql = """
            CREATE TABLE IF NOT EXISTS \(tableName)(
                \(COLUMNS.PART_ID)  INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE NOT NULL,
                \(COLUMNS.PART_NAME)                TEXT,
                \(COLUMNS.DESCRIPTION)              TEXT,
                \(COLUMNS.SAMPLE_PART)              INTEGER DEFAULT(0),
                \(COLUMNS.CREATED_DATE)             TEXT,
                \(COLUMNS.MODIFIED_DATE)            TEXT,
                \(COLUMNS.REMOVED)                  INTEGER DEFAULT(0),
                \(COLUMNS.REMOVED_DATE)             TEXT,
                \(COLUMNS.NUMBER_OF_ATTACHMENTS)    INTEGER DEFAULT(0))
        """
        AppDatabase.shared.executeSQL(sql: sql,
                                      arguments: []) { (_) in
            print("TABLE PARTS IS CREATED SUCCESSFULLY")
        } fail: { (error) in
            print(error)
        }
    }
    
    func insertPart(part: Part, success: @escaping(_ partID: Int64) -> (), failure: @escaping(_ error: Error) -> ()) {
        let arguments: StatementArguments = [
            "partName"              : part.partName,
            "description"           : part.description,
            "dateCreated"           : DateManager.getStandardDateString(date: part.dateCreated),
            "dateModified"          : DateManager.getStandardDateString(date: part.dateModified),
            "removed"               : part.removed,
            "removedDate"           : DateManager.getStandardDateString(date: part.removedDate),
            "numberOfAttachments"   : part.numberOfAttachments
        ]
        let sql = """
            INSERT INTO \(tableName) (
                \(COLUMNS.PART_NAME),
                \(COLUMNS.DESCRIPTION),
                \(COLUMNS.CREATED_DATE),
                \(COLUMNS.MODIFIED_DATE),
                \(COLUMNS.REMOVED),
                \(COLUMNS.REMOVED_DATE),
                \(COLUMNS.NUMBER_OF_ATTACHMENTS))

            VALUES (:partName,
                    :description,
                    :dateCreated,
                    :dateModified,
                    :removed,
                    :removedDate,
                    :numberOfAttachments)
            """
        AppDatabase.shared.executeSQL(sql: sql,
                                     arguments: arguments,
                                     success: { id in
                                        success(id)
                                     },
                                     fail: failure)
    }
    
    func update(part: Part, success: @escaping() -> (), failure: @escaping(_ error: Error) -> ()) {
        let arguments: StatementArguments = [
            "id"                    : part.partID,
            "partName"              : part.partName,
            "description"           : part.description,
            "dateCreated"           : DateManager.getStandardDateString(date: part.dateCreated),
            "dateModified"          : DateManager.getStandardDateString(date: part.dateModified),
            "removed"               : part.removed,
            "removedDate"           : DateManager.getStandardDateString(date: part.removedDate),
            "numberOfAttachments"   : part.numberOfAttachments
        ]
        let sql = """
            UPDATE \(tableName) SET
                \(COLUMNS.PART_NAME)                = :partName,
                \(COLUMNS.DESCRIPTION)              = :description,
                \(COLUMNS.CREATED_DATE)             = :dateCreated,
                \(COLUMNS.MODIFIED_DATE)            = :dateModified,
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
    
    func removePart(part: Part, success: @escaping() -> (), failure: @escaping(_ error: Error) -> ()) {
        guard let id = part.partID else {
                return
        }
        softDelete(atId: id, success: success, fail: failure)
    }
    
    func unremovePart(part: Part, success: @escaping() -> (), failure: @escaping(_ error: Error) -> ()) {
        guard let id = part.partID else {
                return
        }
        restoreItem(atId: id, success: success, fail: failure)
    }
    
    func fetchPart(with id: Int,success: @escaping(_ parts: Part?) -> (), failure: @escaping(_ error: Error) -> ()){
        guard let queue = AppDatabase.shared.dbQueue else { return }
        let sql = """
        SELECT * FROM \(tableName)
        LEFT JOIN \(TABLES.PART_FINDERS) ON \(tableName).\(COLUMNS.PART_ID) == \(TABLES.PART_FINDERS).\(COLUMNS.PART_ID)
        LEFT JOIN \(TABLES.VENDORS) ON \(TABLES.PART_FINDERS).\(COLUMNS.WHERE_PURCHASED) == \(TABLES.VENDORS).\(COLUMNS.VENDOR_ID)
        LEFT JOIN \(TABLES.PART_LOCATIONS) ON \(TABLES.PART_FINDERS).\(COLUMNS.PART_LOCATION_ID) == \(TABLES.PART_LOCATIONS).\(COLUMNS.PART_LOCATION_ID);
        WHERE \(tableName).\(COLUMNS.PART_ID) = ?
        """
        
        do {
            let part = try queue.read({ (db) -> Part? in
                if let row = try Row.fetchOne(db,
                                  sql: sql,
                                  arguments: [id]) {
                    return Part(row: row)
                }
                return nil
            })
            success(part)
        }
        catch {
            failure(error)
            print(error)
        }
    }
    
    func fetchPart(showRemoved: Bool, with key: String? = nil, sortBy: PartField? = nil, sortType: SortType? = nil ,offset: Int,success: @escaping(_ parts: [Part]) -> (), failure: @escaping(_ error: Error) -> ()) {
        guard let queue = AppDatabase.shared.dbQueue else { return }
        let sortable = makeSortableItems(sortBy: sortBy, sortType: sortType)
        let searchable = makeSearchableItems(key: key)
        let removedCondition = """
                WHERE (\(tableName).\(COLUMNS.REMOVED) = 0
                OR \(tableName).\(COLUMNS.REMOVED) is NULL)
                AND (\(TABLES.PART_FINDERS).\(COLUMNS.REMOVED) = 0
                OR \(TABLES.PART_FINDERS).\(COLUMNS.REMOVED) is NULL)
                AND \(tableName).\(COLUMNS.PART_NAME) != '--SELECT--'
            """
        var condition = ""
        if showRemoved {
            condition = (searchable.isEmpty) ? "" : "WHERE \(searchable)"
        }
        else {
            condition = (searchable.isEmpty) ? removedCondition : """
                \(removedCondition)
                AND \(searchable)
            """
        }
        let sql = """
        SELECT * FROM \(tableName)
        LEFT JOIN \(TABLES.PART_FINDERS) ON \(tableName).\(COLUMNS.PART_ID) == \(TABLES.PART_FINDERS).\(COLUMNS.PART_ID)
        LEFT JOIN \(TABLES.VENDORS) ON \(TABLES.PART_FINDERS).\(COLUMNS.WHERE_PURCHASED) == \(TABLES.VENDORS).\(COLUMNS.VENDOR_ID)
        LEFT JOIN \(TABLES.PART_LOCATIONS) ON \(TABLES.PART_FINDERS).\(COLUMNS.PART_LOCATION_ID) == \(TABLES.PART_LOCATIONS).\(COLUMNS.PART_LOCATION_ID)
        \(condition)
        \(sortable)
        LIMIT \(LIMIT) OFFSET \(offset);
        """
        
        do {
            let parts = try queue.read({ (db) -> [Part] in
                var parts: [Part] = []
                let rows = try Row.fetchAll(db,
                                            sql: sql,
                                            arguments: [])
                rows.forEach { (row) in
                    parts.append(.init(row: row))
                }
                return parts
            })
            success(parts)
        }
        catch {
            failure(error)
            print(error)
        }
    }
    
    private func makeSortableItems(sortBy: PartField?, sortType: SortType?) -> String {
        guard let sortBy = sortBy, let sortType = sortType else {
            return makeSortableCondition(key: COLUMNS.PART_NAME, sortType: .ASCENDING)
        }
        switch sortBy {
        case .PART_NAME:
            return makeSortableCondition(key: COLUMNS.PART_NAME, sortType: sortType)
        case .DESCRIPTION:
            return makeSortableCondition(key: COLUMNS.DESCRIPTION, sortType: sortType)
        case .PURCHASED_FROM:
            return makeSortableCondition(key: COLUMNS.VENDOR_NAME, sortType: sortType)
        case .PART_LOCATION:
            return makeSortableCondition(key: COLUMNS.LOCATION_NAME, sortType: sortType)
        case .QUANTITY:
            return makeSortableCondition(key: COLUMNS.QUANTITY, sortType: sortType)
        case .PRICE_PAID:
            return makeSortableCondition(key: COLUMNS.PRICE_PAID, sortType: sortType)
        case .PRICE_TO_RESELL:
            return makeSortableCondition(key: COLUMNS.PRICE_TO_RESELL, sortType: sortType)
        case .WAITING_COUNT:
            return ""
        case .PURCHASED_DATE:
            return makeSortableCondition(key: COLUMNS.LAST_PURHCASED, sortType: sortType)
        case .ATTACHMENTS:
            return makeSortableCondition(key: COLUMNS.NUMBER_OF_ATTACHMENTS, sortType: sortType)
        }
    }
    
    private func makeSearchableItems(key: String?) -> String {
        guard let key = key else { return "" }
        return makeSearchableCondition(key: key,
                                       fields: [
                                        COLUMNS.PART_NAME,
                                        COLUMNS.DESCRIPTION,
                                        COLUMNS.VENDOR_NAME,
                                        COLUMNS.LOCATION_NAME,
                                        COLUMNS.QUANTITY,
                                        COLUMNS.PRICE_PAID,
                                        COLUMNS.PRICE_TO_RESELL,
                                        COLUMNS.LAST_PURHCASED,
                                        "\(tableName).\(COLUMNS.NUMBER_OF_ATTACHMENTS)"])
    }
}
