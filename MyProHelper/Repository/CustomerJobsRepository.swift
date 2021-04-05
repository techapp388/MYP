//
//  CustomerJobsRepository.swift
//  MyProHelper
//
//
//  Created by Deep on 1/24/21.
//  Copyright © 2021 Benchmark Computing. All rights reserved.
//

import Foundation
import GRDB

class CustomerJobsRepository: BaseRepository {
    
    init() {
        super.init(table: .SCHEDULED_JOBS)
    }
    
    func fetchJobs(for customer: Customer,showRemoved: Bool, with key: String? = nil, sortBy: JobField? = nil, sortType: SortType? = nil ,offset: Int,success: @escaping(_ job: [Job]) -> (), failure: @escaping(_ error: Error) -> ()) {
        guard let queue = AppDatabase.shared.dbQueue else { return }
        guard let customerID = customer.customerID else { return }
 
        
        let sql = """
        SELECT * FROM \(tableName)
        LEFT JOIN \(TABLES.CUSTOMERS) ON \(tableName).\(COLUMNS.CUSTOMER_ID) == \(TABLES.CUSTOMERS).\(COLUMNS.CUSTOMER_ID)
        WHERE \(tableName).\(COLUMNS.CUSTOMER_ID) == \(customerID)
        LIMIT \(LIMIT) OFFSET \(offset);
        """
        
        do {
            let jobs = try queue.read({ (db) -> [Job] in
                var jobs: [Job] = []
                let rows = try Row.fetchAll(db,
                                            sql: sql,
                                            arguments: [])
                rows.forEach { (row) in
                    jobs.append(.init(row: row))
                }
                return jobs
            })
            success(jobs)
        }
        catch {
            failure(error)
            print(error)
        }
    }
}

