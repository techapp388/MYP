//
//  CreateStockDelegate.swift
//  MyProHelper
//
//

import Foundation

protocol StockViewDelegate {
    func didCreateStock(stock: PartFinder)
    func didUpdateStock(stock: PartFinder)
}
