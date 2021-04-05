//
//  WorkerRolesGroup.swift
//  MyProHelper
//
//  Created by Benchmark Computing on 29/07/20.
//  Copyright © 2020 Benchmark Computing. All rights reserved.
//

import Foundation
import GRDB

struct WorkerRolesGroup: RepositoryBaseModel {
    var workerRolesGroupID  : Int?
    var groupName           : String?
    var role                : Role
    var removed             : Bool?
    var removedBy           : Int?
    var removedDate         : Date?
    
    init() {
        role = Role()
    }
    
    init(row: Row) {
        let columns = RepositoryConstants.Columns.self
        workerRolesGroupID  = row[columns.WORKER_ROLES_GROUP_ID]
        groupName           = row[columns.GROUP_NAME]
        removedBy           = row[columns.REMOVED_BY]
        removed             = row[columns.REMOVED]
        removedDate         = DateManager.stringToDate(string: row[columns.REMOVED_DATE] ?? "")
        role                = Role(row: row)
    }
    
    func getDataArray() -> [Any] {
        //Do To implement this method
        return []
    }
}

