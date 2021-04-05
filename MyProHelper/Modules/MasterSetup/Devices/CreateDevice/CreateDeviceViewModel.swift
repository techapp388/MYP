//
//  CreateDeviceViewModel.swift
//  MyProHelper
//
//

import Foundation

class CreateDeviceViewModel {
    
    private let service = DevicesService()
    private var isUpdatingDevice = false
    private var workers: [Worker] = []
    var device:Box<Device> = Box(Device())

    func setDevice(device: Device) {
        self.device.value = device
        self.isUpdatingDevice = true
    }
    
    func setDeviceName(name: String?) {
        device.value.deviceName = name
    }
    
    func setDeviceType(type: String?) {
        device.value.deviceType = type
    }
    
    func setWorker(worker: Worker) {
        device.value.worker = worker
        device.value.workerID = worker.workerID
    }
    
    func setWorker(at index: Int) {
        device.value.worker = workers[index]
        device.value.workerID = workers[index].workerID
    }
    
    func getDeviceType() -> String? {
        return device.value.deviceType
    }
    
    func getDeviceName() -> String? {
        return device.value.deviceName
    }
    
    func getWorkerName() -> String? {
        return device.value.worker?.fullName
    }
    
    func getWorkers() -> [String] {
        return workers.compactMap({ $0.fullName })
    }
    
    func validateDeviceName() -> ValidationResult {
        return Validator.validateName(name: device.value.deviceName)
    }
    
    func validateDeviceType() -> ValidationResult {
        return Validator.validateDeviceType(type: device.value.deviceType)
    }
    
    func validateWorker() -> ValidationResult {
        if device.value.workerID != nil {
            return .Valid
        }
        return .Invalid(message: "EMPTY_WORKER_ERROR".localize)
    }
    
    private func isValidData() -> Bool {
        return validateDeviceName() == .Valid &&
            validateDeviceType()    == .Valid &&
            validateWorker()        == .Valid
    }
    
    func saveDevice(completion: @escaping (_ error: String?, _ isValidData: Bool) -> ()) {
        if !isValidData() {
            completion(nil, false)
            return
        }
        if isUpdatingDevice {
            updateDevice { (error) in
                completion(error, true)
            }
        }
        else {
            createDevice { (error) in
                completion(error, true)
            }
        }
    }
    
    func fetchWorkers(completion: @escaping () -> ()) {
        let workerService = WorkersService()
        let offset = workers.count
        workerService.fetchWorkers(offset: offset) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let workers):
                self.workers = workers
                completion()
                
            case .failure(let error):
                print(error)
                completion()
            }
        }
    }
    
    private func updateDevice(completion: @escaping (_ error: String?)->()) {
        service.updateDevice(device: device.value) { (result) in
            switch result {
            case .success(_):
                completion(nil)
                
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    private func createDevice(completion: @escaping (_ error: String?)->()) {
        service.createDevice(device: device.value) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let deviceId):
                self.device.value.deviceID = Int(deviceId)
                completion(nil)
                
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
}
