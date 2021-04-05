//
//  CreateSupplyLocationVIewModel.swift
//  MyProHelper
//
//

import Foundation

class CreateSupplyLocationViewModel {
    
    private var supplyLocation = SupplyLocation()
    private var isUpdatingSupplyLocation = false
    private let supplyLocationService = SupplyLocationService()
    
    func setSupplyLocation(supplyLocation: SupplyLocation) {
        self.supplyLocation = supplyLocation
        self.isUpdatingSupplyLocation = true
        self.supplyLocation.updateModifyDate()
    }
    
    func getName() -> String? {
        return supplyLocation.locationName
    }
    
    func getDescription() -> String? {
        return supplyLocation.locationDescription
    }
    
    func setName(name: String?) {
        supplyLocation.locationName = name
    }
    
    func setDescription(description: String?) {
        supplyLocation.locationDescription = description
    }
    
    func validateName() -> ValidationResult {
        return Validator.validateName(name: getName())
    }
    
    func validateDescription() -> ValidationResult {
        guard let description = getDescription(), !description.isEmpty else {
            return .Valid
        }
        return Validator.validateDescription(description: description)
    }
    
    private func isValidData() -> Bool {
        return validateName() == .Valid &&
            validateDescription() == .Valid
    }
    
    func saveSupplyLocation(completion: @escaping (_ error: String?, _ isValidData: Bool) -> ()) {
        if !isValidData() {
            completion(nil, false)
            return
        }
        if isUpdatingSupplyLocation {
            updateSupplyLocation { (error) in
                completion(error, true)
            }
        }
        else {
            createSupplyLocation { (error) in
                completion(error, true)
            }
        }
    }
    
    private func updateSupplyLocation(completion: @escaping (_ error: String?)->()) {
        supplyLocationService.updateSupplyLocation(supplyLocation: supplyLocation) { (result) in
            switch result {
            case .success(_):
                completion(nil)
                
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    private func createSupplyLocation(completion: @escaping (_ error: String?)->()) {
        supplyLocationService.createSupplyLocation(supplyLocation: supplyLocation) { (result) in
            switch result {
            case .success(_):
                completion(nil)
                
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
}
