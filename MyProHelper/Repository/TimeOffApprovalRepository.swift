//
//  TimeOffApprovalRepository.swift
//  MyProHelper
//
//  Created by Samir on 11/29/20.
//  Copyright © 2020 Benchmark Computing. All rights reserved.
//

import GRDB

class TimeOffApprovalRepository: BaseRepository{
    
    init() {
        super.init(table: .APPROVALS)
        createSelectedLayoutTable()
    }
    
    override func setIdKey() -> String {
        return COLUMNS.WORKER_ID
    }
    
    private func createSelectedLayoutTable() {
        let sql = """
            CREATE TABLE IF NOT EXISTS \(tableName)(
               \(COLUMNS.TIME_OFF_REQUEST_ID) INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE NOT NULL,
                \(COLUMNS.WORKER_ID) INTEGER REFERENCES Workers (WorkerID) NOT NULL,
                \(COLUMNS.WORKER_NAME)      TEXT (100) NOT NULL,
                \(COLUMNS.DESCRIPTION)      TEXT(100),
                \(COLUMNS.START_DATE)       TEXT,
                \(COLUMNS.END_DATE)         TEXT,
                \(COLUMNS.TYPEOF_LEAVE)     TEXT(100),
                \(COLUMNS.STATUS)           TEXT(100),
                \(COLUMNS.REMARK)           TEXT(100),
                \(COLUMNS.DATE_REQUESTED)   TEXT,
                \(COLUMNS.APPROVER_NAME)    TEXT (100),
                \(COLUMNS.APPROVED_BY)      INTEGER,
                \(COLUMNS.APPROVED_DATE)    INTEGER,
                \(COLUMNS.REMOVED)          INTEGER DEFAULT (0),
                \(COLUMNS.REMOVED_DATE)     TEXT
            )
        """
        AppDatabase.shared.executeSQL(sql: sql,
                                      arguments: []) { (_) in
            print("TABLE APPRPVAL IS CREATED SUCCESSFULLY")
        } fail: { (error) in
            print(error)
        }
    }
    
    func createApproval(worker: Approval, success: @escaping(_ id: Int64) -> (), failure: @escaping(_ error: Error) -> ()) {
        let arguments: StatementArguments = [
            "workerid"         : worker.workerID,
            "workername"         : worker.workername,
            "description"        : worker.description,
            "startdate"          : worker.startdate,
            "enddate"            : worker.enddate,
            "typeofleave"        : worker.typeofleave,
            "status"             : worker.status,
            "remark"             : worker.remark,
            "requesteddate"      : worker.requesteddate,
            "approvername"       : worker.approvername,
            "approvedby"         : worker.approvedby,
            "approveddate"       : worker.approveddate,
            "removed"            : worker.removed,
            "removedDate"        : worker.removedDate

        ]
        let sql = """
            INSERT INTO \(tableName) (
                \(COLUMNS.WORKER_ID),
                \(COLUMNS.WORKER_NAME),
                \(COLUMNS.DESCRIPTION),
                \(COLUMNS.START_DATE),
                \(COLUMNS.END_DATE),
                \(COLUMNS.TYPEOF_LEAVE),
                \(COLUMNS.STATUS),
                \(COLUMNS.REMARK),
                \(COLUMNS.DATE_REQUESTED),
                \(COLUMNS.REMOVED),
                \(COLUMNS.APPROVER_NAME),
                \(COLUMNS.APPROVED_BY),
                \(COLUMNS.APPROVED_DATE)
            )
            VALUES (:workerid,
                    :workername,
                    :description,
                    :startdate,
                    :enddate,
                    :typeofleave,
                    :status,
                    :remark,
                    :requesteddate,
                    :removed,
                    :approvername,
                    :approvedby,
                    :approveddate
            )
            """
       
        print("ARGUMENTS: \(arguments)")
        AppDatabase.shared.executeSQL(sql: sql,
                                      arguments: arguments,
                                      success: { id in
                                        success(id)
                                      },
                                      fail: failure)
    }
    
    
    func updateApproval(worker: Approval, success: @escaping() -> (), failure: @escaping(_ error: Error) -> ()) {

        let arguments: StatementArguments = [
                       "id"               : worker.workerID,
                       "workername"       : worker.workername,
                       "description"      : worker.description,
                       "startdate"        : worker.startdate,
                       "enddate"          : worker.enddate,
                       "typeofleave"      : worker.typeofleave,
                       "status"           : worker.status,
                       "remark"           : worker.remark,
                       "requesteddate"    : worker.requesteddate,
                       "approvedby"       : worker.approvedby,
                       "approveddate"     : worker.approveddate
                       
        ]
            
        let sql = """
            UPDATE \(tableName) SET
                \(COLUMNS.WORKER_NAME)          = :workername,
               \(COLUMNS.DESCRIPTION)          = :description,
               \(COLUMNS.START_DATE)           = :startdate,
                \(COLUMNS.END_DATE)             = :enddate,
               \(COLUMNS.TYPEOF_LEAVE)         = :typeofleave,
                \(COLUMNS.STATUS)               = :status,
               \(COLUMNS.REMARK)               = :remark,
                \(COLUMNS.DATE_REQUESTED)       = :requesteddate,
                \(COLUMNS.APPROVED_BY)          = :approvedby,
                \(COLUMNS.APPROVED_DATE)        = :approveddate
            WHERE \(tableName).\(setIdKey()) = :id;
            """
        
        AppDatabase.shared.executeSQL(sql: sql,
                                     arguments: arguments,
                                     success: { _ in
                                        success()
                                     },
                                     fail: failure)
    }
    
    func deleteApproval(worker: Approval, success: @escaping() -> (), failure: @escaping(_ error: Error) -> ()) {
        guard let id = worker.workerID else { return }
        softDelete(atId: id, success: success, fail: failure)
    }
    

    func restoreApproval(worker: Approval, success: @escaping() -> (), failure: @escaping(_ error: Error) -> ()) {
        guard let id = worker.workerID else { return }
        restoreItem(atId: id, success: success, fail: failure)
    }
    
    func fetchApproval(showRemoved: Bool, with key: String? = nil, sortBy: TimeOffApprovalField? = nil, sortType: SortType? = nil ,offset: Int,success: @escaping(_ approval: [Approval]) -> (), failure: @escaping(_ error: Error) -> ()) {
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
        //\(condition)
        //\(sortable)
        let sql1 = """
        SELECT * FROM \(tableName)
        LEFT JOIN \(TABLES.WORKERS) ON \(tableName).\(COLUMNS.TIME_OFF_REQUEST_ID) ==
            \(TABLES.WORKERS).\(COLUMNS.WORKER_ID)
              \(condition)
        \(sortable)

        LIMIT \(LIMIT) OFFSET \(offset);
        """
       

        
        do {
            let timeoffapproval = try queue.read({ (db) -> [Approval] in
                var timeoffapproval: [Approval] = []
                let rows = try Row.fetchAll(db,
                                            sql: sql1,
                                            arguments: [])
                rows.forEach { (row) in
                    timeoffapproval.append(.init(row: row))
                }
                print("timeoffapproval: \(timeoffapproval)")
                return timeoffapproval
            })
            success(timeoffapproval)
        }
        catch {
            failure(error)
            print(error)
        }
    }
    
    
    private func makeSortableItems(sortBy: TimeOffApprovalField?, sortType: SortType?) -> String {
        guard let sortBy = sortBy, let sortType = sortType else {
            return makeSortableCondition(key: COLUMNS.WORKER_NAME, sortType: .ASCENDING)
        }
        switch sortBy {
        case .WORKER_NAME:
            return makeSortableCondition(key: COLUMNS.WORKER_NAME, sortType: sortType)
        case .DESCRIPTION:
            return makeSortableCondition(key: COLUMNS.DESCRIPTION, sortType: sortType)
        case .START_DATE:
            return makeSortableCondition(key: COLUMNS.START_DATE, sortType: sortType)
        case .END_DATE:
            return makeSortableCondition(key: COLUMNS.END_DATE, sortType: sortType)
        case .TYPEOF_LEAVE:
            return makeSortableCondition(key: COLUMNS.TYPEOF_LEAVE, sortType: sortType)
        case .STATUS:
            return makeSortableCondition(key: COLUMNS.STATUS, sortType: sortType)
        case .REMARK:
            return makeSortableCondition(key: COLUMNS.REMARK, sortType: sortType)
        case .REQUESTED_DATE:
            return makeSortableCondition(key: COLUMNS.DATE_REQUESTED, sortType: sortType)
        case .APPROVER_NAME:
            return makeSortableCondition(key: COLUMNS.APPROVER_NAME, sortType: sortType)
        case .APPROVED_DATE:
            return makeSortableCondition(key: COLUMNS.APPROVED_DATE, sortType: sortType)
        
            
        }
    }
    
//    private func makeSearchableItems(key: String?) -> String {
//        guard let key = key else { return "" }
//        var yesOrNoCondition = ""
//        if key.lowercased() == "yes" || key.lowercased() == "no" {
//            let yesOrNoValue: String = (key.lowercased() == "yes") ? "1" : "0"
//            yesOrNoCondition = "OR " + makeSearchableCondition(key: yesOrNoValue,
//                                                               fields: [COLUMNS.SALARY,
//                                                                        COLUMNS.HOURLY_WORKER,
//                                                                        COLUMNS.CONTRACTOR
//                                                               ])
//        }
//        return makeSearchableCondition(key: key,
//                                       fields: [
//                                        COLUMNS.FIRST_NAME,
//                                        COLUMNS.LAST_NAME,
//                                        COLUMNS.CELL_NUMBER,
//                                        COLUMNS.EMAIL])
//            + yesOrNoCondition
//    }
//}
private func makeSearchableItems(key: String?) -> String {
    guard let key = key else { return "" }
    return makeSearchableCondition(key: key,
                                   fields: [
                                    COLUMNS.FIRST_NAME,
                                    COLUMNS.LAST_NAME,
                                   
                                   ])
}
}
