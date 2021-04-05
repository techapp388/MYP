//
//  SupplyUsedRepository.swift
//  MyProHelper
//
//
//  Created by Deep on 1/24/21.
//  Copyright © 2021 Benchmark Computing. All rights reserved.
//

import GRDB

class SupplyUsedRepositorry: BaseRepository {
    
    init() {
        super.init(table: .SUPPLIES_USED)
     // createSelectedLayoutTable()
    }
 
    override func setIdKey() -> String {
        return COLUMNS.SUPPLY_USED_ID
    }
    
    func fetchSuppliesUsed(invoiceId: Int? = nil, offset: Int, success: @escaping(_ supplies: [SupplyUsed]) -> (), failure: @escaping(_ error: Error) -> ()) {
        guard let queue = AppDatabase.shared.dbQueue else { return }
        guard let invoiceId = invoiceId else { return }
        
        let arguments: StatementArguments = []
        
        let sql = """
        SELECT * FROM \(tableName)
        LEFT JOIN \(TABLES.SUPPLIES) ON \(tableName).\(COLUMNS.SUPPLY_ID) ==  \(TABLES.SUPPLIES).\(COLUMNS.SUPPLY_ID)
        LEFT JOIN \(TABLES.SUPPLY_LOCATIONS) ON \(tableName).\(COLUMNS.SUPPLY_LOCATION_ID) ==  \(TABLES.SUPPLY_LOCATIONS).\(COLUMNS.SUPPLY_LOCATION_ID)
        LEFT JOIN \(TABLES.VENDORS) ON \(tableName).\(COLUMNS.WHERE_PURCHASED) ==  \(TABLES.VENDORS).\(COLUMNS.VENDOR_ID)
        WHERE \(tableName).\(COLUMNS.INVOICE_ID) == \(invoiceId)
        """

        do {
            let supplies = try queue.read({ (db) -> [SupplyUsed] in
                var supplies: [SupplyUsed] = []
                let rows = try Row.fetchAll(db,
                                            sql: sql,
                                            arguments: arguments)
                rows.forEach { (row) in
                    supplies.append(.init(row: row))
                }
                return supplies
            })
            success(supplies)
        }
        catch {
            failure(error)
            print(error)
        }
    }
    
    func addSupplyUsed(supply: SupplyUsed, success: @escaping (_ supplyUsedId: Int64)->(), failure: @escaping (_ error: Error)->()) {

        let arguments: StatementArguments = [
            "supplyId"              : supply.supplyId,
            "supplyFinderId"        : supply.supplyFinderId,
            "InvoiceId"             : supply.InvoiceId,
            "supplyName"            : supply.supplyName,
            "priceToResell"         : supply.priceToResell,
            "quantity"              : supply.quantity,
            "supplyLocationId"      : supply.supplyLocationId,
            "supplyLocationName"    : supply.supplyLocationName,
            "wherePurchased"        : supply.wherePurchased,
            "vendorName"            : supply.vendorName,
            "waitingForSupply"      : supply.waitingForSupply,
            "countWaitingFor"       : supply.countWaitingFor,
            "dateAdded"             : DateManager.getStandardDateString(date: supply.dateAdded),
            "dateModified"          : DateManager.getStandardDateString(date: supply.dateModified),
            "removed"               : supply.removed,
            "removedDate"           : DateManager.getStandardDateString(date: supply.removedDate)
            
        ]
        let sql = """
            INSERT INTO \(tableName) (
                \(COLUMNS.SUPPLY_ID),
                \(COLUMNS.SUPPLY_FINDER_ID),
                \(COLUMNS.INVOICE_ID),
                \(COLUMNS.SUPPLY_NAME),
                \(COLUMNS.PRICE_TO_RESELL),
                \(COLUMNS.QUANTITY),
                \(COLUMNS.SUPPLY_LOCATION_ID),
                \(COLUMNS.SUPPLY_LOCATION_NAME),
                \(COLUMNS.WHERE_PURCHASED),
                \(COLUMNS.VENDOR_NAME),
                \(COLUMNS.WAITING_FOR_SUPPLY),
                \(COLUMNS.COUNT_WAITING_FOR),
                \(COLUMNS.DATE_ADDED),
                \(COLUMNS.DATE_MODIFIED),
                \(COLUMNS.REMOVED),
                \(COLUMNS.REMOVED_DATE))

            VALUES (:supplyId,
                    :supplyFinderId,
                    :InvoiceId,
                    :supplyName,
                    :priceToResell,
                    :quantity,
                    :supplyLocationId,
                    :supplyLocationName,
                    :wherePurchased,
                    :vendorName,
                    :waitingForSupply,
                    :countWaitingFor,
                    :dateAdded,
                    :dateModified,
                    :removed,
                    :removedDate)
            """
        
        AppDatabase.shared.executeSQL(sql: sql,
                                     arguments: arguments,
                                     success: { id in
                                        success(id)
                                     },
                                     fail: failure)
    }
    
    func updateSupplyUsed(supply: SupplyUsed, success: @escaping() -> (), failure: @escaping(_ error: Error) -> ()) {
        
        let arguments: StatementArguments = [
            "supplyUsedId"          : supply.supplyUsedId,
            "supplyId"              : supply.supplyId,
            "supplyFinderId"        : supply.supplyFinderId,
            "InvoiceId"             : supply.InvoiceId,
            "supplyName"            : supply.supplyName,
            "priceToResell"         : supply.priceToResell,
            "quantity"              : supply.quantity,
            "supplyLocationId"      : supply.supplyLocationId,
            "supplyLocationName"    : supply.supplyLocationName,
            "wherePurchased"        : supply.wherePurchased,
            "vendorName"            : supply.vendorName,
            "waitingForSupply"      : supply.waitingForSupply,
            "countWaitingFor"       : supply.countWaitingFor,
            "dateAdded"             : DateManager.getStandardDateString(date: supply.dateAdded),
            "dateModified"          : DateManager.getStandardDateString(date: supply.dateModified),
            "removed"               : supply.removed,
            "removedDate"           : DateManager.getStandardDateString(date: supply.removedDate)
        ]
        
        let sql = """
            UPDATE \(tableName) SET
            
                \(COLUMNS.SUPPLY_ID)              =:supplyId,
                \(COLUMNS.SUPPLY_FINDER_ID)       =:supplyFinderId,
                \(COLUMNS.INVOICE_ID)             =:InvoiceId,
                \(COLUMNS.SUPPLY_NAME)            =:supplyName,
                \(COLUMNS.PRICE_TO_RESELL)        =:priceToResell,
                \(COLUMNS.QUANTITY)               =:quantity,
                \(COLUMNS.SUPPLY_LOCATION_ID)     =:supplyLocationId,
                \(COLUMNS.SUPPLY_LOCATION_NAME)   =:supplyLocationName,
                \(COLUMNS.WHERE_PURCHASED)        =:wherePurchased,
                \(COLUMNS.VENDOR_NAME)            =:vendorName,
                \(COLUMNS.WAITING_FOR_SUPPLY)     =:waitingForSupply,
                \(COLUMNS.COUNT_WAITING_FOR)      =:countWaitingFor,
                \(COLUMNS.DATE_ADDED)             =:dateAdded,
                \(COLUMNS.DATE_MODIFIED)          =:dateModified,
                \(COLUMNS.REMOVED)                =:removed,
                \(COLUMNS.REMOVED_DATE)           =:removedDate,

            WHERE \(tableName).\(setIdKey()) = :supplyUsedId;
            """
        
        AppDatabase.shared.executeSQL(sql: sql,
                                     arguments: arguments,
                                     success: { _ in
                                        success()
                                     },
                                     fail: failure)
    }
    
    func deleteSupplyUsed(supply: SupplyUsed, success: @escaping() -> (), failure: @escaping(_ error: Error) -> ()) {
        guard let id = supply.supplyUsedId else { return }
        softDelete(atId: id, success: success, fail: failure)
    }
    
    func restoreSupplyUsed(supply: SupplyUsed, success: @escaping() -> (), failure: @escaping(_ error: Error) -> ()) {
        guard let id = supply.supplyUsedId else { return }
        restoreItem(atId: id, success: success, fail: failure)
    }
    
    func fetchSupplyLocations(with id: Int,success: @escaping(_ suppliesLocation: [SupplyLocation]) -> (), failure: @escaping(_ error: Error) -> ()){
        guard let queue = AppDatabase.shared.dbQueue else { return }
        
        let sql = """
        SELECT * FROM \(TABLES.SUPPLY_LOCATIONS) WHERE \(TABLES.SUPPLY_LOCATIONS).\(COLUMNS.SUPPLY_LOCATION_ID) IN
        ( SELECT \(TABLES.SUPPLY_LOCATIONS).\(COLUMNS.SUPPLY_LOCATION_ID) FROM \(TABLES.SUPPLY_FINDERS) WHERE \(COLUMNS.SUPPLY_ID) = \(id))
        """

        do {
            let supplylocations = try queue.read({ (db) -> [SupplyLocation] in
                var supplylocations: [SupplyLocation] = []
                let rows = try Row.fetchAll(db,
                                            sql: sql,
                                            arguments: [])
                rows.forEach { (row) in
                    supplylocations.append(.init(row: row))
                }
                return supplylocations
            })
            success(supplylocations)
        }
        catch {
            failure(error)
            print(error)
        }
    }
    
    func fetchSupplyVendors(with id: Int,success: @escaping(_ vendors: [Vendor]) -> (), failure: @escaping(_ error: Error) -> ()){
        guard let queue = AppDatabase.shared.dbQueue else { return }
        let sql = """
        SELECT * FROM \(TABLES.VENDORS) WHERE \(TABLES.VENDORS).\(COLUMNS.VENDOR_ID) IN
        ( SELECT \(TABLES.VENDORS).\(COLUMNS.VENDOR_ID) FROM \(TABLES.SUPPLY_FINDERS) WHERE \(COLUMNS.SUPPLY_ID) = \(id))
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
    
    func fetchSupplyFinder(with id: Int,success: @escaping(_ supplyFinder: [SupplyFinder]) -> (), failure: @escaping(_ error: Error) -> ()){
        guard let queue = AppDatabase.shared.dbQueue else { return }
        let sql = """
        SELECT * FROM \(TABLES.SUPPLY_FINDERS)
        WHERE ( \(COLUMNS.SUPPLY_FINDER_ID) = \(id) )
        """
        
        do {
            let supplyFinder = try queue.read({ (db) -> [SupplyFinder] in
                var supplyFinder: [SupplyFinder] = []
                let rows = try Row.fetchAll(db,
                                            sql: sql,
                                            arguments: [])
                rows.forEach { (row) in
                    supplyFinder.append(.init(row: row))
                }
                return supplyFinder
            })
            success(supplyFinder)
        }
        catch {
            failure(error)
            print(error)
        }
    }
    
    func fetchFinder(supply: SupplyFinder,success: @escaping(_ supply: SupplyFinder?) -> (), failure: @escaping(_ error: Error) -> ()){
        guard let queue = AppDatabase.shared.dbQueue else { return }
        let arguments: StatementArguments = [
            "supplyId"          : supply.supplyId,
            "wherePurchased"    : supply.wherePurchased,
            "supplyLocationId"    : supply.supplyLocationID
        ]
        
        let sql = """
        SELECT * FROM \(TABLES.SUPPLY_FINDERS)
            WHERE (\(TABLES.SUPPLY_FINDERS).\(COLUMNS.SUPPLY_ID)           = :supplyId)
            AND (\(TABLES.SUPPLY_FINDERS).\(COLUMNS.WHERE_PURCHASED)       = :wherePurchased)
            AND (\(TABLES.SUPPLY_FINDERS).\(COLUMNS.SUPPLY_LOCATION_ID)    = :supplyLocationId)
            AND (\(TABLES.SUPPLY_FINDERS).\(COLUMNS.REMOVED) = 0 OR \(TABLES.SUPPLY_FINDERS).\(COLUMNS.REMOVED) is NULL);
        """
        
        do {
            let supplies = try queue.read({ (db) -> [SupplyFinder] in
                var supplies: [SupplyFinder] = []
                let rows = try Row.fetchAll(db,
                                            sql: sql,
                                            arguments: arguments)
                rows.forEach { (row) in
                    supplies.append(.init(row: row))
                }
                return supplies
            })
            success(supplies.first)
        }
        catch {
            failure(error)
            print(error)
        }
    }
}
