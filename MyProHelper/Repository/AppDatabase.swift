//
//  AppDatabase.swift
//  MyProHelper
//
//  Created by Samir on 11/29/20.
//  Copyright © 2020 Benchmark Computing. All rights reserved.
//
//

import Foundation
import GRDB

private enum Database:String {
    case myProHelperTest1 = "299"
    case mph = "mph"
    
    var path:String? {
        if  self == .myProHelperTest1 {
            if let path = Bundle.main.path(forResource: self.rawValue, ofType: "db") {
                let url = URL(fileURLWithPath: path)
                let result = AppFileManager.saveFile(from: url)
                return result?.path
            }
            return nil
        }
        else {
            if let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
                return "\(path)/\(self.rawValue).sqlite3"
            }
            return nil
        }
    }
}

class AppDatabase {
    
    static let shared: AppDatabase = {
        return AppDatabase()
    }()
    var dbQueue: DatabaseQueue?
    
    private init() {
        connectDatabase(.myProHelperTest1)
    }
    
    private func connectDatabase(_ database:Database) {
        guard let path = database.path else {
            print("++++++++++++++++++++++++++++++")
            print("ERROR GETTING DATABASE PATH")
            print("++++++++++++++++++++++++++++++")
            return
        }
        var configuration = Configuration()
        configuration.readonly = false
        configuration.label = "MyProHelperDatabase"
        do {
            dbQueue = try DatabaseQueue(path: path,
                                        configuration: configuration)
        }
        catch {
            print("++++++++++++++++++++++++++++++")
            print(error)
            print("++++++++++++++++++++++++++++++")
        }
    }
    
    func executeSQL(sql: String, arguments: StatementArguments, success: @escaping (_ id: Int64) -> (), fail: @escaping (_ error: Error) -> ()) {
        guard let queue = AppDatabase.shared.dbQueue else { return }
        var rowID: Int64 = 0
        do {
            try queue.write({ (db) in
                try db.execute(sql: sql,
                               arguments: arguments)
                rowID = db.lastInsertedRowID
            })
            success(rowID)
        }
        catch {
            print(error)
            fail(error)
        }
    }
    
}
