//
//  AssetRepository.swift
//  MyProHelper
//
//
//  Created by Rajeev Verma on 10/06/1942 Saka.
//  Copyright © 2020 Benchmark Computing. All rights reserved.
//


import GRDB

class AssetRepository: BaseRepository {
    
    init() {
        super.init(table: .ASSETS)
        createSelectedLayoutTable()
    }
    
    override func setIdKey() -> String {
        return COLUMNS.ASSET_ID
    }
    
    private func createSelectedLayoutTable() {
       let sql = """
            CREATE TABLE IF NOT EXISTS \(tableName) (
            \(COLUMNS.ASSET_ID)                 INTEGER PRIMARY KEY  AUTOINCREMENT UNIQUE NOT NULL,
            \(COLUMNS.ASSET_NAME)               TEXT,
            \(COLUMNS.DESCRIPTION)              TEXT,
            \(COLUMNS.MODEL_INFO)               TEXT,
            \(COLUMNS.DATE_PURHCASED)           TEXT,
            \(COLUMNS.SERIAL_NUMBER)            TEXT,
            \(COLUMNS.DATE_CREATED)             TEXT,
            \(COLUMNS.DATE_MODIFIED)            TEXT,
            \(COLUMNS.PURHCASE_PRICE)           REAL,
            \(COLUMNS.ASSET_TYPE)               REFERENCES AssetTypes (AssetTypeID),
            \(COLUMNS.LATEST_MAINTENANCE_DATE)  TEXT,
            \(COLUMNS.MILEAGE)                  INTEGER,
            \(COLUMNS.HOURS_USED)               INTEGER,
            \(COLUMNS.SAMPLE_ASSET)             INTEGER DEFAULT (0),
            \(COLUMNS.REMOVED)                  INTEGER DEFAULT (0),
            \(COLUMNS.REMOVED_DATE)             TEXT,
            \(COLUMNS.NUMBER_OF_ATTACHMENTS)    INTEGER DEFAULT(0))
        """
        
        AppDatabase.shared.executeSQL(sql: sql,
                                      arguments: []) { (_) in
            print("TABLE ASSETS IS CREATED SUCCESSFULLY")
        } fail: { (error) in
            print(error)
        }

    }
    
    func createAsset(asset: Asset, success: @escaping(_ assetID: Int64) -> (), fail: @escaping (_ error: Error) -> ()) {
        let arguments: StatementArguments = [
            "name"                  : asset.assetName,
            "description"           : asset.description,
            "modelInfo"             : asset.modelInfo,
            "datePurchased"         : DateManager.getStandardDateString(date: asset.datePurchased),
            "serialNumber"          : asset.serialNumber,
            "dateCreated"           : DateManager.getStandardDateString(date: asset.dateCreated),
            "dateModified"          : DateManager.getStandardDateString(date: asset.dateModified),
            "purchasePrice"         : asset.purchasePrice,
            "assetType"             : asset.assetType?.id,
            "latestMaintenanceDate" : DateManager.getStandardDateString(date: asset.lastMaintenanceDate),
            "mileage"               : asset.mileage,
            "hoursUsed"             : asset.hoursUsed,
            "removed"               : asset.removed,
            "removedDate"           : DateManager.getStandardDateString(date: asset.removedDate),
            "numberOfAttachments"   : asset.numberOfAttachment
        ]
        let sql = """
            INSERT INTO \(tableName) (
                            \(COLUMNS.ASSET_NAME),
                            \(COLUMNS.DESCRIPTION),
                            \(COLUMNS.MODEL_INFO),
                            \(COLUMNS.DATE_PURHCASED),
                            \(COLUMNS.SERIAL_NUMBER),
                            \(COLUMNS.DATE_CREATED),
                            \(COLUMNS.DATE_MODIFIED),
                            \(COLUMNS.PURHCASE_PRICE),
                            \(COLUMNS.ASSET_TYPE),
                            \(COLUMNS.LATEST_MAINTENANCE_DATE),
                            \(COLUMNS.MILEAGE),
                            \(COLUMNS.HOURS_USED),
                            \(COLUMNS.REMOVED),
                            \(COLUMNS.REMOVED_DATE),
                            \(COLUMNS.NUMBER_OF_ATTACHMENTS)
                        )
            VALUES (:name,
                    :description,
                    :modelInfo,
                    :datePurchased,
                    :serialNumber,
                    :dateCreated,
                    :dateModified,
                    :purchasePrice,
                    :assetType,
                    :latestMaintenanceDate,
                    :mileage,
                    :hoursUsed,
                    :removed,
                    :removedDate,
                    :numberOfAttachments)
            """
        AppDatabase.shared.executeSQL(sql: sql,
                                     arguments: arguments,
                                     success: { id in
                                        success(id)
                                     },
                                     fail: fail)
    }
    
    func updateAsset(asset: Asset, success: @escaping() -> (), fail: @escaping (_ error: Error) -> ()) {
        let arguments: StatementArguments = [
            "id"                    : asset.assetId,
            "name"                  : asset.assetName,
            "description"           : asset.description,
            "modelInfo"             : asset.modelInfo,
            "datePurchased"         : DateManager.getStandardDateString(date: asset.datePurchased),
            "serialNumber"          : asset.serialNumber,
            "dateCreated"           : DateManager.getStandardDateString(date: asset.dateCreated),
            "dateModified"          : DateManager.getStandardDateString(date: asset.dateModified),
            "purchasePrice"         : asset.purchasePrice,
            "assetType"             : asset.assetType?.id,
            "latestMaintenanceDate" : DateManager.getStandardDateString(date: asset.lastMaintenanceDate),
            "mileage"               : asset.mileage,
            "hoursUsed"             : asset.hoursUsed,
            "removed"               : asset.removed,
            "removedDate"           : DateManager.getStandardDateString(date: asset.removedDate),
            "numberOfAttachments"   : asset.numberOfAttachment
        ]
        let sql = """
            UPDATE \(tableName) SET
                            \(COLUMNS.ASSET_NAME)               = :name,
                            \(COLUMNS.DESCRIPTION)              = :description,
                            \(COLUMNS.MODEL_INFO)               = :modelInfo,
                            \(COLUMNS.DATE_PURHCASED)           = :datePurchased,
                            \(COLUMNS.SERIAL_NUMBER)            = :serialNumber,
                            \(COLUMNS.DATE_CREATED)             = :dateCreated,
                            \(COLUMNS.DATE_MODIFIED)            = :dateModified,
                            \(COLUMNS.PURHCASE_PRICE)           = :purchasePrice,
                            \(COLUMNS.ASSET_TYPE)               = :assetType,
                            \(COLUMNS.LATEST_MAINTENANCE_DATE)  = :latestMaintenanceDate,
                            \(COLUMNS.MILEAGE)                  = :mileage,
                            \(COLUMNS.HOURS_USED)               = :hoursUsed,
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
                                     fail: fail)
    }
    
    func deleteAsset(asset: Asset, success: @escaping() -> (), fail: @escaping (_ error: Error) -> ()) {
        guard let id = asset.assetId else {
            return
        }
        softDelete(atId: id, success: success, fail: fail)
    }
    
    func restoreAsset(asset: Asset, success: @escaping() -> (), fail: @escaping (_ error: Error) -> ()) {
        guard let id = asset.assetId else {
            return
        }
        restoreItem(atId: id, success: success, fail: fail)
    }
    
    func fetchAsset(showRemoved: Bool, with key: String? = nil, sortBy: AssetField? = nil, sortType: SortType? = nil ,offset: Int,success: @escaping(_ assets: [Asset]) -> (), failure: @escaping(_ error: Error) -> ()) {
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
        SELECT * FROM \(tableName) LEFT JOIN \(TABLES.ASSET_TYPES) ON \(tableName).\(COLUMNS.ASSET_TYPE) == \(TABLES.ASSET_TYPES).\(COLUMNS.ASSET_TYPE_ID)
        \(condition)
        \(sortable)
        LIMIT \(LIMIT) OFFSET \(offset);
        """
        do {
            let assets = try queue.read({ (db) -> [Asset] in
                var assets: [Asset] = []
                let rows = try Row.fetchAll(db,
                                            sql: sql,
                                            arguments: [])
                rows.forEach { (row) in
                    assets.append(.init(row: row))
                }
                return assets
            })
            success(assets)
        }
        catch {
            failure(error)
            print(error)
        }
    }
    
    private func makeSortableItems(sortBy: AssetField?, sortType: SortType?) -> String {
        guard let sortBy = sortBy, let sortType = sortType else {
            return makeSortableCondition(key: COLUMNS.ASSET_NAME, sortType: .ASCENDING)
        }
        switch sortBy {
        case .ASSETS_NAME:
            return makeSortableCondition(key: COLUMNS.ASSET_NAME, sortType: sortType)
        case .DESCRIPTION:
            return makeSortableCondition(key: COLUMNS.DESCRIPTION, sortType: sortType)
        case .MODEL_INFO:
            return makeSortableCondition(key: COLUMNS.MODEL_INFO, sortType: sortType)
        case .SERIAL_NUMBER:
            return makeSortableCondition(key: COLUMNS.SERIAL_NUMBER, sortType: sortType)
        case .ASSET_TYPE:
            return makeSortableCondition(key: "\(TABLES.ASSET_TYPES).\(COLUMNS.TYPE_OF_ASSET)", sortType: sortType)
        case .PURCHASE_PRICE:
            return makeSortableCondition(key: COLUMNS.PURHCASE_PRICE, sortType: sortType)
        case .MILEAGE:
            return makeSortableCondition(key: COLUMNS.MILEAGE, sortType: sortType)
        case .HOURS_USED:
            return makeSortableCondition(key: COLUMNS.HOURS_USED, sortType: sortType)
        case .ATTACHMENTS:
            return makeSortableCondition(key: COLUMNS.NUMBER_OF_ATTACHMENTS, sortType: sortType)
        case .MAINTENANCE_DATE:
            return makeSortableCondition(key: COLUMNS.LATEST_MAINTENANCE_DATE, sortType: sortType)
        case .PURCHASED_DATE:
            return makeSortableCondition(key: COLUMNS.DATE_PURHCASED, sortType: sortType)
        }
    }
    
    private func makeSearchableItems(key: String?) -> String {
        guard let key = key else { return "" }
        return makeSearchableCondition(key: key,
                                       fields: [
                                        COLUMNS.ASSET_NAME,
                                        COLUMNS.DESCRIPTION,
                                        COLUMNS.MODEL_INFO,
                                        COLUMNS.SERIAL_NUMBER,
                                        "\(TABLES.ASSET_TYPES).\(COLUMNS.TYPE_OF_ASSET)",
                                        COLUMNS.PURHCASE_PRICE,
                                        COLUMNS.MILEAGE,
                                        COLUMNS.HOURS_USED,
                                        COLUMNS.NUMBER_OF_ATTACHMENTS,
                                        COLUMNS.LATEST_MAINTENANCE_DATE,
                                        COLUMNS.DATE_PURHCASED
                                       ])
    }
}
