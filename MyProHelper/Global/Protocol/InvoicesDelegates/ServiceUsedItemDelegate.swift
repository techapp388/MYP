//
//  ServiceUsedItemDelegate.swift
//  MyProHelper
//
//

import Foundation

protocol ServiceUsedItemDelegate {
    func didAddService(service: ServiceUsed)
    func didUpdateService(service: ServiceUsed)
}
