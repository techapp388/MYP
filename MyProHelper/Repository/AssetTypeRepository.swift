//
//  AssetTypeRepository.swift
//  MyProHelper
//
//
//  Created by Rajeev Verma on 10/06/1942 Saka.
//  Copyright © 2020 Benchmark Computing. All rights reserved.
//

import GRDB

class AssetTypeRepository: BaseRepository {
    
    init() {
        super.init(table: .ASSET_TYPES)
        createSelectedLayoutTable()
    }
    
    override func setIdKey() -> String {
        return COLUMNS.ASSET_TYPE_ID
    }
    
    private func createSelectedLayoutTable() {
        let sql = """
             CREATE TABLE IF NOT EXISTS \(tableName) (
                \(COLUMNS.ASSET_TYPE_ID)        INTEGER PRIMARY KEY  AUTOINCREMENT UNIQUE NOT NULL,
                \(COLUMNS.TYPE_OF_ASSET)        TEXT,
                \(COLUMNS.DATE_CREATED)         TEXT,
                \(COLUMNS.DATE_MODIFIED)        TEXT,
                \(COLUMNS.SAMPLE_ASSET_TYPE)    INTEGER DEFAULT (0),
                \(COLUMNS.REMOVED)              INTEGER DEFAULT (0),
                \(COLUMNS.REMOVED_DATE)         TEXT
            )
         """
         
         AppDatabase.shared.executeSQL(sql: sql,
                                       arguments: []) { (_) in
             print("TABLE ASSET_TYPES IS CREATED SUCCESSFULLY")
         } fail: { (error) in
             print(error)
         }
    }
    
    func createAssetType(assetType: AssetType, success: @escaping (_ typeID: Int64) -> (), fail: @escaping (_ error: Error) -> ()) {
        let arguments: StatementArguments = [
            "typeOfAsset"     : assetType.typeOfAsset,
            "dateCreated"     : DateManager.getStandardDateString(date: assetType.dateCreated),
            "dateModified"    : DateManager.getStandardDateString(date: assetType.dateModified),
            "removed"         : assetType.removed,
            "removedDate"     : DateManager.getStandardDateString(date: assetType.removedDate)
        ]
        let sql = """
            INSERT INTO \(tableName) (
                    \(COLUMNS.TYPE_OF_ASSET),
                    \(COLUMNS.DATE_CREATED),
                    \(COLUMNS.DATE_MODIFIED),
                    \(COLUMNS.REMOVED),
                    \(COLUMNS.REMOVED_DATE))

            VALUES (:typeOfAsset,
                    :dateCreated,
                    :dateModified,
                    :removed,
                    :removedDate)
            """
        AppDatabase.shared.executeSQL(sql: sql,
                                     arguments: arguments,
                                     success: { id in
                                        success(id)
                                     },
                                     fail: fail)
    }
    
    func updateAssetType(assetType: AssetType, success: @escaping () -> (), fail: @escaping (_ error: Error) -> ()) {
        let arguments: StatementArguments = [
            "id"              : assetType.id,
            "typeOfAsset"     : assetType.typeOfAsset,
            "dateCreated"     : DateManager.getStandardDateString(date: assetType.dateCreated),
            "dateModified"    : DateManager.getStandardDateString(date: assetType.dateModified),
            "removed"         : assetType.removed,
            "removedDate"     : DateManager.getStandardDateString(date: assetType.removedDate)
        ]
        let sql = """
            UPDATE \(tableName) SET
                \(COLUMNS.TYPE_OF_ASSET)    = :typeOfAsset,
                \(COLUMNS.DATE_CREATED)     = :dateCreated,
                \(COLUMNS.DATE_MODIFIED)    = :dateModified,
                \(COLUMNS.REMOVED)          = :removed,
                \(COLUMNS.REMOVED_DATE)     = :removedDate
            WHERE \(tableName).\(setIdKey()) = :id;
            """
        
        AppDatabase.shared.executeSQL(sql: sql,
                                     arguments: arguments,
                                     success: { _ in
                                        success()
                                     },
                                     fail: fail)
    }
    
    func delete(assetType: AssetType, success: @escaping () -> (), fail: @escaping (_ error: Error) -> ()) {
        guard let assetId = assetType.id else {
            return
        }
       softDelete(atId: assetId, success: success, fail: fail)

    }
    
    func restoreAssetType(assetType: AssetType, success: @escaping () -> (), fail: @escaping (_ error: Error) -> ()) {
        guard let assetId = assetType.id else {
            return
        }
       restoreItem(atId: assetId, success: success, fail: fail)

    }
    
    func fetchAssetType(showRemoved: Bool, with key: String? = nil, sortBy: AssetTypeField? = nil, sortType: SortType? = nil ,offset: Int,success: @escaping(_ assetTypes: [AssetType]) -> (), failure: @escaping(_ error: Error) -> ()) {
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
            let assetTypes = try queue.read({ (db) -> [AssetType] in
                var assetTypes: [AssetType] = []
                let rows = try Row.fetchAll(db,
                                            sql: sql,
                                            arguments: [])
                rows.forEach { (row) in
                    assetTypes.append(.init(row: row))
                }
                return assetTypes
            })
            success(assetTypes)
        }
        catch {
            failure(error)
            print(error)
        }
    }
    
    private func makeSortableItems(sortBy: AssetTypeField?, sortType: SortType?) -> String {
        guard let sortBy = sortBy, let sortType = sortType else {
            return makeSortableCondition(key: COLUMNS.TYPE_OF_ASSET, sortType: .ASCENDING)
        }
        switch sortBy {
        case .TYPE_OF_ASSET:
            return makeSortableCondition(key: COLUMNS.TYPE_OF_ASSET, sortType: sortType)
        case .CREATED_DATE:
            return makeSortableCondition(key: COLUMNS.DATE_CREATED, sortType: sortType)
        }
    }
    
    private func makeSearchableItems(key: String?) -> String {
        guard let key = key else { return "" }
        return  makeSearchableCondition(key: key,
                                        fields: [
                                            COLUMNS.TYPE_OF_ASSET,
                                            COLUMNS.DATE_CREATED])
    }
}
