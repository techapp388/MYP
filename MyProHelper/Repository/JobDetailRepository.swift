//
//  JobDetailRepository.swift
//  MyProHelper
//
//
//  Created by Deep on 1/24/21.
//  Copyright © 2021 Benchmark Computing. All rights reserved.
//

import Foundation
import GRDB

class JobDetailRepository: BaseRepository {

    init() {
        super.init(table: .JOB_DETAILS)
    }

    override func setIdKey() -> String {
        return COLUMNS.JOB_DETAIL_ID
    }
    
    func fetchJobDetail(showRemoved: Bool, with key: String? = nil, sortBy: JobDetailListField? = nil, sortType: SortType? = nil ,offset: Int,success: @escaping(_ service: [JobDetail]) -> (), failure: @escaping(_ error: Error) -> ()) {
        guard let queue = AppDatabase.shared.dbQueue else { return }
        let sortable = makeSortableItems(sortBy: sortBy, sortType: sortType)
        let searchable = makeSearchableItems(key: key)
        let condition = getShowRemoveCondition(showRemoved: showRemoved, searchable: searchable)
        
        let sql = """
        SELECT * FROM \(tableName)
        LEFT JOIN \(TABLES.CUSTOMERS) ON \(tableName).\(COLUMNS.CUSTOMER_ID) == \(TABLES.CUSTOMERS).\(COLUMNS.CUSTOMER_ID)
        LEFT JOIN \(TABLES.SCHEDULED_JOBS) ON \(TABLES.SCHEDULED_JOBS).\(COLUMNS.JOB_ID) == \(TABLES.SCHEDULED_JOBS).\(COLUMNS.JOB_ID)
        LEFT JOIN \(TABLES.WORKERS) ON \(tableName).\(COLUMNS.CREATED_BY) ==
            \(TABLES.WORKERS).\(COLUMNS.WORKER_ID)

        \(condition)
        \(sortable)
        LIMIT \(LIMIT) OFFSET \(offset);
        """

        do {
            let jobDetails = try queue.read({ (db) -> [JobDetail] in
                var jobDetails: [JobDetail] = []
                let rows = try Row.fetchAll(db,
                                            sql: sql,
                                            arguments: [])
                rows.forEach { (row) in
                    jobDetails.append(.init(row: row))
                }
                return jobDetails
            })
            success(jobDetails)
        }
        catch {
            failure(error)
        }
    }
    
    private func makeSortableItems(sortBy: JobDetailListField?, sortType: SortType?) -> String {
        guard let sortBy = sortBy, let sortType = sortType else {
            return makeSortableCondition(key:"\(TABLES.CUSTOMERS).\(COLUMNS.CUSTOMER_NAME)",
                                         sortType: .ASCENDING)
        }
        switch sortBy {
        case .CUSTOMER_NAME:
            return makeSortableCondition(key:"\(TABLES.CUSTOMERS).\(COLUMNS.CUSTOMER_NAME)", sortType: sortType)
        case .SHORT_DESCRIPTION:
            return makeSortableCondition(key: COLUMNS.JOB_SHORT_DESCRIPTION, sortType: sortType)
        case .DETAILS:
            return makeSortableCondition(key: COLUMNS.DETAILS, sortType: sortType)
        case .CREATED_DATE:
            return makeSortableCondition(key: COLUMNS.DATE_CREATED, sortType: sortType)
        case .ATTACHMENTS:
            return makeSortableCondition(key: COLUMNS.NUMBER_OF_ATTACHMENTS, sortType: sortType)
        }
    }

    private func makeSearchableItems(key: String?) -> String {
        guard let key = key else { return "" }
        return  makeSearchableCondition(key: key,
                                        fields: [
                                            "\(TABLES.CUSTOMERS).\(COLUMNS.CUSTOMER_NAME)",
                                            "\(TABLES.SCHEDULED_JOBS).\(COLUMNS.JOB_SHORT_DESCRIPTION)",
                                            "\(tableName).\(COLUMNS.DETAILS)",
                                            "\(tableName).\(COLUMNS.NUMBER_OF_ATTACHMENTS)"])
    }

}
