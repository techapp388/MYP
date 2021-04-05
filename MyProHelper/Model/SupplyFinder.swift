//
//  SupplyFinder.swift
//  MyProHelper
//
//
//  Created by Deep on 1/31/21.
//  Copyright © 2021 Benchmark Computing. All rights reserved.
//

import GRDB

struct SupplyFinder: RepositoryBaseModel {
    
    var supplyFinderId      : Int?
    var supplyId            : Int?
    var supplyLocationID    : Int?
    var quantity            : Int?
    var wherePurchased      : Int?
    var lastPurchased       : Date?
    var pricePaid           : Double?
    var priceToResell       : Double?
    var removed             : Bool?
    var removedDate         : Date?
    
    init() { }
    
    init(row: GRDB.Row) {
        let column = RepositoryConstants.Columns.self
        
        supplyFinderId      = row[column.SUPPLY_FINDER_ID]
        supplyId            = row[column.SUPPLY_ID]
        quantity            = row[column.QUANTITY]
        wherePurchased      = row[column.WHERE_PURCHASED]
        lastPurchased       = createDate(with: column.LAST_PURHCASED)
        pricePaid           = row[column.PRICE_PAID]
        priceToResell       = row[column.PRICE_TO_RESELL]
        removed             = row[column.REMOVED]
        removedDate         = createDate(with: column.REMOVED_DATE)
    }
    
    func getDataArray() -> [Any] {
        let lastPurchasedString = DateManager.dateToString(date: lastPurchased)
        
        return [
            getIntValue(value: quantity),
            getStringValue(value: lastPurchasedString),
            getDoubleValue(value: pricePaid),
            getDoubleValue(value: priceToResell),
        ]
    }
    
}
