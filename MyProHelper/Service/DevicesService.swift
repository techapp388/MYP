//
//  DevicesService.swift
//  MyProHelper
//
//
//  Created by Benchmark Computing on 30/07/20.
//  Copyright © 2020 Benchmark Computing. All rights reserved.
//

import Foundation

final class DevicesService {
    
    private let repository = DeviceRepository()
    
    func fetchDevicesList(for worker: Worker,key: String? = nil,sortBy: DeviceFields? = nil, sortType: SortType? = nil ,offset: Int, completion: @escaping ((Result<[Device], ErrorResult>) -> Void)) {
        repository.fetchDevice(for: worker, key: key,sortBy: sortBy, sortType: sortType, offset: offset) { (devices) in
            completion(.success(devices))
        } failure: { (error) in
            completion(.failure(.custom(string: error.localizedDescription)))
        }
    }
    
    func createDevice(device: Device, completion: @escaping ((Result<Int64, ErrorResult>) -> Void)) {
        repository.insertDevice(device: device) { (deviceId) in
            completion(.success(deviceId))
        } failure: { (error) in
            completion(.failure(.custom(string: error.localizedDescription)))
        }

    }
    
    func updateDevice(device: Device, completion: @escaping ((Result<String, ErrorResult>) -> Void)) {
        repository.update(device: device) {
            completion(.success(""))
        } failure: { (error) in
            completion(.failure(.custom(string: error.localizedDescription)))
        }
    }
    
    func deleteDevice(device: Device, completion: @escaping ((Result<String, ErrorResult>) -> Void)) {
        repository.deleteDevice(device: device) {
            completion(.success(""))
        } failure: { (error) in
            completion(.failure(.custom(string: error.localizedDescription)))
        }
    }
    
    func restoreDevice(device: Device, completion: @escaping ((Result<String, ErrorResult>) -> Void)) {
        repository.restoreDevice(device: device) {
            completion(.success(""))
        } failure: { (error) in
            completion(.failure(.custom(string: error.localizedDescription)))
        }
    }
}
