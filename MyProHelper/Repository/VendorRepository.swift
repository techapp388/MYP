//
//  VendorDBService.swift
//  MyProHelper
//
//
//  Created by Rajeev Verma on 10/06/1942 Saka.
//  Copyright © 2020 Benchmark Computing. All rights reserved.
//

import Foundation
import GRDB

class VendorRepository: BaseRepository {
    
    init() {
        super.init(table: .VENDORS)
        createSelectedLayoutTable()
    }
    
    override func setIdKey() -> String {
        return COLUMNS.VENDOR_ID
    }
    
    private func createSelectedLayoutTable() {
        let sql = """
            CREATE TABLE IF NOT EXISTS \(tableName)(
                \(COLUMNS.VENDOR_ID) INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE NOT NULL,
                \(COLUMNS.VENDOR_NAME)              TEXT,
                \(COLUMNS.PHONE)                    TEXT,
                \(COLUMNS.EMAIL)                    TEXT,
                \(COLUMNS.CONTACT_NAME)             TEXT,
                \(COLUMNS.ACCOUNT_NUMBER)           TEXT,
                \(COLUMNS.MOST_RECENT_COTACT)       TEXT,
                \(COLUMNS.SAMPLE_VENDOR)            INTEGER DEFAULT(0),
                \(COLUMNS.NUMBER_OF_ATTACHMENTS)    INTEGER DEFAULT(0),
                \(COLUMNS.REMOVED)                  INTEGER DEFAUßLT(0),
                \(COLUMNS.REMOVED_DATE)             TEXT
            )
        """
        AppDatabase.shared.executeSQL(sql: sql,
                                      arguments: []) { (_) in
            print("TABLE VENDORS IS CREATED SUCCESSFULLY")
        } fail: { (error) in
            print(error)
        }
    }
    
    func insertVendor(vendor: Vendor, success: @escaping(_ vendorId: Int64) -> (), failure: @escaping(_ error: Error) -> ()) {
        let arguments: StatementArguments = [
            "vendorName"            : vendor.vendorName,
            "phone"                 : vendor.phone,
            "email"                 : vendor.email,
            "contactName"           : vendor.contactName,
            "accountNumber"         : vendor.accountNumber,
            "mostRecentContact"     : DateManager.getStandardDateString(date: vendor.mostRecentContact),
            "numberOfAttachments"   : vendor.numberOfAttachments,
            "removed"               : vendor.removed,
            "removedDate"           : DateManager.getStandardDateString(date: vendor.removedDate)
        ]
        let sql = """
            INSERT INTO \(tableName) (
                \(COLUMNS.VENDOR_NAME),
                \(COLUMNS.PHONE),
                \(COLUMNS.EMAIL),
                \(COLUMNS.CONTACT_NAME),
                \(COLUMNS.ACCOUNT_NUMBER),
                \(COLUMNS.MOST_RECENT_COTACT),
                \(COLUMNS.NUMBER_OF_ATTACHMENTS),
                \(COLUMNS.REMOVED),
                \(COLUMNS.REMOVED_DATE)

            )

            VALUES (:vendorName,
                    :phone,
                    :email,
                    :contactName,
                    :accountNumber,
                    :mostRecentContact,
                    :numberOfAttachments,
                    :removed,
                    :removedDate
            )
            """
        AppDatabase.shared.executeSQL(sql: sql,
                                     arguments: arguments,
                                     success: { id in
                                        success(id)
                                     },
                                     fail: failure)
    }
    
    func update(vendor: Vendor, success: @escaping() -> (), failure: @escaping(_ error: Error) -> ()) {
        let arguments: StatementArguments = [
            "id"                    : vendor.vendorID,
            "vendorName"            : vendor.vendorName,
            "phone"                 : vendor.phone,
            "email"                 : vendor.email,
            "contactName"           : vendor.contactName,
            "accountNumber"         : vendor.accountNumber,
            "mostRecentContact"     : DateManager.getStandardDateString(date: vendor.mostRecentContact),
            "numberOfAttachments"   : vendor.numberOfAttachments,
            "removed"               : vendor.removed,
            "removedDate"           : DateManager.getStandardDateString(date: vendor.removedDate)
        ]
        let sql = """
            UPDATE \(tableName) SET
                \(COLUMNS.VENDOR_NAME)              = :vendorName,
                \(COLUMNS.PHONE)                    = :phone,
                \(COLUMNS.EMAIL)                    = :email,
                \(COLUMNS.CONTACT_NAME)             = :contactName,
                \(COLUMNS.ACCOUNT_NUMBER)           = :accountNumber,
                \(COLUMNS.MOST_RECENT_COTACT)       = :mostRecentContact,
                \(COLUMNS.NUMBER_OF_ATTACHMENTS)    = :numberOfAttachments,
                \(COLUMNS.REMOVED)                  = :removed,
                \(COLUMNS.REMOVED_DATE)             = :removedDate
            WHERE \(tableName).\(setIdKey()) = :id;
            """
        
        AppDatabase.shared.executeSQL(sql: sql,
                                     arguments: arguments,
                                     success: { _ in
                                        success()
                                     },
                                     fail: failure)
    }
    
    func deleteVendor(vendor: Vendor, success: @escaping() -> (), failure: @escaping(_ error: Error) -> ()) {
        guard let id = vendor.vendorID else { return }
        softDelete(atId: id, success: success, fail: failure)
    }
    
    func restoreVendor(vendor: Vendor, success: @escaping() -> (), failure: @escaping(_ error: Error) -> ()) {
        guard let id = vendor.vendorID else { return }
        restoreItem(atId: id, success: success, fail: failure)
    }
    
    func fetchVendors(showRemoved: Bool, with key: String? = nil, sortBy: VendorField? = nil, sortType: SortType? = nil ,offset: Int,success: @escaping(_ users: [Vendor]) -> (), failure: @escaping(_ error: Error) -> ()) {
        guard let queue = AppDatabase.shared.dbQueue else { return }
        let sortable = makeSortableItems(sortBy: sortBy, sortType: sortType)
        let searchable = makeSearchableItems(key: key)
        let removedCondition = """
        WHERE (\(tableName).\(COLUMNS.REMOVED) = 0
        OR \(tableName).\(COLUMNS.REMOVED) is NULL)
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
        \(condition)
        \(sortable)
        LIMIT \(LIMIT) OFFSET \(offset);
        """
        
        do {
            let vendors = try queue.read({ (db) -> [Vendor] in
                var vendors: [Vendor] = []
                let rows = try Row.fetchAll(db,
                                            sql: sql,
                                            arguments: [])
                rows.forEach { (row) in
                    vendors.append(.init(row: row))
                }
                return vendors
            })
            success(vendors)
        }
        catch {
            failure(error)
            print(error)
        }
    }
    
    private func makeSortableItems(sortBy: VendorField?, sortType: SortType?) -> String {
        guard let sortBy = sortBy, let sortType = sortType else {
            return makeSortableCondition(key: COLUMNS.VENDOR_NAME, sortType: .ASCENDING)
        }
        switch sortBy {
        case .VENDOR_NAME:
            return makeSortableCondition(key: COLUMNS.VENDOR_NAME, sortType: sortType)
        case .PHONE:
            return makeSortableCondition(key: COLUMNS.PHONE, sortType: sortType)
        case .EMAIL:
            return makeSortableCondition(key: COLUMNS.EMAIL, sortType: sortType)
        case .CONTACT_NAME:
            return makeSortableCondition(key: COLUMNS.CONTACT_NAME, sortType: sortType)
        case .ACCOUNT_NUMBER:
            return makeSortableCondition(key: COLUMNS.ACCOUNT_NUMBER, sortType: sortType)
        case .RECENT_CONTACT:
            return makeSortableCondition(key: COLUMNS.MOST_RECENT_COTACT, sortType: sortType)
        case .ATTACHMENTS:
            return makeSortableCondition(key: COLUMNS.NUMBER_OF_ATTACHMENTS, sortType: sortType)
        }
    }
    
    private func makeSearchableItems(key: String?) -> String {
        guard let key = key else { return "" }
        return makeSearchableCondition(key: key,
                                       fields: [
                                        COLUMNS.VENDOR_NAME,
                                        COLUMNS.PHONE,
                                        COLUMNS.EMAIL,
                                        COLUMNS.CONTACT_NAME,
                                        COLUMNS.ACCOUNT_NUMBER,
                                        COLUMNS.MOST_RECENT_COTACT,
                                        COLUMNS.NUMBER_OF_ATTACHMENTS])
    }
}
