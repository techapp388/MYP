//
//  SupplyUsedItemDelegate.swift
//  MyProHelper
//
//

import Foundation

protocol SupplyUsedItemDelegate {
    func didAddSupply(supply: SupplyUsed)
    func didUpdateSupply(supply: SupplyUsed)
}
