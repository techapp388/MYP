//
//  JobConfirmationRepository.swift
//  MyProHelper
//
//  Created by Deep on 1/20/21.
//  Copyright © 2021 Benchmark Computing. All rights reserved.
//

import Foundation
import GRDB

class JobConfirmationRepository: BaseRepository {
    
    init() {
        super.init(table: .SCHEDULED_JOBS)
    }
    
    override func setIdKey() -> String {
        return COLUMNS.JOB_ID
    }
    
    func updateJob(job: Job, success: @escaping () -> (), failure: @escaping (_ error: Error) -> ()) {
        let arguments: StatementArguments = [
            "id"                    : job.jobID,
            "customerID"            : job.customerID,
            "LocationAddress1"      : job.jobLocationAddress1,
            "locationAddress2"      : job.jobLocationAddress2,
            "locationCity"          : job.jobLocationCity,
            "locationState"         : job.jobLocationState,
            "locationZip"           : job.jobLocationZip,
            "personName"            : job.jobContactPersonName,
            "contactPhone"          : job.jobContactPhone,
            "contactEmail"          : job.jobContactEmail,
            "shortDescription"      : job.jobShortDescription,
            "description"           : job.jobDescription,
            "startDate"             : DateManager.getStandardDateString(date: job.startDateTime),
            "endDate"               : DateManager.getStandardDateString(date: job.endDateTime),
            "timeDuration"          : job.estimateTimeDuration,
            "workerScheduled"       : job.worker?.workerID,
            "jobStatus"             : job.jobStatus ,
            "removed"               : job.removed,
            "removedDate"           : DateManager.getStandardDateString(date: job.removedDate),
            "numberOfAttachments"   : job.numberOfAttachments,
            "rejected"              : job.rejected,
            "rejectedReason"        : job.rejectedReason]
            
        let sql = """
            UPDATE \(tableName) SET
                \(COLUMNS.CUSTOMER_ID)                  = :customerID,
                \(COLUMNS.JOB_LOCATION_ADDRESS_1)       = :LocationAddress1,
                \(COLUMNS.JOB_LOCATION_ADDRESS_2)       = :locationAddress2,
                \(COLUMNS.JOB_LOCATION_CITY)            = :locationCity,
                \(COLUMNS.JOB_LOCATION_STATE)           = :locationState,
                \(COLUMNS.JobLocationZIP)               = :locationZip,
                \(COLUMNS.JOB_CONTACT_PERSON_NAME)      = :personName,
                \(COLUMNS.JOB_CONTACT_PHONE)            = :contactPhone,
                \(COLUMNS.JOB_CONTACT_EMAIL)            = :contactEmail,
                \(COLUMNS.JOB_SHORT_DESCRIPTION)        = :shortDescription,
                \(COLUMNS.JOB_DESCRIPTION)              = :description,
                \(COLUMNS.START_DATE_TIME)              = :startDate,
                \(COLUMNS.END_DATE_TIME)                = :endDate,
                \(COLUMNS.ESTIMATED_TIME_DURATION)      = :timeDuration,
                \(COLUMNS.WORKER_SCHEDULED)             = :workerScheduled,
                \(COLUMNS.JOB_STATUS)                   = :jobStatus,
                \(COLUMNS.REMOVED)                      = :removed,
                \(COLUMNS.REMOVED_DATE)                 = :removedDate,
                \(COLUMNS.NUMBER_OF_ATTACHMENTS)        = :numberOfAttachments,
                \(COLUMNS.REJECTED)                     = :rejected,
                \(COLUMNS.REJECTED_REASON)              = :rejectedReason

            WHERE \(tableName).\(setIdKey()) = :id;
            """
        
        AppDatabase.shared.executeSQL(sql: sql,
                                     arguments: arguments,
                                     success: { _ in
                                        success()
                                     },
                                     fail: failure)
    }
    
    func fetchJob(showRemoved: Bool, with key: String? = nil, sortBy: JobConfirmationField? = nil, sortType: SortType? = nil ,offset: Int,success: @escaping(_ jobs: [Job]) -> (), failure: @escaping(_ error: Error) -> ()) {
        guard let queue = AppDatabase.shared.dbQueue else { return }
        let sortable = makeSortableItems(sortBy: sortBy, sortType: sortType)
        let searchable = makeSearchableItems(key: key)
        let condition = (searchable.isEmpty) ? "" : "AND \(searchable)"
        
        let sql = """
        SELECT * FROM \(tableName)
        LEFT JOIN \(TABLES.WORKERS) ON \(tableName).\(COLUMNS.WORKER_SCHEDULED) == \(TABLES.WORKERS).\(COLUMNS.WORKER_ID)
        LEFT JOIN \(TABLES.CUSTOMERS) ON \(tableName).\(COLUMNS.CUSTOMER_ID) == \(TABLES.CUSTOMERS).\(COLUMNS.CUSTOMER_ID)
        WHERE (\(tableName).\(COLUMNS.JOB_STATUS) LIKE 'Waiting')
        OR (\(tableName).\(COLUMNS.JOB_STATUS) LIKE 'Rejected')
        \(condition)
        \(sortable)
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
    
    private func makeSortableItems(sortBy: JobConfirmationField?, sortType: SortType?) -> String {
        guard let sortBy = sortBy, let sortType = sortType else {
            return makeSortableCondition(key: COLUMNS.FIRST_NAME, sortType: .ASCENDING)
        }
        switch sortBy {
        
        case .WORKER_NAME:
            return makeSortableCondition(key: COLUMNS.FIRST_NAME, sortType: sortType)
        case .SCHEDULED_DATE_TIME:
            return makeSortableCondition(key: COLUMNS.ESTIMATED_TIME_DURATION, sortType: sortType)
        case .ADDRESS:
            return makeSortableCondition(key: COLUMNS.JOB_LOCATION_ADDRESS_1, sortType: sortType)
        case .CONTACT_PERSON_NAME:
            return makeSortableCondition(key: COLUMNS.JOB_CONTACT_PERSON_NAME, sortType: sortType)
        case .CONTACT_PHONE:
            return makeSortableCondition(key: COLUMNS.JOB_CONTACT_PHONE, sortType: sortType)
        case .JOB_TITLE:
            return makeSortableCondition(key: COLUMNS.JOB_SHORT_DESCRIPTION, sortType: sortType)
        case .DESCRIPTION:
            return makeSortableCondition(key: COLUMNS.JOB_DESCRIPTION, sortType: sortType)
        case .STATUS:
            return makeSortableCondition(key: COLUMNS.JOB_STATUS, sortType: sortType)
        case .ATTACHMENTS:
            return makeSortableCondition(key: COLUMNS.NUMBER_OF_ATTACHMENTS, sortType: sortType)
        }
    }
    
    private func makeSearchableItems(key: String?) -> String {
        guard let key = key else { return "" }
        return makeSearchableCondition(key: key,
                                       fields: [
                                        COLUMNS.FIRST_NAME,
                                        COLUMNS.LAST_NAME,
                                        COLUMNS.ESTIMATED_TIME_DURATION,
                                        COLUMNS.JOB_LOCATION_ADDRESS_1,
                                        COLUMNS.JOB_CONTACT_PERSON_NAME,
                                        COLUMNS.JOB_CONTACT_PHONE,
                                        COLUMNS.JOB_SHORT_DESCRIPTION,
                                        COLUMNS.JOB_DESCRIPTION,
                                        COLUMNS.JOB_STATUS,
                                        COLUMNS.NUMBER_OF_ATTACHMENTS
                                       ])
    }
}
