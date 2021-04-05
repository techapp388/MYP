//
//  SupplyRepository.swift
//  MyProHelper
//
//
//  Created by Deep on 1/24/21.
//  Copyright © 2021 Benchmark Computing. All rights reserved.
//

import GRDB

class SupplyRepository: BaseRepository {
    
    
    init() {
        super.init(table: .SUPPLIES)
    }
    
    override func setIdKey() -> String {
        return COLUMNS.PART_ID
    }
    
    func fetchSupplies(showRemoved: Bool, with key: String? = nil, sortType: SortType? = nil ,offset: Int,success: @escaping(_ supplies: [Supply]) -> (), failure: @escaping(_ error: Error) -> ()) {
        guard let queue = AppDatabase.shared.dbQueue else { return }
    
        let sql = """
        SELECT * FROM \(tableName)
        LIMIT \(LIMIT) OFFSET \(offset);
        """
        
        do {
            let supplies = try queue.read({ (db) -> [Supply] in
                var supplies: [Supply] = []
                let rows = try Row.fetchAll(db,
                                            sql: sql,
                                            arguments: [])
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
}
