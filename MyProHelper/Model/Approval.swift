//
//  Approval.swift
//  MyProHelper
//
//  Created by Deep on 1/31/21.
//  Copyright © 2021 Benchmark Computing. All rights reserved.
//


import GRDB

struct Approval: RepositoryBaseModel  {
   
    var removed         : Bool?
    var workerID        : Int?
    var workername      : String?
    var description     : String?
    var startdate       : Date?
    var enddate         : Date?
    var typeofleave     : String?
    var status          : String?
    var remark          : String?
    var requesteddate   : Date?
    var approvername      : String?
    var approvedby      : Int?
    var approveddate    : Date?
    var removedDate     : Date?
    var worker          : Worker?
    
    init() {
        worker               = Worker()
    }
    
    init(row: Row) {
        workerID              = row[RepositoryConstants.Columns.WORKER_ID]
        workername            = row[RepositoryConstants.Columns.WORKER_NAME]
        description           = row[RepositoryConstants.Columns.DESCRIPTION]
        startdate             = row[RepositoryConstants.Columns.START_DATE]
        enddate               = row[RepositoryConstants.Columns.END_DATE]
        typeofleave           = row[RepositoryConstants.Columns.TYPEOF_LEAVE]
        status                = row[RepositoryConstants.Columns.STATUS]
        remark                = row[RepositoryConstants.Columns.REMARK]
        requesteddate         = row[RepositoryConstants.Columns.DATE_REQUESTED]
        approvername                = row[RepositoryConstants.Columns.APPROVER_NAME]
        approvedby            = row[RepositoryConstants.Columns.APPROVED_BY] ?? 0
        approveddate          = row[RepositoryConstants.Columns.APPROVED_DATE]
        removed               = row[RepositoryConstants.Columns.REMOVED]
        removedDate           = createDate(with: row[RepositoryConstants.Columns.REMOVED_DATE])
        worker                = Worker(row: row)
    }
    
   

    func getDataArray() -> [Any] {
        
        let formattedStartdate       = DateManager.dateToString(date: startdate)
        let formattedEnddate         = DateManager.dateToString(date: enddate)
        let formattedRequesteddate   = DateManager.dateToString(date: requesteddate)
        let formattedApproveddate    = DateManager.dateToString(date: approveddate)
        let WorkerName = workername
            
            //worker?.fullName!//(worker?.firstName)! + " " + (worker?.lastName)!

        return [
            WorkerName         as String?  ?? "ghgff",
            self.description   as String?  ?? "",
            formattedStartdate as String?    ?? "",
            formattedEnddate   as String?    ?? "",
            self.typeofleave   as String?  ?? "",
            self.status        as String?  ?? "",
            self.remark        as String?  ?? "",
            formattedRequesteddate        as String?  ?? "",
            self.approvedby    as Int?     ?? 0 ,
            getDateString(date:  self.approveddate),
            getDateString(date:  self.removedDate)
            
        ]
    }
}
