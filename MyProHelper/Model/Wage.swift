//
//  Wage.swift
//  MyProHelper
//
//  Created by Benchmark Computing on 29/07/20.
//  Copyright © 2020 Benchmark Computing. All rights reserved.
//

import Foundation
import GRDB

struct Wage: RepositoryBaseModel {
    
    var wageID                      : Int?
    var workerID                    : Int?
    var salaryRate                  : Int?
    var salaryPerTime               : String?
    var hourlyRate                  : Int?
    var w4wh                        : Int?
    var w4Exemptions                : Int?
    var needs1099                   : Bool?
    var garnishments                : String?
    var garnishmentAmount           : Int?
    var fedTaxWH                    : Int?
    var stateTaxWH                  : Int?
    var startEmploymentDate         : Date?
    var endEmploymentDate           : Date?
    var currentVacationAmount       : Int?
    var vacationAccrualRateInHours  : Double?
    var vacationHoursPerYear        : Int?
    var isFixedContractPrice        : Bool?
    var contractPrice               : Int?
    var removed                     : Bool?
    var removedDate                 : Date?
    var numberOfAttachments         : Int?
    
    init() { }
    
    init(row: Row) {
        let columns = RepositoryConstants.Columns.self
        
        wageID                      = row[columns.WAGE_ID]
        workerID                    = row[columns.WORKER_ID]
        salaryRate                  = row[columns.SALARY_RATE]
        salaryPerTime               = row[columns.SALARY_PER_TIME]
        hourlyRate                  = row[columns.HOURLY_RATE]
        w4wh                        = row[columns.W4WH]
        w4Exemptions                = row[columns.W4_EXEPMTIONS]
        needs1099                   = row[columns.NEEDS_1099]
        garnishments                = row[columns.GARNISHMENTS]
        garnishmentAmount           = row[columns.GARNISHMENT_AMOUNT]
        fedTaxWH                    = row[columns.FED_TAX_WH]
        stateTaxWH                  = row[columns.STATE_TAX_WH]
        startEmploymentDate         = DateManager.stringToDate(string: row[columns.START_EMPLOYMENT_DATE] ?? "")
        endEmploymentDate           = DateManager.stringToDate(string: row[columns.END_EMPLOYMENT_DATE] ?? "")
        currentVacationAmount       = row[columns.CURRENT_VACATION_AMOUNT]
        vacationAccrualRateInHours  = row[columns.VACATION_ACCRUAL_IN_HOURS]
        vacationHoursPerYear        = row[columns.VACATION_HOURS_PER_YEAR]
        isFixedContractPrice        = row[columns.IS_FIXED_CONTRACT_PRICE]
        contractPrice               = row[columns.CONTRACT_PRICE]
        removed                     = row[columns.REMOVED]
        removedDate                 = DateManager.stringToDate(string: row[columns.REMOVED_DATE] ?? "" )
        numberOfAttachments         = row[columns.NUMBER_OF_ATTACHMENTS]
    }
    
    func getDataArray() -> [Any] {
        //Do To implement this method
        return []
    }
}
