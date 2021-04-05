//
//  WagesDBService.swift
//  MyProHelper
//
//
//  Created by Rajeev Verma on 10/06/1942 Saka.
//  Copyright © 2020 Benchmark Computing. All rights reserved.
//


import Foundation
import GRDB

class WageRepository: BaseRepository {
    
    init() {
        super.init(table: .WAGES)
        createSelectedLayoutTable()
    }
    
    override func setIdKey() -> String {
        return COLUMNS.WAGE_ID
    }

    private func createSelectedLayoutTable() {
        let sql = """
            CREATE TABLE IF NOT EXISTS \(tableName)(
                \(COLUMNS.WAGE_ID)      INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE,
                \(COLUMNS.WORKER_ID)    INTEGER REFERENCES \(TABLES.WORKERS)(\(COLUMNS.WORKER_ID)) NOT NULL,
                \(COLUMNS.SALARY_RATE)                  Real DEFAULT(0.00),
                \(COLUMNS.SALARY_PER_TIME)              TEXT DEFAULT Year,
                \(COLUMNS.HOURLY_RATE)                  Real(0.0) DEFAULT(0.0),
                \(COLUMNS.W4WH)                         REAL(0.0) DEFAULT(0.0),
                \(COLUMNS.W4_EXEPMTIONS)                INTEGER,
                \(COLUMNS.NEEDS_1099)                   INTEGER DEFAULT(0),
                \(COLUMNS.GARNISHMENTS)                 TEXT,
                \(COLUMNS.GARNISHMENT_AMOUNT)           REAL(0.0) DEFAULT(0.0),
                \(COLUMNS.FED_TAX_WH)                   REAL(0.0) DEFAULT(0.0),
                \(COLUMNS.STATE_TAX_WH)                 REAL(0,0) DEFAULT(0.0),
                \(COLUMNS.START_EMPLOYMENT_DATE)        TEXT,
                \(COLUMNS.END_EMPLOYMENT_DATE)          TEXT,
                \(COLUMNS.CURRENT_VACATION_AMOUNT)      REAL(0.0) DEFAULT(0.0),
                \(COLUMNS.VACATION_ACCRUAL_IN_HOURS)    REAL(0.0) DEFAULT(0.0),
                \(COLUMNS.VACATION_HOURS_PER_YEAR)      REAL(0.0) DEFAULT(0.0),
                \(COLUMNS.IS_FIXED_CONTRACT_PRICE)      INTEGER DEFAULT(0),
                \(COLUMNS.CONTRACT_PRICE)               REAL(0.0) DEFAULT(0.0),
                \(COLUMNS.SAMPLE_WAGE)                  INTEGER     DEFAULT(0),
                \(COLUMNS.REMOVED)                      INTEGER     DEFAULT(0),
                \(COLUMNS.REMOVED_DATE)                 TEXT,
                \(COLUMNS.NUMBER_OF_ATTACHMENTS)        NTEGER DEFAULT(0)
            )
        """
        AppDatabase.shared.executeSQL(sql: sql,
                                      arguments: []) { (_) in
            print("TABLE WAGES IS CREATED SUCCESSFULLY")
        } fail: { (error) in
            print(error)
        }
    }
    
    func createWage(wage: Wage, success: @escaping(_ id: Int64) -> (), failure: @escaping(_ error: Error) -> ()) {
        let arguments: StatementArguments = [
            "workerId"                      : wage.workerID,
            "salaryRate"                    : wage.salaryRate,
            "SalaryPerTime"                 : wage.salaryPerTime,
            "HourlyRate"                    : wage.hourlyRate,
            "W4WH"                          : wage.w4wh,
            "W4Exeptions"                   : wage.w4Exemptions,
            "needs1099"                     : wage.needs1099,
            "garnishment"                   : wage.garnishments,
            "garnishmnetAmount"             : wage.garnishmentAmount,
            "fedTaxWH"                      : wage.fedTaxWH,
            "stateTaxWH"                    : wage.stateTaxWH,
            "startEmploymentDate"           : wage.startEmploymentDate,
            "endEmploymentDate"             : wage.endEmploymentDate,
            "currentVacationAmount"         : wage.currentVacationAmount,
            "vacationAccrualRateInHours"    : wage.vacationAccrualRateInHours,
            "vacationHoursPerYear"          : wage.vacationHoursPerYear,
            "isFixedContractPrice"          : wage.isFixedContractPrice,
            "contractPrice"                 : wage.contractPrice,
            "removed"                       : wage.removed,
            "removeDate"                    : DateManager.getStandardDateString(date: wage.removedDate),
            "numberOfAttachments"           : wage.numberOfAttachments
        ]
        let sql = """
            INSERT INTO \(tableName) (
                \(COLUMNS.WORKER_ID),
                \(COLUMNS.SALARY_RATE),
                \(COLUMNS.SALARY_PER_TIME),
                \(COLUMNS.HOURLY_RATE),
                \(COLUMNS.W4WH),
                \(COLUMNS.W4_EXEPMTIONS),
                \(COLUMNS.NEEDS_1099),
                \(COLUMNS.GARNISHMENTS),
                \(COLUMNS.GARNISHMENT_AMOUNT),
                \(COLUMNS.FED_TAX_WH),
                \(COLUMNS.STATE_TAX_WH),
                \(COLUMNS.START_EMPLOYMENT_DATE),
                \(COLUMNS.END_EMPLOYMENT_DATE),
                \(COLUMNS.CURRENT_VACATION_AMOUNT),
                \(COLUMNS.VACATION_ACCRUAL_IN_HOURS),
                \(COLUMNS.VACATION_HOURS_PER_YEAR),
                \(COLUMNS.IS_FIXED_CONTRACT_PRICE),
                \(COLUMNS.CONTRACT_PRICE),
                \(COLUMNS.REMOVED),
                \(COLUMNS.REMOVED_DATE),
                \(COLUMNS.NUMBER_OF_ATTACHMENTS)
            )

            VALUES (:workerId,
                    :salaryRate,
                    :SalaryPerTime,
                    :HourlyRate,
                    :W4WH,
                    :W4Exeptions,
                    :needs1099,
                    :garnishment,
                    :garnishmnetAmount,
                    :fedTaxWH,
                    :stateTaxWH,
                    :startEmploymentDate,
                    :endEmploymentDate,
                    :currentVacationAmount,
                    :vacationAccrualRateInHours,
                    :vacationHoursPerYear,
                    :isFixedContractPrice,
                    :contractPrice,
                    :removed,
                    :removeDate,
                    :numberOfAttachments
            )
            """
        AppDatabase.shared.executeSQL(sql: sql,
                                      arguments: arguments,
                                      success: { id in
                                        success(id)
                                      },
                                      fail: failure)
    }
    
    func updateWage(wage: Wage, success: @escaping() -> (), failure: @escaping(_ error: Error) -> ()) {
        let arguments: StatementArguments = [
            "id"                            : wage.wageID,
            "workerId"                      : wage.workerID,
            "salaryRate"                    : wage.salaryRate,
            "SalaryPerTime"                 : wage.salaryPerTime,
            "HourlyRate"                    : wage.hourlyRate,
            "W4WH"                          : wage.w4wh,
            "W4Exeptions"                   : wage.w4Exemptions,
            "needs1099"                     : wage.needs1099,
            "garnishment"                   : wage.garnishments,
            "garnishmnetAmount"             : wage.garnishmentAmount,
            "fedTaxWH"                      : wage.fedTaxWH,
            "stateTaxWH"                    : wage.stateTaxWH,
            "startEmploymentDate"           : wage.startEmploymentDate,
            "endEmploymentDate"             : wage.endEmploymentDate,
            "currentVacationAmount"         : wage.currentVacationAmount,
            "vacationAccrualRateInHours"    : wage.vacationAccrualRateInHours,
            "vacationHoursPerYear"          : wage.vacationHoursPerYear,
            "isFixedContractPrice"          : wage.isFixedContractPrice,
            "contractPrice"                 : wage.contractPrice,
            "removed"                       : wage.removed,
            "removeDate"                    : DateManager.getStandardDateString(date: wage.removedDate),
            "numberOfAttachments"           : wage.numberOfAttachments
        ]
        
        let sql = """
            UPDATE \(tableName) SET
                \(COLUMNS.WORKER_ID)                    = :workerId,
                \(COLUMNS.SALARY_RATE)                  = :salaryRate,
                \(COLUMNS.SALARY_PER_TIME)              = :SalaryPerTime,
                \(COLUMNS.HOURLY_RATE)                  = :HourlyRate,
                \(COLUMNS.W4WH)                         = :W4WH,
                \(COLUMNS.W4_EXEPMTIONS)                = :W4Exeptions,
                \(COLUMNS.NEEDS_1099)                   = :needs1099,
                \(COLUMNS.GARNISHMENTS)                 = :garnishment,
                \(COLUMNS.GARNISHMENT_AMOUNT)           = :garnishmnetAmount,
                \(COLUMNS.FED_TAX_WH)                   = :fedTaxWH,
                \(COLUMNS.STATE_TAX_WH)                 = :stateTaxWH,
                \(COLUMNS.START_EMPLOYMENT_DATE)        = :startEmploymentDate,
                \(COLUMNS.END_EMPLOYMENT_DATE)          = :endEmploymentDate,
                \(COLUMNS.CURRENT_VACATION_AMOUNT)      = :currentVacationAmount,
                \(COLUMNS.VACATION_ACCRUAL_IN_HOURS)    = :vacationAccrualRateInHours,
                \(COLUMNS.VACATION_HOURS_PER_YEAR)      = :vacationHoursPerYear,
                \(COLUMNS.IS_FIXED_CONTRACT_PRICE)      = :isFixedContractPrice,
                \(COLUMNS.CONTRACT_PRICE)               = :contractPrice,
                \(COLUMNS.REMOVED)                      = :removed,
                \(COLUMNS.REMOVED_DATE)                 = :removeDate,
                \(COLUMNS.NUMBER_OF_ATTACHMENTS)        = :numberOfAttachments

            WHERE \(tableName).\(setIdKey()) = :id;
            """
        
        AppDatabase.shared.executeSQL(sql: sql,
                                      arguments: arguments,
                                      success: { _ in
                                        success()
                                      },
                                      fail: failure)
    }
    
    func deleteWage(wage: Wage, success: @escaping() -> (), failure: @escaping(_ error: Error) -> ()) {
        guard let id = wage.wageID else { return }
        softDelete(atId: id, success: success, fail: failure)
    }
    
    func restoreWage(wage: Wage, success: @escaping() -> (), failure: @escaping(_ error: Error) -> ()) {
        guard let id = wage.wageID else { return }
        restoreItem(atId: id, success: success, fail: failure)
    }
}
