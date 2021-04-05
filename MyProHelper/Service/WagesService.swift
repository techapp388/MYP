//
//  WagesService.swift
//  MyProHelper
//
//
//  Created by Benchmark Computing on 30/07/20.
//  Copyright © 2020 Benchmark Computing. All rights reserved.
//

import Foundation

final class WagesService {
    
    private let repository = WageRepository()
    
    func createWage(_ wage: Wage, completion: @escaping ((Result<Int64, ErrorResult>) -> Void)) {
        repository.createWage(wage: wage) { (wageId) in
            completion(.success(wageId))
        } failure: { (error) in
            completion(.failure(.custom(string: error.localizedDescription)))
        }

    }
    
    func updateWage(_ wage: Wage, completion: @escaping ((Result<String, ErrorResult>) -> Void)) {
        repository.updateWage(wage: wage) {
            completion(.success(""))
        } failure: { (error) in
            completion(.failure(.custom(string: error.localizedDescription)))
        }

    }
}
