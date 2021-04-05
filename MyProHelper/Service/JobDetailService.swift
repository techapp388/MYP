//
//  JobDetailService.swift
//  MyProHelper
//
//
//  Created by Deep on 1/20/21.
//  Copyright © 2021 Benchmark Computing. All rights reserved.
//

import Foundation

final class JobDetailService {

    private let repository = JobDetailRepository()
    
    func fetchJobDetail(showRemoved: Bool = false, key: String? = nil, sortBy: JobDetailListField? = nil,sortType: SortType? = nil ,offset: Int, completion:@escaping((Result<[JobDetail],ErrorResult>) -> Void)) {
        repository.fetchJobDetail(showRemoved: showRemoved,
                                with: key,
                                sortBy: sortBy,
                                sortType: sortType,
                                offset: offset) { (jobArray) in
            completion(.success(jobArray))
        } failure: { (error) in
            completion(.failure(.custom(string: error.localizedDescription)))
        }
    }
}
