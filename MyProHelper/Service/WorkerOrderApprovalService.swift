//
//  WorkerOrderApprovalService.swift
//  MyProHelper
//
//  Created by Sarvesh on 21/04/21.
//  Copyright © 2021 Benchmark Computing. All rights reserved.
//



import Foundation

final class WorkerOrderApprovalService {
    
    private let dbService = WorkerOrderApprovalRepository()
    
    func fetchApproval(showRemoved: Bool = false , key: String? = nil, sortBy: WorkerOrderApprovalField? = nil, sortType: SortType? = nil , offset: Int, completion:@escaping((Result<[Approval],ErrorResult>) -> Void)) {
        dbService.fetchApproval(showRemoved: showRemoved, with: key, sortBy: sortBy, sortType: sortType, offset: offset) { (workers) in
            completion(.success(workers))
        } failure: { (error) in
            completion(.failure(.custom(string: error.localizedDescription)))
        }
    }
    
    func createApproval(_ approval: WorkerOrderApprovel, completion: @escaping ((Result<Int64, ErrorResult>) -> Void)) {
        dbService.createApproval(worker: approval, success: { workerId in
            completion(.success(workerId))
        }) { error in
            completion(.failure(.custom(string: error.localizedDescription)))
        }
    }
    
    func updateApproval(_ approval: Approval, completion: @escaping ((Result<String, ErrorResult>) -> Void)) {
        dbService.updateApproval(worker: approval, success: {
            completion(.success(""))
        }) { error in
            completion(.failure(.custom(string: error.localizedDescription)))
        }
    }
    
    func deleteApproval(_ approval: Approval, completion: @escaping ((Result<String, ErrorResult>) -> Void)) {
        dbService.deleteApproval(worker: approval) {
            completion(.success(""))
        } failure: { (error) in
            completion(.failure(.custom(string: error.localizedDescription)))
        }
    }
    func restoreApproval(_ approval: Approval, completion: @escaping ((Result<String, ErrorResult>) -> Void)) {
        dbService.restoreApproval(worker: approval) {
            completion(.success(""))
        } failure: { (error) in
            completion(.failure(.custom(string: error.localizedDescription)))
        }
    }
}
