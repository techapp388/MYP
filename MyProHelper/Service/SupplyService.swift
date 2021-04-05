//
//  SupplyService.swift
//  MyProHelper
//
//
//  Created by Deep on 1/20/21.
//  Copyright © 2021 Benchmark Computing. All rights reserved.
//

import Foundation

final class SupplyService {
    
    var dbService = SupplyRepository()
    
    func fetchSupplies(showRemoved: Bool = false, key: String? = nil, sortType: SortType? = nil ,offset: Int, completion:@escaping((Result<[Supply],ErrorResult>) -> Void)) {
        dbService.fetchSupplies(showRemoved: showRemoved, with: key, sortType: sortType, offset: offset) { (supplies) in
            completion(.success(supplies))
        } failure: { (error) in
            completion(.failure(.custom(string: error.localizedDescription)))
        }

    }
    
}
